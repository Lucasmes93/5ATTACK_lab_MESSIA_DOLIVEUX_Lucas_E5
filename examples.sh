#!/usr/bin/env bash
# Exemples d'utilisation des outils pour Windows
echo "=== Exemples d'utilisation des outils ==="

# Vérifier que DVWA est accessible
echo "🔍 Vérification de l'accès à DVWA..."
if curl -s http://127.0.0.1/ > /dev/null; then
    echo "✅ DVWA est accessible"
else
    echo "❌ DVWA n'est pas accessible. Vérifiez que le conteneur est démarré."
    exit 1
fi

echo ""
echo "1. NMAP - Scan des ports ouverts"
echo "   Commande: nmap -sV 127.0.0.1"
nmap -sV 127.0.0.1

echo ""
echo "2. NMAP - Scan HTTP avec scripts"
echo "   Commande: nmap --script http-title,http-headers -p80 127.0.0.1"
nmap --script http-title,http-headers -p80 127.0.0.1

echo ""
echo "3. NIKTO - Scan de vulnérabilités web"
echo "   Commande: nikto -host http://127.0.0.1"
nikto -host http://127.0.0.1

echo ""
echo "4. NIKTO - Scan avec plugins spécifiques"
echo "   Commande: nikto -host http://127.0.0.1 -Plugins headers"
nikto -host http://127.0.0.1 -Plugins headers

echo ""
echo "5. NEWMAN - Test avec collection Postman"
echo "   Commande: newman run dvwa_postman_collection.json --insecure"
newman run dvwa_postman_collection.json --insecure

echo ""
echo "6. CURL - Test de connexion directe"
echo "   Commande: curl -I http://127.0.0.1/"
curl -I http://127.0.0.1/

echo ""
echo "✅ Tous les exemples ont été exécutés !"
echo "📊 Résultats sauvegardés dans les logs ci-dessus"
