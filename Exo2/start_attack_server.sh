#!/bin/bash
# Script Bash pour démarrer le serveur d'attaque CORS
# Usage: bash start_attack_server.sh

echo "🚀 Démarrage du serveur d'attaque CORS..."

# Vérifier si Python est installé
if command -v python3 &> /dev/null; then
    echo "✅ Python3 trouvé: $(python3 --version)"
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    echo "✅ Python trouvé: $(python --version)"
    PYTHON_CMD="python"
else
    echo "❌ Python n'est pas installé ou pas dans le PATH"
    echo "Veuillez installer Python depuis https://python.org"
    exit 1
fi

# Vérifier si les fichiers nécessaires existent
required_files=("exploit.html" "vulnerable.php" "vulnerable_fixed.php")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file trouvé"
    else
        echo "❌ $file manquant"
        exit 1
    fi
done

# Démarrer le serveur Python
echo "🌐 Démarrage du serveur sur http://localhost:8000..."
echo "📁 Répertoire de travail: $(pwd)"
echo "🔗 Accédez à: http://localhost:8000/exploit.html"
echo "⏹️  Appuyez sur Ctrl+C pour arrêter le serveur"
echo ""

# Démarrer le serveur HTTP Python
$PYTHON_CMD -m http.server 8000
