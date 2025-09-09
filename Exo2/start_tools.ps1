# Script PowerShell pour démarrer les outils de l'Exercice 2
Write-Host "=== Démarrage des outils Exercice 2 - CORS ===" -ForegroundColor Green

# Vérifier que Docker Compose est disponible
Write-Host "🔍 Vérification de Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = podman-compose --version 2>&1
    Write-Host "✅ Podman Compose trouvé: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Podman Compose non trouvé. Installation requise." -ForegroundColor Red
    exit 1
}

# Vérifier que Python est installé
Write-Host "🔍 Vérification de Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python trouvé: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python non trouvé. Installation requise." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 Instructions pour l'Exercice 2 :" -ForegroundColor Cyan
Write-Host "1. Démarrer DVWA : podman-compose up -d" -ForegroundColor White
Write-Host "2. Configurer DVWA : http://localhost:8080 (admin/password)" -ForegroundColor White
Write-Host "3. Démarrer le serveur d'attaque : .\start_attack_server.ps1" -ForegroundColor White
Write-Host "4. Ouvrir la page d'exploitation : http://localhost:8000/exploit.html" -ForegroundColor White
Write-Host ""
Write-Host "📚 Documentation disponible :" -ForegroundColor Cyan
Write-Host "   - README.md : Guide principal" -ForegroundColor White
Write-Host "   - CORS_ATTACK_LAB.md : Documentation technique" -ForegroundColor White
Write-Host "   - QUESTIONS_REPONSES.md : Réponses aux questions" -ForegroundColor White
Write-Host ""
Write-Host "✅ Prêt pour l'Exercice 2 - Attaque CORS !" -ForegroundColor Green
