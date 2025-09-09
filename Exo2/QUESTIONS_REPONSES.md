# ❓ Questions et Réponses - Exercice 2 CORS

## 1. Pourquoi « Access-Control-Allow-Origin: * » est-il dangereux ?

**Réponse :**
L'en-tête `Access-Control-Allow-Origin: *` est dangereux car :
- Il permet l'accès depuis n'importe quel domaine
- Il expose les données sensibles à tous les sites web
- Il contourne la politique de même origine du navigateur
- Il facilite les attaques CSRF et le vol de données

## 2. Quel rôle joue « Access-Control-Allow-Credentials: true » ?

**Réponse :**
L'en-tête `Access-Control-Allow-Credentials: true` :
- Inclut les cookies dans les requêtes CORS
- Transmet les informations d'authentification
- Expose les données de session (PHPSESSID, JWT, etc.)
- Augmente la surface d'attaque quand combiné avec `*`

## 3. Comment un attaquant pourrait-il exploiter cette faille ?

**Réponse :**
Un attaquant peut exploiter cette faille en :
- Volant les cookies de session via JavaScript
- Effectuant des actions non autorisées
- Exfiltrant des données sensibles
- Prenant le contrôle des comptes utilisateurs

## 4. Quelles sont les bonnes pratiques pour configurer CORS ?

**Réponse :**
Les bonnes pratiques incluent :
- Spécifier des origines exactes au lieu de `*`
- Utiliser des listes d'origines autorisées
- Limiter les méthodes HTTP autorisées
- Restreindre les en-têtes autorisés
- Désactiver les credentials si non nécessaires
- Implémenter une validation stricte des origines
