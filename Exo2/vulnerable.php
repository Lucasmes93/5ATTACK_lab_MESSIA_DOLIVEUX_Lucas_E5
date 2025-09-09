<?php
// Script PHP vulnérable à CORS - Version dangereuse
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Credentials: true");
header("Content-Type: application/json");

// Récupérer le cookie de session
$sessionCookie = isset($_COOKIE['PHPSESSID']) ? $_COOKIE['PHPSESSID'] : 'Aucun cookie trouvé';

// Informations sensibles exposées
$response = array(
    'message' => 'Votre cookie de session : ' . $sessionCookie,
    'timestamp' => date('Y-m-d H:i:s'),
    'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'Inconnu',
    'ip_address' => $_SERVER['REMOTE_ADDR'] ?? 'Inconnu',
    'session_id' => session_id(),
    'cookies' => $_COOKIE
);

echo json_encode($response, JSON_PRETTY_PRINT);
?>
