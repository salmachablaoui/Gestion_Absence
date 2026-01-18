<?php
session_start();
require_once __DIR__ . "/controllers/AuthController.php";

// Gestion de la langue
$lang = 'fr'; // Langue par défaut
if (isset($_GET['lang'])) {
    $lang = $_GET['lang'] === 'en' ? 'en' : 'fr';
    $_SESSION['lang'] = $lang;
} elseif (isset($_SESSION['lang'])) {
    $lang = $_SESSION['lang'];
}

// Textes de traduction
$translations = [
    'fr' => [
        'title' => 'Connexion | Système de Gestion des Absences',
        'system_name' => 'Système de Gestion des Absences',
        'login_message' => 'Connectez-vous pour accéder à votre espace',
        'email_label' => 'Adresse email',
        'email_placeholder' => 'votre.email@exemple.com',
        'password_label' => 'Mot de passe',
        'password_placeholder' => 'Votre mot de passe',
        'login_button' => 'Se connecter',
        'contact_text' => 'Problème de connexion ?',
        'contact_link' => 'Contactez l\'administrateur',
        'error_invalid_credentials' => 'Email ou mot de passe incorrect',
        'error_unknown_role' => 'Rôle inconnu',
        'lang_fr' => 'Français',
        'lang_en' => 'Anglais',
        'switch_lang' => 'Changer la langue',
        'current_lang' => 'FR'
    ],
    'en' => [
        'title' => 'Login | Attendance Management System',
        'system_name' => 'Attendance Management System',
        'login_message' => 'Log in to access your account',
        'email_label' => 'Email address',
        'email_placeholder' => 'your.email@example.com',
        'password_label' => 'Password',
        'password_placeholder' => 'Your password',
        'login_button' => 'Sign in',
        'contact_text' => 'Having trouble logging in?',
        'contact_link' => 'Contact administrator',
        'error_invalid_credentials' => 'Invalid email or password',
        'error_unknown_role' => 'Unknown role',
        'lang_fr' => 'French',
        'lang_en' => 'English',
        'switch_lang' => 'Change language',
        'current_lang' => 'EN'
    ]
];

$t = $translations[$lang];

// Initialiser $error à une chaîne vide par défaut
$error = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $auth = new AuthController();

    $email = trim($_POST["email"]);
    $password = trim($_POST["password"]);

    $user = $auth->login($email, $password);

    if ($user !== false) {

        // Si c'est un enseignant, récupérer le module depuis teachers.xml
        $teacherModule = '';
        $teacherClass = '';
        $teacherName = '';

        if ($user["role"] === "teacher") {
            $teachersXml = new DOMDocument();
            $teachersXml->load(__DIR__ . "/data/teachers.xml"); // chemin relatif à adapter si besoin
            $xpath = new DOMXPath($teachersXml);
            $teacherNode = $xpath->query("/teachers/teacher[@id='{$user['id']}']")->item(0);

            if ($teacherNode) {
                $teacherModule = $teacherNode->getElementsByTagName("module")[0]->nodeValue ?? 'Module par défaut';
                $teacherClass  = $teacherNode->getElementsByTagName("class")[0]->nodeValue ?? '';
                $teacherName   = $teacherNode->getElementsByTagName("name")[0]->nodeValue ?? '';
            } else {
                $teacherModule = 'Module par défaut';
            }
        }

        // Stocker l'utilisateur en session
        $_SESSION["user"] = [
            "id" => (string)$user["id"],
            "role" => (string)$user["role"],
            "email" => (string)$user["email"],
            "name" => (string)$teacherName,
            "module" => (string)$teacherModule,
            "class" => (string)$teacherClass
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
                $error = $t['error_unknown_role'];
                break;
        }

        if ($error === "") {
            exit;
        }
    } else {
        $error = $t['error_invalid_credentials'];
    }
}

