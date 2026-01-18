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
$absencesFile = '../data/absences.xml';

if (!file_exists($absencesFile)) {
    echo json_encode(['success' => false, 'message' => 'Fichier absences introuvable']);
    exit;
}

$xml = simplexml_load_file($absencesFile);
$dom = dom_import_simplexml($xml)->ownerDocument;
$xpath = new DOMXPath($dom);

// Trouver toutes les absences de l'étudiant
$query = "//absence[(studentId='$studentId' or student_id='$studentId')]";
$nodes = $xpath->query($query);

$deletedCount = 0;
foreach ($nodes as $node) {
    $node->parentNode->removeChild($node);
    $deletedCount++;
}

// Sauvegarder si des absences ont été supprimées
if ($deletedCount > 0) {
    $dom->save($absencesFile);
    
    // Réinitialiser le compteur dans students.xml
    updateStudentAbsenceCount($studentId, 0);
}

echo json_encode([
    'success' => true,
    'message' => "$deletedCount absence(s) supprimée(s)",
    'count' => $deletedCount
]);

function updateStudentAbsenceCount($studentId, $count) {
    $studentsFile = '../data/students.xml';
    if (!file_exists($studentsFile)) return;
    
    $xml = simplexml_load_file($studentsFile);
    foreach ($xml->student as $student) {
        if ((string)$student['id'] === $studentId) {
            if (!isset($student->absence_count)) {
                $student->addChild('absence_count', (string)$count);
            } else {
                $student->absence_count = (string)$count;
            }
            $xml->asXML($studentsFile);
            break;
        }
    }
}
?>