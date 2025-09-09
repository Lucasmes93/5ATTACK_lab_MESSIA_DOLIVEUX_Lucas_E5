#!/bin/bash
# Script Bash pour l'Exercice 2 - Attaque CORS

echo "=== Setup Exercice 2 - Attaque CORS ==="

# Vérifier que podman-compose est disponible
echo "[0/4] Vérification de podman-compose..."
if command -v podman-compose &> /dev/null; then
    echo "✅ Podman Compose trouvé: $(podman-compose --version)"
else
    echo "❌ Podman Compose non trouvé. Installation requise."
    echo "Installez podman-compose depuis: https://github.com/containers/podman-compose"
    exit 1
fi

# Nettoyer les anciens conteneurs
echo "[1/4] Nettoyage des anciens conteneurs..."
podman-compose down 2>/dev/null || true

# Démarrer les services avec docker-compose.yml
echo "[2/4] Démarrage de DVWA avec podman-compose..."
podman-compose up -d

# Attendre que les services soient prêts
echo "[3/4] Attente du démarrage des services..."
sleep 20

# Vérifier que DVWA est accessible
echo "[4/4] Vérification de l'accès à DVWA..."
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
echo "   podman-compose down"
