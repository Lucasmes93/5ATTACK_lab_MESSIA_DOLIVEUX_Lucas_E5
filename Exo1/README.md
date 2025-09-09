# 5ATTACK – Lab Web pour Windows

Laboratoire d'apprentissage pour les attaques web avec DVWA et outils de sécurité, optimisé pour Windows et Podman Desktop.

## 🎯 Objectif
Créer un environnement simple et fonctionnel pour apprendre les tests de sécurité web sur Windows avec Podman Desktop, dans le cadre de l'exercice 5ATTACK.

## 📦 Contenu du projet
- `Dockerfile.tools` – Image Ubuntu avec les outils essentiels
- `setup_pod.sh` – Script de déploiement automatique
- `login_dvwa.sh` – Connexion automatique à DVWA avec gestion CSRF
- `examples.sh` – Exemples d'utilisation des outils
- `dvwa_postman_collection.json` – Collection Postman pour les tests
- `setup_pod.ps1` – Script PowerShell alternatif
- `start_tools.ps1` – Script PowerShell pour démarrer les outils
- `TROUBLESHOOTING.md` – Guide de dépannage

## 🚀 Démarrage rapide

### Prérequis
- Podman Desktop installé sur Windows
- PowerShell ou Command Prompt

### Méthode 1 : Script automatique
```powershell
# Dans PowerShell
cd C:\Users\MESSIA\Desktop\5ATTACK_lab
bash setup_pod.sh
```

### Méthode 2 : Commandes manuelles
```powershell
# Nettoyer les anciens conteneurs
podman pod rm -f weblab 2>$null
podman container rm -f dvwa zap tools 2>$null

# Créer le pod
podman pod create --name weblab -p 80:80 -p 8080:8080

# Démarrer DVWA
podman run -d --pod weblab --name dvwa vulnerables/web-dvwa

# Démarrer ZAP
podman run -d --pod weblab --name zap owasp/zap2docker-stable zap.sh -daemon -port 8080 -host 0.0.0.0

# Construire les outils
podman build -t weblab-tools -f Dockerfile.tools .
```

## 🖥️ Utilisation avec Podman Desktop

### 1. Vérifier les conteneurs
- Ouvrez **Podman Desktop**
- Allez dans **"Containers"**
- Vérifiez que le pod `weblab` contient :
  - `dvwa` (cible d'attaque)
  - `tools` (outils de test)
  - `zap` (proxy de sécurité)
  - Conteneur d'infrastructure

### 2. Se connecter au conteneur d'outils
**Option A : Via l'interface**
- Cliquez sur le conteneur `tools`
- Cliquez sur l'icône terminal (🖥️)

**Option B : Via PowerShell**
```powershell
podman exec -it tools /bin/sh
```

### 3. Dans le conteneur d'outils
```bash
# Aller dans le workspace
cd /workspace

# Vérifier les fichiers
ls

# Se connecter à DVWA
bash login_dvwa.sh

# Tester tous les outils
bash examples.sh
```

## 🌐 Accès aux services
- **DVWA** : http://localhost/ (admin/password)
- **ZAP** : http://localhost:8080/ (si fonctionnel)

## 📋 Outils installés
- **Nmap** : Scan de ports et services
- **Nikto** : Scanner de vulnérabilités web
- **Newman** : Tests automatisés avec Postman
- **CURL** : Tests de connexion HTTP
- **ZAP** : Proxy de sécurité web

## 🔧 Fonctionnalités
- ✅ Gestion automatique des tokens CSRF
- ✅ Vérification de l'accessibilité des services
- ✅ Nettoyage automatique des anciens conteneurs
- ✅ Messages d'erreur clairs
- ✅ Compatible Windows/Podman Desktop
- ✅ Interface graphique Podman Desktop

## ⚠️ Usage éthique
Utilisez ces outils UNIQUEMENT sur votre DVWA local pour l'apprentissage.

## 🆘 Dépannage
Consultez le fichier `TROUBLESHOOTING.md` pour les problèmes courants et leurs solutions.

## 📊 Structure du projet
```
5ATTACK_lab/
├── Dockerfile.tools          # Image des outils
├── setup_pod.sh             # Script de déploiement
├── login_dvwa.sh            # Connexion DVWA
├── examples.sh              # Exemples d'utilisation
├── dvwa_postman_collection.json  # Collection Postman
├── setup_pod.ps1            # Script PowerShell
├── start_tools.ps1          # Démarrage outils
├── README.md                # Ce fichier
└── TROUBLESHOOTING.md       # Guide de dépannage
```

## 🎓 Utilisation pédagogique
Ce laboratoire permet d'apprendre :
- La reconnaissance de cibles web
- L'identification de vulnérabilités
- L'utilisation d'outils de pentest
- La gestion d'environnements containerisés
- Les bonnes pratiques de sécurité éthique

## 📝 Notes
- Le projet utilise Podman avec des pods pour l'isolation
- DVWA est configuré avec un niveau de sécurité "LOW"
- Tous les outils sont pré-configurés et prêts à l'emploi
- L'environnement est entièrement reproductible

## 🏆 Conformité aux exigences 5ATTACK

### ✅ Outils obligatoires
- **Postman** (via Newman) ✅
- **OWASP ZAP** (proxy de test de sécurité) ⚠️
- **Nmap** (scan réseau, cartographie) ✅
- **Nikto** (scanner de vulnérabilités Web) ✅

### ✅ Cible d'attaque
- **DVWA** (Damn Vulnerable Web Application) ✅

### ✅ Démonstrations
- **Au moins 2 fonctionnalités par outil** ✅
- **Tests sur la cible DVWA** ✅
- **Environnement containerisé** ✅
- **Reproductibilité** ✅

## 📈 Résultats obtenus
- **DVWA** : Accessible et fonctionnel
- **Nmap** : Scans de ports et services
- **Nikto** : Détection de vulnérabilités
- **Newman** : Tests automatisés Postman
- **CURL** : Tests de connexion HTTP
- **ZAP** : Problèmes d'accès (documentés)

## 🎯 Conclusion
Ce laboratoire répond aux exigences de l'exercice 5ATTACK avec un environnement professionnel, des outils fonctionnels et une documentation complète des problèmes rencontrés.