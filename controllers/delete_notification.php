<?php
session_start();
header('Content-Type: application/json');

if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'student') {
    echo json_encode(['success' => false, 'message' => 'Accès non autorisé']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
$notificationId = $data['notification_id'] ?? '';

if (empty($notificationId)) {
    echo json_encode(['success' => false, 'message' => 'ID notification manquant']);
    exit;
}

// Charger le fichier XML
$notificationsFile = '../data/student_notifications.xml';

if (!file_exists($notificationsFile)) {
    echo json_encode(['success' => false, 'message' => 'Fichier notifications introuvable']);
    exit;
}

$xml = simplexml_load_file($notificationsFile);
$dom = dom_import_simplexml($xml)->ownerDocument;
$xpath = new DOMXPath($dom);

// Trouver et supprimer la notification
$query = "//notification[id='$notificationId']";
$nodes = $xpath->query($query);

if ($nodes->length > 0) {
    $node = $nodes->item(0);
    $node->parentNode->removeChild($node);
    
    // Sauvegarder
    $dom->save($notificationsFile);
    echo json_encode(['success' => true, 'message' => 'Notification supprimée']);
} else {
    echo json_encode(['success' => false, 'message' => 'Notification non trouvée']);
}
?>