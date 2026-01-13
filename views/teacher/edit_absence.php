<?php
session_start();
require_once "../../models/XmlManager.php";

$absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $absenceId = $_POST['id'];

    foreach ($absencesXml->getAll()->absence as $a) {
        if ((string)$a['id'] === $absenceId) {
            $a->studentId = $_POST['studentId'];
            $a->module = $_POST['module'];
            $a->date = $_POST['date'];
            $a->status = $_POST['status'];
            $a->hours = $_POST['hours'];
            break;
        }
    }

    $absencesXml->save();
    header("Location: dashboard.php");
    exit;
}
