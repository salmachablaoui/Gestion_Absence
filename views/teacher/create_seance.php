
<?php
session_start();
require_once "../../models/XmlManager.php";

if ($_SESSION["user"]["role"] !== "teacher") {
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
$seance->addChild("datetime", $_POST["datetime"]);

    $seancesXml->save();
}

header("Location: dashboard.php");
