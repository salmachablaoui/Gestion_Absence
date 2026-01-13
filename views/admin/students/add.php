<?php
session_start();
require_once "../../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$usersXml = new XmlManager(__DIR__ . "/../../../data/users.xml");

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $id = uniqid("u");

    // 1️⃣ Ajouter dans students.xml
    $student = $studentsXml->getAll()->addChild("student");
    $student->addAttribute("id", $id);
    $student->addChild("name", $_POST["name"]);
    $student->addChild("email", $_POST["email"]);
    $student->addChild("class", $_POST["class"]);
    $studentsXml->save();

    // 2️⃣ Ajouter dans users.xml
    $user = $usersXml->getAll()->addChild("user");
    $user->addAttribute("id", $id);
    $user->addAttribute("role", "student");
    $user->addChild("email", $_POST["email"]);
    $user->addChild("password", $_POST["password"]);
    $usersXml->save();

    header("Location: ../dashboard.php");
    exit;
}
?>
