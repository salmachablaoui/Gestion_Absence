<?php
// views/student/dashboard.php
session_start();

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "student") {
    header("Location: ../../login.php");
    exit;
}

$studentId = $_SESSION["user"]["id"];
$studentEmail = $_SESSION["user"]["email"];
$studentName = $_SESSION["user"]["name"] ?? 'Étudiant';

$basePath = dirname(__DIR__, 2); // Remonte 2 niveaux (views/student -> Gestion_Absence)

// Charger les données XML
$studentsFile = $basePath . "/data/students.xml";
$absencesFile = $basePath . "/data/absences.xml";

// Vérifier si les fichiers existent
if (!file_exists($studentsFile) || !file_exists($absencesFile)) {
    die("Fichiers de données manquants. Veuillez contacter l'administrateur.");
}

$studentsXml = simplexml_load_file($studentsFile);
$absencesXml = simplexml_load_file($absencesFile);

// Trouver les données de l'étudiant
$studentData = null;
$studentClass = 'Non spécifié';
$studentModule = '';

foreach ($studentsXml->student as $student) {
    if ((string)$student['id'] === $studentId) {
        $studentData = $student;
        $studentClass = (string)$student->class;
        $studentModule = (string)$student->module;
        break;
    }
}

// Compter les absences
$absencesCount = 0;
$absencesData = [];
foreach ($absencesXml->absence as $absence) {
    if ((string)$absence->studentId === $studentId) {
        $absencesCount++;
        $absencesData[] = [
            'date' => (string)$absence->date,
            'hours' => (string)$absence->hours,
            'module' => (string)$absence->module,
            'status' => (string)$absence->status,
            'seanceId' => (string)$absence->seanceId
        ];
    }
}

// Charger les notifications
$notificationsFile = $basePath . "/data/student_notifications.xml";
$notifications = [];
$notificationsCount = 0;
$unreadCount = 0;

if (file_exists($notificationsFile)) {
    $notificationsXml = simplexml_load_file($notificationsFile);
    
    foreach ($notificationsXml->notification as $notification) {
        if ((string)$notification->student_id === $studentId) {
            $isRead = ((string)($notification->read ?? 'false')) === 'true';
            
            // CORRECTION CRITIQUE ICI :
            // Ne JAMAIS utiliser $studentModule comme fallback pour seance_module
            // Ces deux choses sont différentes !
            $seanceModule = (string)($notification->seance_module ?? '');
            
            $notifications[] = [
                'id' => (string)($notification->id ?? 'NOTIF' . uniqid()),
                'student_id' => (string)$notification->student_id,
                'student_name' => (string)($notification->student_name ?? $studentName),
                'seance_id' => (string)($notification->seance_id ?? ''),
                'seance_module' => $seanceModule, // Correction : pas de fallback avec studentModule
                'seance_datetime' => (string)($notification->seance_datetime ?? ''),
                'message' => (string)($notification->message ?? 'Notification d\'absence'),
                'created_at' => (string)($notification->created_at ?? $notification->date ?? date('Y-m-d H:i:s')),
                'date' => (string)($notification->date ?? date('Y-m-d H:i:s')),
                'read' => $isRead ? 'true' : 'false',
                'important' => (string)($notification->important ?? 'true')
            ];
            
            $notificationsCount++;
            if (!$isRead) {
                $unreadCount++;
            }
        }
    }
}

// Créer le XML pour le XSLT
$xmlContent = '<?xml version="1.0" encoding="UTF-8"?>
<dashboard>
    <student>
        <id>' . htmlspecialchars($studentId) . '</id>
        <email>' . htmlspecialchars($studentEmail) . '</email>
        <name>' . htmlspecialchars($studentData ? $studentData->name : $studentName) . '</name>
        <class>' . htmlspecialchars($studentClass) . '</class>
        <module>' . htmlspecialchars($studentModule) . '</module>
    </student>
    
    <statistics>
        <absences>' . $absencesCount . '</absences>
        <notifications>' . $notificationsCount . '</notifications>
        <unread_notifications>' . $unreadCount . '</unread_notifications>
    </statistics>
    
    <!-- Absences -->';

