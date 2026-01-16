<?php
// controllers/get_modules.php
header('Content-Type: application/json');

if (!isset($_GET['class_id']) || empty($_GET['class_id'])) {
    echo json_encode(['success' => false, 'message' => 'Class ID manquant']);
    exit;
}

$classId = $_GET['class_id'];
$classesXmlPath = realpath(__DIR__ . '/../data/classes.xml');

if (!file_exists($classesXmlPath)) {
    echo json_encode(['success' => false, 'message' => 'Fichier classes.xml introuvable']);
    exit;
}

$xml = simplexml_load_file($classesXmlPath);
$class = $xml->xpath("//class[@id='$classId']");

if (empty($class)) {
    echo json_encode(['success' => false, 'message' => 'Classe non trouvée']);
    exit;
}

$class = $class[0];
$modules = [];

if (isset($class->modules)) {
    foreach ($class->modules->module as $module) {
        $modules[] = (string)$module;
    }
}

// Si pas de modules spécifiques, utiliser des modules par défaut
if (empty($modules)) {
    $className = (string)$class->name;
    if (strpos($className, '1') !== false) {
        $modules = ['Mathématiques', 'Algorithmique', 'Base de données', 'Java', 'Python'];
    } elseif (strpos($className, '2') !== false) {
        $modules = ['Base de données avancée', 'Java avancé', 'Réseaux', 'Systèmes d\'exploitation'];
    } else {
        $modules = ['Mathématiques', 'Algorithmique', 'Base de données', 'Java'];
    }
}

echo json_encode([
    'success' => true,
    'modules' => $modules,
    'class_name' => (string)$class->name
]);