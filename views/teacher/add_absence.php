<?php
session_start();
require_once "../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

$absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $absence = $absencesXml->getAll()->addChild("absence");
    $absence->addAttribute("id", uniqid("a"));

    $absence->addChild("studentId", $_POST["studentId"]);
    $absence->addChild("module", $_POST["module"]);
    $absence->addChild("date", $_POST["date"]);
    $absence->addChild("status", $_POST["status"]);
    $absence->addChild("hours", $_POST["hours"]);

    // optionnel : enseignant responsable
    $absence->addChild("teacherId", $_SESSION["user"]["id"]);

    $absencesXml->save();

    header("Location: dashboard.php");
    exit;
}
