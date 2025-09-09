#!/bin/bash
# Script Bash pour démarrer l'Exercice 2 avec Podman Desktop

echo "=== Setup Exercice 2 - Attaque CORS avec Podman Desktop ==="

# Nettoyer les anciens conteneurs
echo "[0/6] Nettoyage des anciens conteneurs..."
podman pod rm -f exo2-cors 2>/dev/null || true
podman container rm -f dvwa-cors mysql-cors 2>/dev/null || true

# Créer le pod pour l'Exercice 2
echo "[1/6] Création du pod exo2-cors..."
podman pod create --name exo2-cors -p 8080:80 -p 3306:3306

# Démarrer MySQL
echo "[2/6] Démarrage de MySQL..."
podman run -d --pod exo2-cors --name mysql-cors \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=dvwa \
    -e MYSQL_USER=user \
    -e MYSQL_PASSWORD=password \
    mysql:5.7

# Attendre que MySQL soit prêt
echo "[3/6] Attente du démarrage de MySQL..."
sleep 15

# Démarrer DVWA
echo "[4/6] Démarrage de DVWA..."
podman run -d --pod exo2-cors --name dvwa-cors \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=dvwa \
    -e MYSQL_USER=user \
    -e MYSQL_PASSWORD=password \
    vulnerables/web-dvwa

# Attendre que DVWA soit prêt
echo "[5/6] Attente du démarrage de DVWA..."
sleep 20

# Vérifier que les services sont accessibles
echo "[6/6] Vérification des services..."
if curl -s http://localhost:8080 > /dev/null; then
    echo "✅ DVWA est accessible sur http://localhost:8080"
else
    echo "⚠️  DVWA pourrait ne pas être encore prêt. Attendez quelques secondes."
fi

echo ""
echo "✅ Setup Exercice 2 terminé !"
echo ""
echo "🌐 Accès aux services :"
echo "   DVWA : http://localhost:8080"
echo "   Identifiants : admin / password"
echo ""
echo "🚀 Prochaines étapes :"
echo "   1. Ouvrir http://localhost:8080 dans le navigateur"
echo "   2. Se connecter avec admin/password"
echo "   3. Mettre le niveau de sécurité à 'Low'"
echo "   4. Copier vulnerable.php dans DVWA"
echo "   5. Démarrer le serveur d'attaque : bash start_attack_server.sh"
echo "   6. Ouvrir http://localhost:8000/exploit.html"
echo ""
echo "📋 Pour arrêter les services :"
echo "   podman pod stop exo2-cors"
echo "   podman pod rm exo2-cors"
