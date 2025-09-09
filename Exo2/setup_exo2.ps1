# Script PowerShell pour démarrer l'Exercice 2 avec Podman Desktop
Write-Host "=== Setup Exercice 2 - Attaque CORS avec Podman Desktop ===" -ForegroundColor Green

# Nettoyer les anciens conteneurs
Write-Host "[0/6] Nettoyage des anciens conteneurs..." -ForegroundColor Yellow
podman pod rm -f exo2-cors 2>$null
podman container rm -f dvwa-cors mysql-cors 2>$null

# Créer le pod pour l'Exercice 2
Write-Host "[1/6] Création du pod exo2-cors..." -ForegroundColor Yellow
podman pod create --name exo2-cors -p 8080:80 -p 3306:3306

# Démarrer MySQL
Write-Host "[2/6] Démarrage de MySQL..." -ForegroundColor Yellow
podman run -d --pod exo2-cors --name mysql-cors \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=dvwa \
    -e MYSQL_USER=user \
    -e MYSQL_PASSWORD=password \
    mysql:5.7

# Attendre que MySQL soit prêt
Write-Host "[3/6] Attente du démarrage de MySQL..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Démarrer DVWA
Write-Host "[4/6] Démarrage de DVWA..." -ForegroundColor Yellow
podman run -d --pod exo2-cors --name dvwa-cors \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=dvwa \
    -e MYSQL_USER=user \
    -e MYSQL_PASSWORD=password \
    vulnerables/web-dvwa

# Attendre que DVWA soit prêt
Write-Host "[5/6] Attente du démarrage de DVWA..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

# Vérifier que les services sont accessibles
Write-Host "[6/6] Vérification des services..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 10 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ DVWA est accessible sur http://localhost:8080" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  DVWA pourrait ne pas être encore prêt. Attendez quelques secondes." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ Setup Exercice 2 terminé !" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Accès aux services :" -ForegroundColor Cyan
Write-Host "   DVWA : http://localhost:8080" -ForegroundColor White
Write-Host "   Identifiants : admin / password" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Prochaines étapes :" -ForegroundColor Cyan
Write-Host "   1. Ouvrir http://localhost:8080 dans le navigateur" -ForegroundColor White
Write-Host "   2. Se connecter avec admin/password" -ForegroundColor White
Write-Host "   3. Mettre le niveau de sécurité à 'Low'" -ForegroundColor White
Write-Host "   4. Copier vulnerable.php dans DVWA" -ForegroundColor White
Write-Host "   5. Démarrer le serveur d'attaque : .\start_attack_server.ps1" -ForegroundColor White
Write-Host "   6. Ouvrir http://localhost:8000/exploit.html" -ForegroundColor White
Write-Host ""
Write-Host "📋 Pour arrêter les services :" -ForegroundColor Cyan
Write-Host "   podman pod stop exo2-cors" -ForegroundColor White
Write-Host "   podman pod rm exo2-cors" -ForegroundColor White