?>
<!DOCTYPE html>
<html lang="<?php echo $lang; ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($t['title']); ?></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --navy-blue: #0a2647;
            --dark-blue: #144272;
            --medium-blue: #205295;
            --light-blue: #2c74b3;
            --accent-gold: #d4af37;
            --light-gray: #f8f9fa;
            --white: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--navy-blue), var(--dark-blue));
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow-y: auto;
            padding: 20px;
        }

        /* Effet de vague décorative */
        body::before {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 20%;
            background: rgba(255, 255, 255, 0.05);
            clip-path: polygon(0 100%, 100% 100%, 100% 30%, 0 70%);
        }

        /* Conteneur principal */
        .login-container {
            width: 100%;
            max-width: 400px;
            padding: 10px;
            z-index: 10;
        }

        /* Carte de connexion */
        .login-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            position: relative;
        }

        /* En-tête REDUIT */
        .login-header {
            background: linear-gradient(to right, var(--navy-blue), var(--medium-blue));
            color: var(--white);
            padding: 20px 15px;
            text-align: center;
            position: relative;
        }

        .login-header::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 10%;
            width: 80%;
            height: 2px;
            background: var(--accent-gold);
        }

        .logo {
            font-size: 2.2rem;
            margin-bottom: 8px;
            color: var(--accent-gold);
        }

        .login-header h1 {
            font-size: 1.4rem;
            font-weight: 600;
            letter-spacing: 0.3px;
            line-height: 1.3;
            margin-bottom: 5px;
        }

        .login-header p {
            font-size: 0.8rem;
            opacity: 0.9;
            line-height: 1.2;
        }

        /* Sélecteur de langue simple */
        .language-selector {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 20;
        }

        .lang-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: var(--white);
            padding: 6px 12px;
            border-radius: 15px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .lang-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
        }

        .lang-btn i {
            font-size: 0.8rem;
        }

        /* Corps du formulaire */
        .login-body {
            padding: 25px 20px;
        }

        /* Groupes de champs */
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: var(--navy-blue);
            font-weight: 600;
            font-size: 0.85rem;
            letter-spacing: 0.2px;
        }

        .input-with-icon {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--medium-blue);
            font-size: 1rem;
        }

        .input-with-icon input {
            width: 100%;
            padding: 12px 12px 12px 40px;
            border: 2px solid #e1e8f0;
            border-radius: 8px;
            font-size: 0.95rem;
            color: var(--navy-blue);
            background: var(--light-gray);
            transition: all 0.3s ease;
        }

        .input-with-icon input:focus {
            outline: none;
            border-color: var(--light-blue);
            background: var(--white);
            box-shadow: 0 0 0 3px rgba(44, 116, 179, 0.1);
        }

        /* Bouton de connexion */
        .login-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(to right, var(--medium-blue), var(--light-blue));
            color: var(--white);
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            letter-spacing: 0.4px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 10px;
        }

        .login-btn:hover {
            background: linear-gradient(to right, var(--dark-blue), var(--medium-blue));
            box-shadow: 0 6px 15px rgba(44, 116, 179, 0.25);
            transform: translateY(-2px);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        /* Message d'erreur */
        .error-message {
            background: #ffeaea;
            color: #d32f2f;
            padding: 10px 12px;
            border-radius: 6px;
            border-left: 4px solid #d32f2f;
            margin-top: 15px;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: fadeIn 0.5s ease;
        }

        .error-message i {
            font-size: 1rem;
        }

        /* Pied de page */
        .login-footer {
            text-align: center;
            padding: 15px;
            color: #6c757d;
            font-size: 0.8rem;
            border-top: 1px solid #e9ecef;
            background: #f8f9fa;
        }

        .login-footer a {
            color: var(--medium-blue);
            text-decoration: none;
            font-weight: 600;
        }

        .login-footer a:hover {
            text-decoration: underline;
        }

        /* Animation d'apparition */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 480px) {
            .login-container {
                padding: 5px;
                max-width: 350px;
            }
            
            .login-header {
                padding: 15px 10px;
            }
            
            .login-body {
                padding: 20px 15px;
            }
            
            .logo {
                font-size: 1.8rem;
                margin-bottom: 5px;
            }
            
            .login-header h1 {
                font-size: 1.2rem;
                margin-bottom: 3px;
            }
            
            .login-header p {
                font-size: 0.75rem;
            }
            
            .language-selector {
                top: 8px;
                right: 8px;
            }
            
            .lang-btn {
                padding: 5px 10px;
                font-size: 0.7rem;
            }
            
            .form-group {
                margin-bottom: 15px;
            }
            
            .form-group label {
                font-size: 0.8rem;
            }
            
            .input-with-icon input {
                padding: 10px 10px 10px 35px;
                font-size: 0.9rem;
            }
            
            .input-icon {
                left: 10px;
                font-size: 0.9rem;
            }
            
            .login-btn {
                padding: 12px;
                font-size: 0.95rem;
            }
        }
        
        @media (max-width: 360px) {
            .login-container {
                max-width: 320px;
            }
            
            .login-header h1 {
                font-size: 1.1rem;
            }
            
            .login-header p {
                font-size: 0.7rem;
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-card">
        <!-- Sélecteur de langue simple -->
        <div class="language-selector">
            <a href="?lang=<?php echo $lang === 'fr' ? 'en' : 'fr'; ?>" class="lang-btn">
                <i class="fas fa-globe"></i>
                <span><?php echo $t['current_lang']; ?></span>
            </a>
        </div>
        
        <div class="login-header">
            <div class="logo">
                <i class="fas fa-graduation-cap"></i>
            </div>
            <h1><?php echo htmlspecialchars($t['system_name']); ?></h1>
            <p><?php echo htmlspecialchars($t['login_message']); ?></p>
        </div>
        
        <div class="login-body">
            <form method="post">
                <input type="hidden" name="lang" value="<?php echo $lang; ?>">
                
                <div class="form-group">
                    <label for="email"><?php echo htmlspecialchars($t['email_label']); ?></label>
                    <div class="input-with-icon">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" id="email" name="email" 
                               placeholder="<?php echo htmlspecialchars($t['email_placeholder']); ?>" 
                               required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password"><?php echo htmlspecialchars($t['password_label']); ?></label>
                    <div class="input-with-icon">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" id="password" name="password" 
                               placeholder="<?php echo htmlspecialchars($t['password_placeholder']); ?>" 
                               required>
                    </div>
                </div>
                
                <button type="submit" class="login-btn">
                    <i class="fas fa-sign-in-alt"></i>
                    <?php echo htmlspecialchars($t['login_button']); ?>
                </button>
                
                <?php if (!empty($error)): ?>
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <?php echo htmlspecialchars($error); ?>
                    </div>
                <?php endif; ?>
            </form>
        </div>
        
        <div class="login-footer">
            <p><?php echo htmlspecialchars($t['contact_text']); ?> 
               <a href="#"><?php echo htmlspecialchars($t['contact_link']); ?></a>
            </p>
        </div>
    </div>
</div>

<script>
    // Ajout d'un effet de focus amélioré
    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.classList.add('focused');
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.classList.remove('focused');
        });
    });

    // Empêcher la perte de la langue lors de la soumission du formulaire
    document.querySelector('form').addEventListener('submit', function() {
        // La langue est déjà préservée via le champ caché
    });
</script>

</body>
</html>