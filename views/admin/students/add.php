<?php
session_start();
require_once "../../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$usersXml    = new XmlManager(__DIR__ . "/../../../data/users.xml");

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    // Sécurité minimale
    if (
        empty($_POST["name"]) ||
        empty($_POST["email"]) ||
        empty($_POST["class"]) ||
        empty($_POST["module"]) ||
        empty($_POST["password"])
    ) {
        die("Champs manquants");
    }

    $id = uniqid("u");

    /* 1️⃣ students.xml */
    $student = $studentsXml->getAll()->addChild("student");
    $student->addAttribute("id", $id);
    $student->addChild("name", htmlspecialchars($_POST["name"]));
    $student->addChild("email", htmlspecialchars($_POST["email"]));
    $student->addChild("class", htmlspecialchars($_POST["class"]));
    $student->addChild("module", htmlspecialchars($_POST["module"]));
    $studentsXml->save();

    /* 2️⃣ users.xml */
    $user = $usersXml->getAll()->addChild("user");
    $user->addAttribute("id", $id);
    $user->addAttribute("role", "student");
    $user->addChild("email", htmlspecialchars($_POST["email"]));
    $user->addChild("password", password_hash($_POST["password"], PASSWORD_DEFAULT));
    $usersXml->save();

    header("Location: ../dashboard.php");
    exit;
}
?>