if ($absencesCount > 0) {
    $xmlContent .= '<absences>';
    foreach ($absencesData as $absence) {
        $xmlContent .= '
        <absence>
            <date>' . htmlspecialchars($absence['date']) . '</date>
            <hours>' . htmlspecialchars($absence['hours']) . '</hours>
            <module>' . htmlspecialchars($absence['module']) . '</module>
            <status>' . htmlspecialchars($absence['status']) . '</status>
            <seanceId>' . htmlspecialchars($absence['seanceId']) . '</seanceId>
        </absence>';
    }
    $xmlContent .= '</absences>';
} else {
    $xmlContent .= '<absences/>';
}

// Notifications
if ($notificationsCount > 0) {
    $xmlContent .= '<notifications>';
    foreach ($notifications as $notification) {
        // CORRECTION : Ne pas utiliser $studentModule pour seance_module
        $displayModule = $notification['seance_module'] ?: 'Module non spécifié';
        
        $xmlContent .= '
        <notification>
            <id>' . htmlspecialchars($notification['id']) . '</id>
            <student_id>' . htmlspecialchars($notification['student_id']) . '</student_id>
            <student_name>' . htmlspecialchars($notification['student_name']) . '</student_name>
            <seance_id>' . htmlspecialchars($notification['seance_id']) . '</seance_id>
            <seance_module>' . htmlspecialchars($displayModule) . '</seance_module>
            <seance_datetime>' . htmlspecialchars($notification['seance_datetime']) . '</seance_datetime>
            <message>' . htmlspecialchars($notification['message']) . '</message>
            <date>' . htmlspecialchars($notification['date']) . '</date>
            <created_at>' . htmlspecialchars($notification['created_at']) . '</created_at>
            <read>' . htmlspecialchars($notification['read']) . '</read>
            <important>' . htmlspecialchars($notification['important']) . '</important>
        </notification>';
    }
    $xmlContent .= '</notifications>';
} else {
    $xmlContent .= '<notifications/>';
}

$xmlContent .= '
</dashboard>';

// Charger le XSLT
$xslPath = $basePath . "/xslt/dashboard_student.xsl";

// Pour debug: afficher le XML brut
if (isset($_GET['debug']) && $_GET['debug'] == 'xml') {
    header('Content-Type: text/xml; charset=utf-8');
    echo $xmlContent;
    exit;
}

// Si le XSLT n'existe pas, afficher le XML brut pour débogage
if (!file_exists($xslPath)) {
    header('Content-Type: text/xml; charset=utf-8');
    echo $xmlContent;
    exit;
}

// Transformer avec XSLT
try {
    $xsl = new DOMDocument();
    $xsl->load($xslPath);

    $xml = new DOMDocument();
    $xml->loadXML($xmlContent);

    $proc = new XSLTProcessor();
    $proc->importStylesheet($xsl);
    
    // Passer les paramètres
    $proc->setParameter('', 'studentId', $studentId);
    $proc->setParameter('', 'studentEmail', $studentEmail);
    
    // Ajouter des fonctions PHP si nécessaire
    $proc->registerPHPFunctions();
    
    echo $proc->transformToXML($xml);
    
} catch (Exception $e) {
    // En cas d'erreur XSLT, afficher le XML brut
    header('Content-Type: text/html; charset=utf-8');
    echo '<!DOCTYPE html>
    <html>
    <head>
        <title>Dashboard - Erreur</title>
        <style>
            body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }
            .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 5px; }
            .error { color: #dc3545; padding: 15px; background: #f8d7da; border-radius: 5px; margin-bottom: 20px; }
            pre { background: #f8f9fa; padding: 15px; border-radius: 5px; overflow: auto; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Dashboard Étudiant</h1>
            <div class="error">
                <strong>Erreur de transformation XSLT :</strong> ' . htmlspecialchars($e->getMessage()) . '
            </div>
            <h2>Données XML (pour débogage) :</h2>
            <pre>' . htmlspecialchars($xmlContent) . '</pre>
        </div>
    </body>
    </html>';
}
?>