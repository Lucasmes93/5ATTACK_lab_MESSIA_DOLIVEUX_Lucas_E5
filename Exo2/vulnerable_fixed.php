<?php
// Script PHP avec CORS sécurisé - Version corrigée
header("Access-Control-Allow-Origin: https://trusted-site.com");
header("Access-Control-Allow-Credentials: true");
echo "Votre cookie de session : " . $_COOKIE['PHPSESSID'];
?>
