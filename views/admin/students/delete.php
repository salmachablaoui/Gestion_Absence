<?php
session_start();
require_once "../../../models/XmlManager.php";

// Sécurité : admin seulement
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

// Vérifier ID
if (!isset($_GET['id'])) {
    header("Location: ../dashboard.php");
    exit;
}

$id = $_GET['id'];

// 🔴 Suppression dans students.xml
$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$studentsRoot = $studentsXml->getAll();

foreach ($studentsRoot->student as $student) {
    if ((string)$student['id'] === $id) {
        $dom = dom_import_simplexml($student);
        $dom->parentNode->removeChild($dom);
        $studentsXml->save();
        break;
    }
}

// 🔴 Suppression dans users.xml
$usersXml = new XmlManager(__DIR__ . "/../../../data/users.xml");
$usersRoot = $usersXml->getAll();

foreach ($usersRoot->user as $user) {
    if ((string)$user['id'] === $id) {
        $dom = dom_import_simplexml($user);
        $dom->parentNode->removeChild($dom);
        $usersXml->save();
        break;
    }
}

// Retour dashboard
header("Location: ../dashboard.php");
exit;