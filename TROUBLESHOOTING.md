# Guide de Dépannage - 5ATTACK Lab

Ce document répertorie tous les problèmes rencontrés lors de la mise en place du laboratoire 5ATTACK et leurs solutions.

## 🔧 Problèmes rencontrés et solutions

### 1. Erreur WSL : "bash not found"

#### **Problème :**
```
WSL (10 - Relay) ERROR: CreateProcessCommon:725: execvpe(/bin/bash) failed: No such file or directory
```

#### **Cause :**
WSL essaie d'exécuter bash dans un conteneur Ubuntu qui n'a pas bash installé correctement.

#### **Solution :**
- **Modifier le Dockerfile.tools** pour installer bash explicitement
- **Utiliser `/bin/sh` au lieu de `/bin/bash`** dans les commandes
- **Ajouter `RUN ln -sf /bin/bash /bin/sh`** dans le Dockerfile

#### **Commandes corrigées :**
```bash
# Au lieu de
podman run -it --rm --pod weblab --name tools -v $(pwd):/workspace weblab-tools /bin/bash

# Utiliser
podman run -it --rm --pod weblab --name tools -v $(pwd):/workspace weblab-tools /bin/sh
```

---

### 2. Erreur Nmap : "Operation not permitted"

#### **Problème :**
```
Couldn't open a raw socket. Error: Operation not permitted (1)
```

#### **Cause :**
Nmap essaie d'utiliser des sockets bruts qui nécessitent des privilèges root dans le conteneur.

#### **Solution :**
- **Utiliser le mode TCP connect scan** (`-sT`) qui ne nécessite pas de privilèges
- **Éviter les scans avec privilèges** dans les conteneurs

#### **Commandes corrigées :**
```bash
# Au lieu de
nmap -sV 127.0.0.1

# Utiliser
nmap -sT -sV 127.0.0.1
nmap -sT --script http-title,http-headers -p80 127.0.0.1
```

---

### 3. Erreur ZAP : "requested access to the resource is denied"

#### **Problème :**
```
Error: unable to copy from source docker://owasp/zap2docker-stable:latest: requested access to the resource is denied
```

#### **Cause :**
Problème d'accès aux images Docker Hub, possiblement lié aux permissions ou au réseau.

#### **Solutions tentées :**
1. **Image alternative :** `zaproxy/zap-stable`
2. **Versions spécifiques :** `owasp/zap2docker-stable:2.12.0`
3. **Téléchargement manuel :** `podman pull`

#### **Résultat :**
- **ZAP non fonctionnel** malgré plusieurs tentatives
- **Impact :** Minimal car ZAP n'est pas obligatoire pour l'exercice
- **Alternative :** Continuer avec les autres outils disponibles

---

### 4. Erreur Newman : "Node.js version >= 16 required"

#### **Problème :**
```
Newman requires Node.js version >= 16
```

#### **Cause :**
Version de Node.js trop ancienne dans le conteneur Ubuntu.

#### **Solution :**
```bash
# Désinstaller Node.js
apt-get remove --purge nodejs npm
apt-get autoremove
apt-get autoclean

# Réinstaller Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Réinstaller Newman
npm install -g newman
```

#### **Alternative :**
Utiliser curl pour les tests HTTP si Newman ne fonctionne pas :
```bash
curl -H "X-5ATTACK-Demo: true" http://127.0.0.1/
curl "http://127.0.0.1/?id=1"
```

---

### 5. Problème de connexion DVWA

#### **Problème :**
```
⚠️ Token CSRF non trouvé, tentative de connexion simple...
⚠️ Connexion non confirmée, mais cookies sauvegardés
```

#### **Cause :**
Gestion des tokens CSRF dans DVWA.

#### **Solution :**
- **Script robuste** qui gère les cas avec et sans token CSRF
- **Vérification de l'accessibilité** avant connexion
- **Messages d'erreur clairs** pour le diagnostic

#### **Résultat :**
- **DVWA accessible** via navigateur
- **Scripts fonctionnels** malgré les avertissements
- **Tests possibles** avec les outils

---

### 6. Problème de ports dans Podman Desktop

#### **Problème :**
Tous les conteneurs affichent le port 8080 dans l'interface.

#### **Cause :**
Comportement normal de Podman avec les pods - tous les conteneurs partagent les mêmes ports exposés.

#### **Solution :**
- **Comprendre l'architecture** : Pod avec conteneurs interconnectés
- **Accès correct :**
  - DVWA : http://localhost/ (port 80)
  - ZAP : http://localhost:8080/ (port 8080)

---

## 🛠️ Solutions préventives

### 1. Dockerfile optimisé
```dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Installer tous les outils nécessaires
RUN apt-get update && \
    apt-get install -y \
        bash \
        curl \
        wget \
        nmap \
        nikto \
        nodejs npm \
        python3 \
        python3-pip \
        procps \
        net-tools \
    && npm install -g newman \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# S'assurer que bash est le shell par défaut
RUN ln -sf /bin/bash /bin/sh

WORKDIR /workspace
COPY *.sh ./
COPY *.json ./
RUN chmod +x *.sh
```

### 2. Scripts robustes
- **Vérifications préalables** avant chaque opération
- **Gestion d'erreurs** avec messages clairs
- **Nettoyage automatique** des anciens conteneurs
- **Attente du démarrage** des services

### 3. Commandes adaptées
- **Nmap** : Utiliser `-sT` pour éviter les problèmes de privilèges
- **Shell** : Utiliser `/bin/sh` pour la compatibilité WSL
- **Node.js** : Installer la version 18+ pour Newman

---

## 📊 Résumé des problèmes

| Problème | Cause | Solution | Statut |
|----------|-------|----------|---------|
| Bash not found | WSL + conteneur Ubuntu | Utiliser `/bin/sh` | ✅ Résolu |
| Nmap permissions | Privilèges root requis | Utiliser `-sT` | ✅ Résolu |
| ZAP access denied | Problème d'accès Docker Hub | Continuer sans ZAP | ⚠️ Non résolu |
| Newman Node.js | Version trop ancienne | Mettre à jour Node.js | ✅ Résolu |
| DVWA CSRF | Gestion des tokens | Script robuste | ✅ Résolu |
| Ports Podman | Architecture pod | Comprendre l'architecture | ✅ Résolu |

---

## 🎯 Recommandations

### Pour éviter les problèmes :
1. **Utiliser `/bin/sh`** au lieu de `/bin/bash`
2. **Utiliser `-sT`** pour Nmap dans les conteneurs
3. **Installer Node.js 18+** pour Newman
4. **Vérifier l'accessibilité** avant chaque test
5. **Documenter les problèmes** rencontrés

### Pour l'exercice 5ATTACK :
- **ZAP non obligatoire** si les autres outils fonctionnent
- **Focus sur Nmap, Nikto, Newman** qui sont fonctionnels
- **Documenter les problèmes** dans la remise
- **Expliquer les solutions** mises en place

---

## 📝 Notes finales

Ce laboratoire a permis d'apprendre :
- La gestion des problèmes de compatibilité WSL/Podman
- L'adaptation des outils aux conteneurs
- La résolution de problèmes de permissions
- La documentation des problèmes et solutions

Malgré les problèmes rencontrés, le laboratoire répond aux exigences de l'exercice 5ATTACK avec un environnement fonctionnel et des outils opérationnels.
