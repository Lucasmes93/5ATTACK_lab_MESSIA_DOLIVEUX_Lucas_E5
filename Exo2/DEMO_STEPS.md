# 🎬 Guide de Démonstration - Attaque CORS

## 📸 Étapes à capturer en images

### 1. Configuration initiale

#### 1.1 Démarrage de DVWA
- **Capture d'écran** : Commande `podman-compose up -d`
- **Commentaire** : "Démarrage de l'environnement DVWA avec Docker Compose"

#### 1.2 Vérification de l'accès DVWA
- **Capture d'écran** : Page de connexion DVWA (http://localhost:8080)
- **Commentaire** : "Interface DVWA accessible sur le port 8080"

#### 1.3 Configuration de la sécurité
- **Capture d'écran** : Page "DVWA Security" avec niveau "Low"
- **Commentaire** : "Configuration du niveau de sécurité à 'Low' pour l'exercice"

### 2. Déploiement du script vulnérable

#### 2.1 Upload du fichier vulnerable.php
- **Capture d'écran** : Fichier `vulnerable.php` dans le répertoire web de DVWA
- **Commentaire** : "Déploiement du script PHP vulnérable à CORS"

#### 2.2 Test du script vulnérable
- **Capture d'écran** : Réponse du script `vulnerable.php` dans le navigateur
- **Commentaire** : "Le script expose les cookies avec CORS permissif"

### 3. Préparation de l'attaque

#### 3.1 Démarrage du serveur d'attaque
- **Capture d'écran** : Commande `python -m http.server 8000`
- **Commentaire** : "Démarrage du serveur Python pour héberger la page malveillante"

#### 3.2 Accès à la page d'exploitation
- **Capture d'écran** : Page `exploit.html` (http://localhost:8000/exploit.html)
- **Commentaire** : "Interface d'exploitation CORS prête pour l'attaque"

### 4. Exécution de l'attaque

#### 4.1 Test de vulnérabilité CORS
- **Capture d'écran** : Résultat du test CORS avec succès
- **Commentaire** : "Confirmation de la vulnérabilité CORS - l'attaque peut accéder aux données"

#### 4.2 Vol du cookie de session
- **Capture d'écran** : Affichage du cookie PHPSESSID volé
- **Commentaire** : "Cookie de session volé avec succès via l'exploitation CORS"

#### 4.3 Envoi des données volées
- **Capture d'écran** : Simulation d'envoi vers serveur malveillant
- **Commentaire** : "Données sensibles envoyées vers un serveur d'attaque"

### 5. Capture du trafic avec Burp Suite

#### 5.1 Configuration de Burp Suite
- **Capture d'écran** : Configuration du proxy Burp Suite
- **Commentaire** : "Configuration de Burp Suite pour intercepter le trafic"

#### 5.2 Interception de la requête CORS
- **Capture d'écran** : Requête HTTP vers `/vulnerable.php` dans Burp Suite
- **Commentaire** : "Requête CORS interceptée montrant les en-têtes dangereux"

#### 5.3 Analyse des en-têtes CORS
- **Capture d'écran** : Détail des en-têtes `Access-Control-Allow-Origin: *`
- **Commentaire** : "En-têtes CORS dangereux identifiés dans la requête"

### 6. Correction de la vulnérabilité

#### 6.1 Remplacement par le script sécurisé
- **Capture d'écran** : Remplacement de `vulnerable.php` par `vulnerable_fixed.php`
- **Commentaire** : "Déploiement de la version sécurisée du script PHP"

#### 6.2 Test de l'attaque après correction
- **Capture d'écran** : Échec de l'attaque CORS après correction
- **Commentaire** : "L'attaque échoue maintenant - erreur 403 'Origin not allowed'"

#### 6.3 Vérification des en-têtes sécurisés
- **Capture d'écran** : Nouveaux en-têtes CORS restrictifs
- **Commentaire** : "En-têtes CORS sécurisés - seules les origines autorisées sont acceptées"

### 7. Comparaison avant/après

#### 7.1 Tableau comparatif
- **Capture d'écran** : Tableau montrant les différences entre vulnérable et sécurisé
- **Commentaire** : "Comparaison des configurations CORS vulnérable vs sécurisée"

#### 7.2 Résultats des tests
- **Capture d'écran** : Résultats des tests de sécurité
- **Commentaire** : "Validation de la correction de la vulnérabilité CORS"

## 📝 Script de démonstration

### Introduction (30 secondes)
"Bonjour, je vais vous démontrer une attaque CORS sur DVWA. Cette vulnérabilité permet à un site malveillant de voler des cookies de session depuis un autre domaine."

### Configuration (1 minute)
"Commençons par démarrer DVWA et configurer l'environnement vulnérable..."

### Démonstration de l'attaque (2 minutes)
"Maintenant, je vais montrer comment un attaquant peut exploiter cette vulnérabilité pour voler des cookies de session..."

### Capture du trafic (1 minute)
"Avec Burp Suite, nous pouvons voir exactement comment l'attaque fonctionne au niveau du protocole HTTP..."

### Correction (1 minute)
"Enfin, je vais corriger la vulnérabilité en implémentant une politique CORS sécurisée..."

### Conclusion (30 secondes)
"Cette démonstration illustre l'importance d'une configuration CORS appropriée pour protéger les applications web."

## 🎯 Points clés à mentionner

1. **Gravité** : L'impact d'une mauvaise configuration CORS
2. **Simplicité** : La facilité d'exploitation de cette vulnérabilité
3. **Prévention** : Les bonnes pratiques de sécurité
4. **Détection** : Comment identifier ce type de vulnérabilité
5. **Correction** : Les étapes de remédiation

## 📊 Métriques à mesurer

- **Temps d'exploitation** : < 2 minutes
- **Données exposées** : Cookie de session, informations utilisateur
- **Impact** : Accès non autorisé aux comptes utilisateurs
- **Difficulté** : Faible (script simple)
- **Détection** : Difficile (requêtes légitimes)

## 🔍 Questions pour l'audience

1. "Pouvez-vous identifier d'autres scénarios où cette vulnérabilité pourrait être exploitée ?"
2. "Quelles autres mesures de sécurité pourraient compléter la correction CORS ?"
3. "Comment détecter ce type d'attaque dans un environnement de production ?"
