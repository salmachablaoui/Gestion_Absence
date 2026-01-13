<?php
session_start();
require_once "../../models/XmlManager.php";

$absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");

if (isset($_GET['id'])) {
    $absenceId = $_GET['id'];

    // Supprimer l’élément XML
    $xml = $absencesXml->getAll();
    $i = 0;
    foreach ($xml->absence as $a) {
        if ((string)$a['id'] === $absenceId) {
            unset($xml->absence[$i]);
            break;
        }
        $i++;
    }

    $absencesXml->save();
}

header("Location: dashboard.php");
exit;
