<?php
session_start();
header('Content-Type: application/json');

if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'student') {
    echo json_encode(['success' => false, 'message' => 'Accès non autorisé']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
$studentId = $data['student_id'] ?? $_SESSION['user']['id'];

if (empty($studentId)) {
    echo json_encode(['success' => false, 'message' => 'ID étudiant manquant']);
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

// Trouver toutes les notifications de l'étudiant
$query = "//notification[student_id='$studentId']";
$nodes = $xpath->query($query);

$deletedCount = 0;
foreach ($nodes as $node) {
    $node->parentNode->removeChild($node);
    $deletedCount++;
}

// Sauvegarder si des notifications ont été supprimées
if ($deletedCount > 0) {
    $dom->save($notificationsFile);
}

echo json_encode([
    'success' => true,
    'message' => "$deletedCount notification(s) supprimée(s)",
    'count' => $deletedCount
]);
?>