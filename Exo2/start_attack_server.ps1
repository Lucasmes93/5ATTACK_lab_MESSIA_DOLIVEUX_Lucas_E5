# Script PowerShell pour démarrer le serveur d'attaque CORS
# Usage: .\start_attack_server.ps1

Write-Host "🚀 Démarrage du serveur d'attaque CORS..." -ForegroundColor Green

# Vérifier si Python est installé
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python trouvé: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python n'est pas installé ou pas dans le PATH" -ForegroundColor Red
    Write-Host "Veuillez installer Python depuis https://python.org" -ForegroundColor Yellow
    exit 1
}

# Vérifier si les fichiers nécessaires existent
$requiredFiles = @("exploit.html", "vulnerable.php", "vulnerable_fixed.php")
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file trouvé" -ForegroundColor Green
    } else {
        Write-Host "❌ $file manquant" -ForegroundColor Red
        exit 1
    }
}

# Démarrer le serveur Python
Write-Host "🌐 Démarrage du serveur sur http://localhost:8000..." -ForegroundColor Cyan
Write-Host "📁 Répertoire de travail: $(Get-Location)" -ForegroundColor Cyan
Write-Host "🔗 Accédez à: http://localhost:8000/exploit.html" -ForegroundColor Yellow
Write-Host "⏹️  Appuyez sur Ctrl+C pour arrêter le serveur" -ForegroundColor Yellow
Write-Host ""

# Démarrer le serveur HTTP Python
python -m http.server 8000
