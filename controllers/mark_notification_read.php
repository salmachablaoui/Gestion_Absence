<?php
// controllers/mark_notification_read.php
session_start();

if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'student') {
    header('HTTP/1.1 403 Forbidden');
    echo json_encode(['success' => false, 'error' => 'Accès non autorisé']);
    exit;
}

require_once "../observer/DashboardNotifier.php";

$response = ['success' => false];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Vérifier si c'est une requête JSON
    $contentType = isset($_SERVER["CONTENT_TYPE"]) ? trim($_SERVER["CONTENT_TYPE"]) : '';
    
    if ($contentType === "application/json") {
        $input = json_decode(file_get_contents('php://input'), true);
        
        if ($input && isset($input['notification_ids'])) {
            // Marquer plusieurs notifications
            $marked = 0;
            foreach ($input['notification_ids'] as $notificationId) {
                if (DashboardNotifier::markAsRead($notificationId)) {
                    $marked++;
                }
            }
            
            $response['success'] = $marked > 0;
            $response['marked_count'] = $marked;
        }
    } elseif (isset($_POST['notification_id'])) {
        // Marquer une seule notification
        $notificationId = $_POST['notification_id'];
        $response['success'] = DashboardNotifier::markAsRead($notificationId);
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>