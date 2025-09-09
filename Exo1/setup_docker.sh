#!/usr/bin/env bash

echo "=== Setup Simple du Lab 5ATTACK (Docker) ==="

# Créer un réseau Docker
echo "[1/4] Création du réseau..."
docker network create weblab-network 2>/dev/null || true

# Démarrer DVWA
echo "[2/4] Démarrage de DVWA..."
docker run -d --network weblab-network --name dvwa -p 80:80 vulnerables/web-dvwa

# Démarrer ZAP
echo "[3/4] Démarrage de ZAP..."
docker run -d --network weblab-network --name zap -p 8080:8080 owasp/zap2docker-stable zap.sh -daemon -port 8080 -host 0.0.0.0

# Construire les outils
echo "[4/4] Construction des outils..."
docker build -t weblab-tools -f Dockerfile.tools .

echo ""
echo "✅ Setup terminé !"
echo ""
echo "Pour utiliser les outils :"
echo "docker run -it --rm --network weblab-network --name tools -v \$(pwd):/workspace weblab-tools /bin/bash"
echo ""
echo "DVWA : http://localhost/"
echo "ZAP  : http://localhost:8080"
