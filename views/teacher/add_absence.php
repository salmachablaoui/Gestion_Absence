<?php
session_start();
require_once "../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

$absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");

if (isset($_GET['id'])) {
    $studentId = $_GET['id'];
    $teacherId = $_SESSION['user']['id'];
    $today = date("Y-m-d");

    // Vérifier si absence déjà enregistrée
    foreach ($absencesXml->getAll()->absence as $a) {
        if ((string)$a->studentId === $studentId && (string)$a->date === $today) {
            header("Location: dashboard.php");
            exit;
        }
    }

    // Ajouter absence
    $absence = $absencesXml->getAll()->addChild("absence");
    $absence->addAttribute("id", uniqid("a"));
    $absence->addChild("studentId", $studentId);
    $absence->addChild("module", $_GET['module'] ?? "");
    $absence->addChild("date", $today);
    $absence->addChild("status", "absent");
    $absence->addChild("hours", $_GET['hours'] ?? "");
    $absence->addChild("teacherId", $teacherId);

    $absencesXml->save();
}

header("Location: dashboard.php");
exit;
