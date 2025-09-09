# Script PowerShell pour démarrer les outils
Write-Host "=== Démarrage des outils 5ATTACK ===" -ForegroundColor Green

# Vérifier que le pod existe
$podExists = podman pod exists weblab 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Le pod 'weblab' n'existe pas. Exécutez d'abord setup_pod.ps1" -ForegroundColor Red
    exit 1
}

# Vérifier que les conteneurs sont en cours d'exécution
$dvwaRunning = podman ps --filter "name=dvwa" --format "{{.Names}}" | Select-String "dvwa"
$zapRunning = podman ps --filter "name=zap" --format "{{.Names}}" | Select-String "zap"

if (-not $dvwaRunning) {
    Write-Host "❌ DVWA n'est pas en cours d'exécution" -ForegroundColor Red
    exit 1
}

if (-not $zapRunning) {
    Write-Host "❌ ZAP n'est pas en cours d'exécution" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Tous les services sont en cours d'exécution" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Démarrage du conteneur d'outils..." -ForegroundColor Cyan
Write-Host "   Vous allez entrer dans le conteneur avec bash" -ForegroundColor White
Write-Host "   Tapez 'exit' pour quitter le conteneur" -ForegroundColor White
Write-Host ""

# Démarrer le conteneur d'outils
podman run -it --rm --pod weblab --name tools -v ${PWD}:/workspace weblab-tools /bin/sh
