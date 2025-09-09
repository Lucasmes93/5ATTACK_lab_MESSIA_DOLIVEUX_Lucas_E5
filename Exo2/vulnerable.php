<?php
// Script PHP vulnérable à CORS - Version dangereuse
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
echo "Votre cookie de session : " . $_COOKIE['PHPSESSID'];
?>
