# CyberLab USB – Projet personnel de cybersécurité, IA, OPSEC et hacking éthique

## Présentation

Ce projet vise à documenter, organiser et automatiser la création d’une clé USB multi-boot avancée, dédiée à l’apprentissage et à l’expérimentation en cybersécurité, IA, social engineering, pentesting, forensic, hardware/software, et OPSEC.

> ⚠️ **Tout est fait en environnement isolé (VM, lab, CTF, machines personnelles), jamais en réel ou hors cadre légal.**

---

## Matériel & Contexte

* **Clé USB principale :** EMTEC 64Go USB 3.0
* **Laptop :** Acer Nitro ANV15-41 (AMD Ryzen 5 7535HS, 16 Go RAM, Radeon 660M + RTX 4050, SSD 512 Go)
* **OS principal :** Ubuntu 25.04 (Wayland, GNOME 48, kernel 6.14), dual boot Windows 11 possible
* **Authentification forte :** YubiKey 5 NFC & 5Ci
* **Abonnements :** GitHub Developer Student Pack, ChatGPT Business

---

## Environnement logiciel

* **Boot manager** : Ventoy (interface graphique personnalisée, plugins themes/persistence)
* **ISOs incluses** :

  * Kali Linux (pentesting)
  * Parrot OS HTB (pentesting, lab)
  * Tails (anonymat, usage sensible)
  * Ubuntu (usage quotidien, dev, IA, crypto)
  * Windows 11 (dual boot, compatibilité)
  * Qubes OS (sécurité par compartimentation)
  * DEFT, CAINE (forensic)
  * CLIP OS (OS sécurisé, pour training)
  * MediCat, Hiren’s Boot CD (dépannage)
* **Outils portables :**

  * Yubico tools (`ykman`), GPG/PGP, VeraCrypt, KeePassXC, SysInternals, NirSoft…
  * Logiciels IA : Notum, accès API OpenAI (via ChatGPT Business), outils IA open source

---

## Structure de la clé et du projet

```
/ISOs              # Tous les ISO bootables
/Persistence       # Fichiers de persistence pour OS compatibles
/Docs              # Documentation générale
    /OS            # Fiches OS, guides d’installation
    /Outils        # Fiches outils, usages, scénarios
    /YubiKey       # Procédures crypto, fiches OPSEC, backup, recovery
    /Crypto        # Guides PGP, chiffrement, GPG, fiches clés
    /Scenarios     # Scénarios CTF, Hack The Box, social engineering, IA, etc.
/Medical           # Outils de dépannage type MediCat, Hiren’s, scripts de recovery
/Outils            # Exécutables portables, scripts
/Cases             # Exercices, challenges, labs persos
/Backup            # Duplicatas de docs, configs critiques
```

---

## Objectifs pédagogiques

* **Apprendre toutes les branches de la cybersécurité** (pentest, OSINT, forensic, anonymat, IA…)
* **Relier hardware, software, IA, et social engineering**
* **Expérimenter les attaques/défenses en environnement isolé**
* **Documenter chaque étape** (fiches pratiques, playbooks, procédures OPSEC, scénarios lab)
* **Veille régulière sur les outils, les pratiques et le business IA**

---

## Guides & Playbooks

* Création & organisation de la clé USB multi-boot
* Installation/configuration de chaque OS
* Initialisation, backup et utilisation avancée des YubiKey pour le chiffrement, l’authentification, le stockage sécurisé
* Scénarios de pentest, forensic, social engineering, IA-to-IA red teaming
* Sécurisation des partitions, gestion du chiffrement (VeraCrypt, LUKS)
* Procédure pour récupération et réinstallation de la licence Windows 11

---

## Script d'automatisation Ventoy

Le script `scripts/setup-ventoy.sh` automatise l'installation de Ventoy sur la clé USB (`/dev/sda` par défaut), crée l'arborescence et ajoute un thème minimal via `ventoy.json`.

## Ressources

* [Ventoy](https://ventoy.net)
* [Parrot OS HTB](https://parrotsec.org/download-htb.php)
* [Kali Linux](https://www.kali.org/downloads/)
* [Qubes OS](https://www.qubes-os.org/downloads/)
* [Yubico](https://support.yubico.com/)
* [ChatGPT Business](https://chat.openai.com)
* [Hack The Box](https://www.hackthebox.com/)
* [TryHackMe](https://tryhackme.com/)

---

> **Attention : usage strictement éducatif, personnel, lab/test, jamais en réel. Respecter la législation et l’éthique.**

---
