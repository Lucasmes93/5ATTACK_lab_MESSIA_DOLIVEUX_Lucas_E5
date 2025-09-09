<?php
// Script PHP avec CORS sécurisé - Version corrigée
header("Access-Control-Allow-Origin: https://trusted-site.com");
header("Access-Control-Allow-Credentials: true");
header("Content-Type: application/json");

// Vérifier l'origine de la requête
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
$allowedOrigins = ['https://trusted-site.com', 'https://localhost:8000'];

if (!in_array($origin, $allowedOrigins)) {
    http_response_code(403);
    echo json_encode(['error' => 'Origine non autorisée']);
    exit;
}

// Récupérer le cookie de session
$sessionCookie = isset($_COOKIE['PHPSESSID']) ? $_COOKIE['PHPSESSID'] : 'Aucun cookie trouvé';

// Informations sensibles exposées (seulement pour les origines autorisées)
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
