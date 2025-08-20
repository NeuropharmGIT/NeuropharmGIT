#!/usr/bin/env bash
set -e

# Script to bootstrap the Notum project in the user's Desktop directory.
# Usage: ./setup_notum.sh [target_directory]
# Default target_directory: /home/heisen/Bureau/notum

TARGET_DIR="${1:-/home/heisen/Bureau/notum}"

echo "Creating project at $TARGET_DIR"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Create directory structure
mkdir -p notum/processor notum/llm ui

# notum/scraper.py
cat <<'PYEOF' > notum/scraper.py
import asyncio
import aiohttp
from bs4 import BeautifulSoup

async def fetch(session, url: str) -> str:
    async with session.get(url, timeout=10) as resp:
        resp.raise_for_status()
        return await resp.text()

async def scrape(urls: list[str]) -> dict[str, str]:
    """Scrape plusieurs URLs en parallèle."""
    async with aiohttp.ClientSession() as session:
        tasks = [fetch(session, u) for u in urls]
        responses = await asyncio.gather(*tasks)
    return {u: BeautifulSoup(html, "html.parser").get_text() for u, html in zip(urls, responses)}
PYEOF

# notum/db.py
cat <<'PYEOF' > notum/db.py
import sqlite3
from pathlib import Path

DB_PATH = Path("notum.db")

def init_db() -> None:
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("""
    CREATE TABLE IF NOT EXISTS documents (
        id INTEGER PRIMARY KEY,
        url TEXT UNIQUE,
        content TEXT,
        tag TEXT
    )""")
    conn.commit()
    conn.close()

def insert_document(url: str, content: str, tag: str) -> None:
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("""
    INSERT OR IGNORE INTO documents (url, content, tag)
    VALUES (?, ?, ?)
    """, (url, content, tag))
    conn.commit()
    conn.close()
PYEOF

# notum/processor/dedupe.py
cat <<'PYEOF' > notum/processor/dedupe.py
import hashlib

def hash_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()

def is_duplicate(text: str, known_hashes: set[str]) -> bool:
    h = hash_text(text)
    if h in known_hashes:
        return True
    known_hashes.add(h)
    return False
PYEOF

# notum/processor/classify.py
cat <<'PYEOF' > notum/processor/classify.py
def classify_text(text: str) -> str:
    """Classification très simple par mots-clés."""
    text_lower = text.lower()
    if "rapport" in text_lower and "médical" in text_lower:
        return "rapport_médical"
    if "stanley" in text_lower:
        return "récit_stanley"
    return "autre"
PYEOF

# notum/llm/analyze.py
cat <<'PYEOF' > notum/llm/analyze.py
import subprocess
import json

def summarize(text: str, model: str = "mistral") -> str:
    """Utilise Ollama pour résumer un texte (modèle open source)."""
    prompt = f"Résume le texte suivant:\n\n{text}"
    result = subprocess.run(
        ["ollama", "run", model],
        input=prompt.encode("utf-8"),
        stdout=subprocess.PIPE,
        check=True
    )
    return result.stdout.decode("utf-8").strip()

def debate(prompt: str, model_a="mistral", model_b="phi") -> dict:
    """Fait débattre deux modèles Ollama."""
    reply_a = subprocess.run(["ollama", "run", model_a], input=prompt.encode(), stdout=subprocess.PIPE, check=True)
    reply_b = subprocess.run(["ollama", "run", model_b], input=prompt.encode(), stdout=subprocess.PIPE, check=True)
    return {
        "prompt": prompt,
        "model_a": reply_a.stdout.decode().strip(),
        "model_b": reply_b.stdout.decode().strip(),
    }
PYEOF

# notum/__init__.py
cat <<'PYEOF' > notum/__init__.py
# Package initializer
PYEOF

# ui/app.py
cat <<'PYEOF' > ui/app.py
import streamlit as st
import asyncio
from notum.scraper import scrape
from notum.processor import dedupe, classify
from notum.db import init_db, insert_document
from notum.llm.analyze import summarize

st.title("Notum – Scraper IA")

init_db()
url = st.text_input("URL à scraper (séparées par des virgules)")
if st.button("Lancer"):
    urls = [u.strip() for u in url.split(",") if u.strip()]
    if urls:
        with st.spinner("Scraping en cours..."):
            results = asyncio.run(scrape(urls))
        st.success("Scraping terminé !")

        known_hashes = set()
        for u, text in results.items():
            if dedupe.is_duplicate(text, known_hashes):
                st.warning(f"Doublon détecté : {u}")
                continue
            tag = classify.classify_text(text)
            insert_document(u, text, tag)
            st.markdown(f"### {u} (`{tag}`)")
            st.text_area("Texte brut", text[:1000])

            if st.checkbox(f"Résumer {u}", key=u):
                summary = summarize(text)
                st.write(summary)
    else:
        st.warning("Merci de fournir au moins une URL.")
PYEOF

# requirements.txt
cat <<'REQEOF' > requirements.txt
aiohttp
beautifulsoup4
streamlit
REQEOF

# README.md
cat <<'MD' > README.md
# Notum

Projet local de scraping et d'analyse IA.

## Installation

```bash
bash setup_notum.sh
```

Le script crée l'environnement dans /home/heisen/Bureau/notum par défaut.

## Lancement

```bash
source /home/heisen/Bureau/notum/.venv/bin/activate
streamlit run ui/app.py
```

Assurez-vous d'installer [Ollama](https://ollama.com/) et les modèles nécessaires (mistral, phi, etc.).
MD

# Create virtual environment and install dependencies
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt

echo "Setup complete! Activate the environment with:"
echo "source $TARGET_DIR/.venv/bin/activate"
echo "Then run the app with: streamlit run ui/app.py"
