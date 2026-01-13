<?php
session_start();
require_once __DIR__ . "/controllers/AuthController.php";

$error = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $auth = new AuthController();

    $email = trim($_POST["email"]);
    $password = trim($_POST["password"]);

    $user = $auth->login($email, $password);

    if ($user !== false) {
        // Stocker l'utilisateur en session
        $_SESSION["user"] = [
            "id" => (string)$user["id"],
            "role" => (string)$user["role"],
            "email" => (string)$user["email"]
        ];

        // Redirection selon le rôle
        switch ($user["role"]) {
            case "admin":
                header("Location: views/admin/dashboard.php");
                break;

            case "teacher":
                header("Location: views/teacher/dashboard.php");
                break;

            case "student":
                header("Location: views/student/dashboard.php");
                break;

            default:
                $error = "Rôle inconnu";
        }
        exit;
    } else {
        $error = "Email ou mot de passe incorrect";
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion | Gestion des absences</title>
    <style>
        body {
            margin: 0;
            height: 100vh;
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-box {
            background: #fff;
            width: 360px;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2);
        }

        .login-box h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .login-box input {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        .login-box button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background: #667eea;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }

        .login-box button:hover {
            background: #5563c1;
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>Connexion</h2>

    <form method="post">
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Mot de passe" required>
        <button type="submit">Se connecter</button>
    </form>

    <?php if ($error): ?>
        <div class="error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>
</div>

</body>
</html>
