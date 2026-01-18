<?php
session_start();
require_once "../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

// Charger les séances
$seancesXml = new XmlManager("../../data/seances.xml");

// Récupérer le module de l'enseignant depuis la session
$teacherModule = $_SESSION["user"]["module"] ?? "Module par défaut";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $seance = $seancesXml->getAll()->addChild("seance");
    $seance->addAttribute("id", uniqid("SE"));
    $seance->addChild("teacher_id", $_SESSION["user"]["id"]);
    $seance->addChild("class_id", $_POST["class_id"]);
    
    // Module automatique
    $seance->addChild("module", $teacherModule);
    
    
    // Date/heure
    $datetime = $_POST["datetime"] ?? date("Y-m-d\TH:i");
    $seance->addChild("datetime", $datetime);
    
    $seance->addChild("created_at", date("Y-m-d H:i:s"));
    
    $seancesXml->save();
    
    $_SESSION['success_message'] = "Séance créée avec succès!";
}

header("Location: dashboard.php");
exit;
?>
