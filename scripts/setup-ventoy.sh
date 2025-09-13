#!/usr/bin/env bash

# Script d'installation et de configuration de Ventoy pour une clé USB multi-boot.
# DESTROY ALL DATA on the target device. Use only on the intended USB drive.
# Usage: sudo ./scripts/setup-ventoy.sh /dev/sda
#
# This script will:
#   * Télécharger et installer Ventoy sur la clé USB spécifiée.
#   * Créer la structure de dossiers utilisée par ce projet.
#   * Générer un fichier ventoy.json avec un exemple de plugin (thème, options).
#   * Créer un thème minimal par défaut.
#
# Exécuté en environnement isolé et légal uniquement.

set -euo pipefail

DEVICE="${1:-/dev/sda}"          # Chemin du périphérique USB (ex : /dev/sda)
VENTOY_VERSION="1.0.99"          # Version de Ventoy à installer
VENTOY_URL="https://github.com/ventoy/Ventoy/releases/download/v${VENTOY_VERSION}/ventoy-${VENTOY_VERSION}-linux.tar.gz"

if [[ $EUID -ne 0 ]]; then
  echo "[ERREUR] Ce script doit être exécuté en root." >&2
  exit 1
fi

if [[ ! -b "$DEVICE" ]]; then
  echo "[ERREUR] Périphérique $DEVICE introuvable." >&2
  exit 1
fi

read -r -p "⚠️ Cela VA EFFACER toutes les données sur $DEVICE. Tapez OUI pour continuer: " confirm
if [[ "$confirm" != "OUI" ]]; then
  echo "Abandon." >&2
  exit 1
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

cd "$TMPDIR"
echo "Téléchargement de Ventoy $VENTOY_VERSION..."
curl -L -o ventoy.tar.gz "$VENTOY_URL"
tar -xzf ventoy.tar.gz
cd ventoy-*/

# Installation de Ventoy sur le périphérique
./Ventoy2Disk.sh -I -g -s "$DEVICE"

# Montage de la partition de données (généralement la 2e partition)
PARTITION="${DEVICE}2"
mkdir -p /mnt/ventoy
mount "$PARTITION" /mnt/ventoy

# Création de la structure de dossiers
mkdir -p /mnt/ventoy/{ISOs,Persistence,Docs/{OS,Outils,YubiKey,Crypto,Scenarios},Medical,Outils,Cases,Backup}

# Fichier de configuration Ventoy (plugins)
mkdir -p /mnt/ventoy/ventoy
cat > /mnt/ventoy/ventoy/ventoy.json <<'JSON'
{
  "theme": {
    "file": "/ventoy/theme/theme.txt"
  },
  "control": {
    "VTOY_DEFAULT_SEARCH_ROOT": "/ISOs"
  }
}
JSON

# Thème minimal
mkdir -p /mnt/ventoy/ventoy/theme
cat > /mnt/ventoy/ventoy/theme/theme.txt <<'THEME'
# Thème minimal pour Ventoy
set timeout=10
set default=0
set menu_color_normal=white/black
set menu_color_highlight=yellow/blue
THEME

sync
umount /mnt/ventoy

echo "Ventoy installé sur $DEVICE et structure initiale créée."
