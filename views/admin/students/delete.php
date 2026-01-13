<?php
session_start();
require_once "../../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

if (!isset($_GET['id'])) {
    header("Location: ../dashboard.php");
    exit;
}

$idToDelete = $_GET['id'];

// 1️⃣ Supprimer dans students.xml
$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$studentsRoot = $studentsXml->getAll();
foreach ($studentsRoot->student as $student) {
    if ((string)$student['id'] === $idToDelete) {
        $dom = dom_import_simplexml($student);
        $dom->parentNode->removeChild($dom);
        $studentsXml->save();
        break;
    }
}

// 2️⃣ Supprimer dans users.xml
$usersXml = new XmlManager(__DIR__ . "/../../../data/users.xml");
$usersRoot = $usersXml->getAll();
foreach ($usersRoot->user as $user) {
    if ((string)$user['id'] === $idToDelete) {
        $dom = dom_import_simplexml($user);
        $dom->parentNode->removeChild($dom);
        $usersXml->save();
        break;
    }
}

// Redirection vers le dashboard pour mise à jour automatique
header("Location: ../dashboard.php");
exit;
