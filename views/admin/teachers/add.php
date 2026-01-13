<?php
session_start();
require_once "../../../models/XmlManager.php";

if ($_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

$teachersXml = new XmlManager(__DIR__ . "/../../../data/teachers.xml");
$usersXml = new XmlManager(__DIR__ . "/../../../data/users.xml");

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $id = uniqid("u");

    // 1️⃣ teachers.xml
    $teacher = $teachersXml->getAll()->addChild("teacher");
    $teacher->addAttribute("id", $id);
    $teacher->addChild("name", $_POST["name"]);
    $teacher->addChild("email", $_POST["email"]);
    $teacher->addChild("module", $_POST["module"]);
    $teachersXml->save();

    // 2️⃣ users.xml
    $user = $usersXml->getAll()->addChild("user");
    $user->addAttribute("id", $id);
    $user->addAttribute("role", "teacher");
    $user->addChild("email", $_POST["email"]);
    $user->addChild("password", $_POST["password"]);
    $usersXml->save();

    header("Location: ../dashboard.php");
}
?>

