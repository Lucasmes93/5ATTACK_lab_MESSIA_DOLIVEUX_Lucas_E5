# Script PowerShell pour Windows
Write-Host "=== Setup Lab 5ATTACK pour Windows ===" -ForegroundColor Green

# Nettoyer les anciens conteneurs
Write-Host "[0/5] Nettoyage des anciens conteneurs..." -ForegroundColor Yellow
podman pod rm -f weblab 2>$null
podman container rm -f dvwa zap tools 2>$null

# Créer le pod
Write-Host "[1/5] Création du pod..." -ForegroundColor Yellow
podman pod create --name weblab -p 80:80 -p 8080:8080

# Démarrer DVWA
Write-Host "[2/5] Démarrage de DVWA..." -ForegroundColor Yellow
podman run -d --pod weblab --name dvwa vulnerables/web-dvwa

# Attendre que DVWA soit prêt
Write-Host "[3/5] Attente du démarrage de DVWA..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Démarrer ZAP
Write-Host "[4/5] Démarrage de ZAP..." -ForegroundColor Yellow
podman run -d --pod weblab --name zap owasp/zap2docker-stable zap.sh -daemon -port 8080 -host 0.0.0.0

# Construire les outils
Write-Host "[5/5] Construction des outils..." -ForegroundColor Yellow
podman build -t weblab-tools -f Dockerfile.tools .

Write-Host ""
Write-Host "✅ Setup terminé !" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Accès aux services :" -ForegroundColor Cyan
Write-Host "   DVWA : http://localhost/" -ForegroundColor White
Write-Host "   ZAP  : http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Pour utiliser les outils :" -ForegroundColor Cyan
Write-Host "   podman run -it --rm --pod weblab --name tools -v `$PWD:/workspace weblab-tools /bin/sh" -ForegroundColor White
Write-Host ""
Write-Host "📋 Commandes dans le conteneur :" -ForegroundColor Cyan
Write-Host "   cd /workspace" -ForegroundColor White
Write-Host "   bash login_dvwa.sh" -ForegroundColor White
Write-Host "   bash examples.sh" -ForegroundColor White
