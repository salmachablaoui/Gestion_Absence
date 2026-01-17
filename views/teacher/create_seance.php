<?php
session_start();
require_once "../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

$seancesXml = new XmlManager("../../data/seances.xml");

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $seance = $seancesXml->getAll()->addChild("seance");
    $seance->addAttribute("id", uniqid("SE"));
    $seance->addChild("teacher_id", $_SESSION["user"]["id"]);
    $seance->addChild("class_id", $_POST["class_id"]);
    $seance->addChild("module", $_POST["module"]);
    
    // Utiliser la date/heure fournie ou l'actuelle
    $datetime = $_POST["datetime"] ?? date("Y-m-d\TH:i");
    $seance->addChild("datetime", $datetime);
    
    // Optionnel: ajouter un timestamp
    $seance->addChild("created_at", date("Y-m-d H:i:s"));
    
    $seancesXml->save();
    
    // Message de confirmation
    $_SESSION['success_message'] = "Séance créée avec succès!";
}

header("Location: dashboard.php");
exit;
?>