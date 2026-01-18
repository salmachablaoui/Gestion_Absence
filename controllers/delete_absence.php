<?php
session_start();
header('Content-Type: application/json');

if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'student') {
    echo json_encode(['success' => false, 'message' => 'Accès non autorisé']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
$absenceId = $data['absence_id'] ?? '';

if (empty($absenceId)) {
    echo json_encode(['success' => false, 'message' => 'ID absence manquant']);
    exit;
}

// Charger le fichier XML
$absencesFile = '../data/absences.xml';

if (!file_exists($absencesFile)) {
    echo json_encode(['success' => false, 'message' => 'Fichier absences introuvable']);
    exit;
}

$xml = simplexml_load_file($absencesFile);
$dom = dom_import_simplexml($xml)->ownerDocument;
$xpath = new DOMXPath($dom);

// Trouver et supprimer l'absence
$query = "//absence[@id='$absenceId']";
$nodes = $xpath->query($query);

if ($nodes->length > 0) {
    $node = $nodes->item(0);
    $node->parentNode->removeChild($node);
    
    // Sauvegarder
    $dom->save($absencesFile);
    
    // Mettre à jour le compteur dans students.xml
    $studentId = $data['student_id'] ?? '';
    if (!empty($studentId)) {
        updateStudentAbsenceCount($studentId, -1);
    }
    
    echo json_encode(['success' => true, 'message' => 'Absence supprimée']);
} else {
    echo json_encode(['success' => false, 'message' => 'Absence non trouvée']);
}

function updateStudentAbsenceCount($studentId, $change) {
    $studentsFile = '../data/students.xml';
    if (!file_exists($studentsFile)) return;
    
    $xml = simplexml_load_file($studentsFile);
    foreach ($xml->student as $student) {
        if ((string)$student['id'] === $studentId) {
            if (isset($student->absence_count)) {
                $current = (int)$student->absence_count;
                $newCount = max(0, $current + $change);
                $student->absence_count = (string)$newCount;
            }
            $xml->asXML($studentsFile);
            break;
        }
    }
}
?>