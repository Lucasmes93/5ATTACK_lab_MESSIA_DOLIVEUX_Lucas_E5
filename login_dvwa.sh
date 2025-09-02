#!/usr/bin/env bash
# Script de connexion à DVWA pour Windows

echo "=== Connexion à DVWA ==="

# Vérifier que DVWA est accessible
echo "🔍 Vérification de l'accès à DVWA..."
if ! curl -s http://127.0.0.1/ > /dev/null; then
    echo "❌ DVWA n'est pas accessible. Vérifiez que le conteneur est démarré."
    exit 1
fi

# Récupérer la page de login et extraire le token CSRF
echo "[1/4] Récupération de la page de login..."
LOGIN_PAGE=$(curl -s -c cookie.txt http://127.0.0.1/login.php)
TOKEN=$(echo "$LOGIN_PAGE" | grep -oP 'user_token" value="\K[^"]+' || echo "")

if [ -z "$TOKEN" ]; then
    echo "⚠️  Token CSRF non trouvé, tentative de connexion simple..."
    # Se connecter sans token (parfois ça marche)
    echo "[2/4] Connexion avec admin/password..."
    curl -s -b cookie.txt -c cookie.txt \
      -d "username=admin&password=password&Login=Login" \
      http://127.0.0.1/login.php > /dev/null
else
    echo "🔑 Token CSRF trouvé: $TOKEN"
    # Se connecter avec token
    echo "[2/4] Connexion avec admin/password et token CSRF..."
    curl -s -b cookie.txt -c cookie.txt \
      -d "username=admin&password=password&Login=Login&user_token=$TOKEN" \
      http://127.0.0.1/login.php > /dev/null
fi

# Vérifier la connexion
echo "[3/4] Vérification de la connexion..."
if curl -s -b cookie.txt http://127.0.0.1/ | grep -q "Welcome to Damn Vulnerable Web Application"; then
    echo "✅ Connexion réussie !"
else
    echo "⚠️  Connexion non confirmée, mais cookies sauvegardés"
fi

# Aller sur la page de sécurité
echo "[4/4] Configuration de la sécurité..."
curl -s -b cookie.txt http://127.0.0.1/security.php > /dev/null

echo ""
echo "✅ Processus terminé !"
echo "🍪 Cookies sauvegardés dans cookie.txt"
echo "🌐 DVWA accessible sur http://127.0.0.1/"
echo "👤 Identifiants: admin/password"
