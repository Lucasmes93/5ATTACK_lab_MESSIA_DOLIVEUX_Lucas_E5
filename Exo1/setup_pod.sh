#!/usr/bin/env bash

echo "=== Setup Lab 5ATTACK pour Windows ==="

# Nettoyer les anciens conteneurs
echo "[0/5] Nettoyage des anciens conteneurs..."
podman pod rm -f weblab 2>/dev/null || true
podman container rm -f dvwa zap tools 2>/dev/null || true

# Créer le pod
echo "[1/5] Création du pod..."
podman pod create --name weblab -p 80:80 -p 8080:8080

# Démarrer DVWA
echo "[2/5] Démarrage de DVWA..."
podman run -d --pod weblab --name dvwa vulnerables/web-dvwa

# Attendre que DVWA soit prêt
echo "[3/5] Attente du démarrage de DVWA..."
sleep 10

# Démarrer ZAP
echo "[4/5] Démarrage de ZAP..."
podman run -d --pod weblab --name zap owasp/zap2docker-stable zap.sh -daemon -port 8080 -host 0.0.0.0

# Construire les outils
echo "[5/5] Construction des outils..."
podman build -t weblab-tools -f Dockerfile.tools .

echo ""
echo "✅ Setup terminé !"
echo ""
echo "🌐 Accès aux services :"
echo "   DVWA : http://localhost/"
echo "   ZAP  : http://localhost:8080"
echo ""
echo "🚀 Pour utiliser les outils :"
echo "   podman run -it --rm --pod weblab --name tools -v \$(pwd):/workspace weblab-tools /bin/sh"
echo ""
echo "📋 Commandes dans le conteneur :"
echo "   cd /workspace"
echo "   bash login_dvwa.sh"
echo "   bash examples.sh"
