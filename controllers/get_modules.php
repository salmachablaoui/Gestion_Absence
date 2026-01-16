<?php
// controllers/get_modules.php
header('Content-Type: application/json');

// Vérifier si class_id est fourni
if (!isset($_GET['class_id']) || empty($_GET['class_id'])) {
    echo json_encode([
        'success' => false,
        'message' => 'Class ID manquant'
    ]);
    exit;
}

$classId = $_GET['class_id'];

// Chemin vers le fichier XML
$classesXmlPath = __DIR__ . '/../data/classes.xml';

if (!file_exists($classesXmlPath)) {
    echo json_encode([
        'success' => false,
        'message' => 'Fichier classes.xml introuvable'
    ]);
    exit;
}

// Charger le XML
$xml = simplexml_load_file($classesXmlPath);

if (!$xml) {
    echo json_encode([
        'success' => false,
        'message' => 'Erreur de chargement XML'
    ]);
    exit;
}

// Chercher la classe
$class = $xml->xpath("//class[@id='$classId']");

if (empty($class)) {
    echo json_encode([
        'success' => false,
        'message' => "Classe '$classId' non trouvée"
    ]);
    exit;
}

$class = $class[0];

// Récupérer les modules
$modules = [];

if (isset($class->modules)) {
    foreach ($class->modules->module as $module) {
        $modules[] = (string)$module;
    }
}

echo json_encode([
    'success' => true,
    'modules' => $modules,
    'class_name' => (string)$class->name
]);