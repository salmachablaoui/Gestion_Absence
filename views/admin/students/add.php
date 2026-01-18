<?php
session_start();
require_once "../../../models/XmlManager.php";

// Vérifier que l'utilisateur est admin
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

// Charger XML
$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$usersXml    = new XmlManager(__DIR__ . "/../../../data/users.xml");
$classesXml  = new XmlManager(__DIR__ . "/../../../data/classes.xml");

$classes = $classesXml->getAll()->class;

// Traitement ajout
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $id = uniqid("u");

    // ➕ students.xml
    $student = $studentsXml->getAll()->addChild("student");
    $student->addAttribute("id", $id);
    $student->addChild("name", htmlspecialchars($_POST["name"]));
    $student->addChild("email", htmlspecialchars($_POST["email"]));
    $student->addChild("class", htmlspecialchars($_POST["class"]));
    $studentsXml->save();

    // ➕ users.xml
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

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title data-fr="Ajouter Étudiant - Système de Gestion" data-en="Add Student - Management System">Ajouter Étudiant - Système de Gestion</title>
    <link rel="stylesheet" href="../../../assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .header {
            background: linear-gradient(135deg, #1a365d, #2c5282);
            color: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 1.8rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header h1 i {
            color: #3498db;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info span {
            font-weight: 500;
        }

        /* Boutons de langue */
        .language-switcher {
            display: flex;
            gap: 8px;
        }
        
        .lang-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 12px;
            background: rgba(255, 255, 255, 0.15);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 2px solid rgba(255, 255, 255, 0.3);
            cursor: pointer;
            font-size: 0.9rem;
        }
        
        .lang-btn.active {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            border-color: white;
        }
        
        .lang-btn:hover:not(.active) {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-1px);
        }

        .logout-btn {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.2);
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .logout-btn:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
            border-color: white;
        }

        .container {
            display: flex;
            flex: 1;
        }

        .sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: white;
            padding: 2rem 0;
            box-shadow: 3px 0 10px rgba(0, 0, 0, 0.1);
        }

        .sidebar nav ul {
            list-style: none;
        }

        .sidebar nav ul li {
            margin-bottom: 5px;
        }

        .sidebar nav ul li a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 25px;
            color: #bdc3c7;
            text-decoration: none;
            transition: all 0.3s;
            font-size: 1rem;
        }

        .sidebar nav ul li a:hover,
        .sidebar nav ul li a.active {
            background-color: #34495e;
            color: white;
            border-left: 4px solid #3498db;
            padding-left: 21px;
        }

        .sidebar nav ul li a i {
            width: 20px;
            text-align: center;
        }

        .main-content {
            flex: 1;
            padding: 2.5rem;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
        }

        .page-title {
            width: 100%;
            max-width: 800px;
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #eee;
        }

        .page-title h2 {
            font-size: 1.8rem;
            color: #2c3e50;
        }

        .page-title i {
            color: #3498db;
            font-size: 1.8rem;
        }

        /* Formulaire centré */
        .form-container {
            width: 100%;
            max-width: 800px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 2.5rem;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #eee;
        }

        .form-header h3 {
            font-size: 1.5rem;
            color: #2c3e50;
        }

        .form-header i {
            color: #2ecc71;
            font-size: 1.5rem;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 1.5rem;
        }

        .form-group {
            flex: 1;
            margin-bottom: 1.5rem;
        }

        .form-group.full-width {
            width: 100%;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #2c3e50;
            font-size: 0.95rem;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s;
            background-color: #f9f9f9;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.15);
            background-color: white;
        }

        .form-group input::placeholder {
            color: #95a5a6;
        }

        .password-info {
            margin-top: 0.5rem;
            color: #7f8c8d;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .password-info i {
            color: #f39c12;
        }

        .form-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 2.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #eee;
        }

        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-width: 160px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
            box-shadow: 0 4px 15px rgba(46, 204, 113, 0.2);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(46, 204, 113, 0.3);
        }

        .btn-secondary {
            background-color: white;
            color: #7f8c8d;
            border: 2px solid #ddd;
        }

        .btn-secondary:hover {
            background-color: #f8f9fa;
            border-color: #95a5a6;
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .form-note {
            background-color: #f8f9fa;
            border-left: 4px solid #3498db;
            padding: 1rem 1.5rem;
            margin-top: 2rem;
            border-radius: 0 8px 8px 0;
            font-size: 0.9rem;
            color: #555;
        }

        .form-note i {
            color: #3498db;
            margin-right: 8px;
        }

        .footer {
            text-align: center;
            padding: 1.5rem;
            background-color: #2c3e50;
            color: #bdc3c7;
            margin-top: auto;
            font-size: 0.9rem;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .form-container {
                padding: 2rem;
                max-width: 95%;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                padding: 1rem 0;
            }
            
            .main-content {
                padding: 1.5rem;
            }
            
            .form-container {
                padding: 1.5rem;
            }
            
            .form-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
                padding: 1rem;
            }
            
            .header-right-section {
                flex-direction: column;
                align-items: stretch;
                gap: 10px;
            }
            
            .form-container {
                padding: 1.25rem;
                box-shadow: none;
                border: 1px solid #eee;
            }
        }
    </style>
</head>
<body>

    <!-- Header -->
    <header class="header">
        <h1>
            <i class="fas fa-graduation-cap"></i>
            <span class="translatable" data-fr="Système de Gestion Scolaire" data-en="School Management System"></span>
        </h1>
        <div class="user-info">
            <div class="language-switcher">
                <button class="lang-btn active" onclick="switchLanguage('fr')">
                    <span style="font-size:16px">🇫🇷</span> <span class="translatable" data-fr="FR" data-en="FR">FR</span>
                </button>
                <button class="lang-btn" onclick="switchLanguage('en')">
                    <span style="font-size:16px">🇬🇧</span> <span class="translatable" data-fr="EN" data-en="EN">EN</span>
                </button>
            </div>
            <span><i class="fas fa-user-circle"></i> <?php echo htmlspecialchars($_SESSION["user"]["email"] ?? "Admin"); ?></span>
            <a href="../../../logout.php" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> <span class="translatable" data-fr="Déconnexion" data-en="Logout">Déconnexion</span>
            </a>
        </div>
    </header>

    <div class="container">
        <!-- Sidebar Navigation -->
        

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-title">
                <i class="fas fa-user-plus"></i>
                <h2 class="translatable" data-fr="Ajouter un nouvel étudiant" data-en="Add a new student">Ajouter un nouvel étudiant</h2>
            </div>

            <!-- Formulaire centré -->
            <div class="form-container">
                <div class="form-header">
                    <i class="fas fa-user-plus"></i>
                    <h3 class="translatable" data-fr="Informations de l'étudiant" data-en="Student Information">Informations de l'étudiant</h3>
                </div>

                <form method="post" id="studentForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="name">
                                <i class="fas fa-user"></i> 
                                <span class="translatable" data-fr="Nom complet :" data-en="Full Name:">Nom complet :</span>
                            </label>
                            <input type="text" id="name" name="name" 
                                   placeholder="<?php echo htmlspecialchars(isset($_SESSION['lang']) && $_SESSION['lang'] === 'en' ? 'Ex: John Doe' : 'Ex: Jean Dupont'); ?>" 
                                   required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i> 
                                <span class="translatable" data-fr="Adresse email :" data-en="Email Address:">Adresse email :</span>
                            </label>
                            <input type="email" id="email" name="email" 
                                   placeholder="<?php echo htmlspecialchars(isset($_SESSION['lang']) && $_SESSION['lang'] === 'en' ? 'Ex: john.doe@school.edu' : 'Ex: jean.dupont@ecole.fr'); ?>" 
                                   required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="class">
                            <i class="fas fa-chalkboard"></i> 
                            <span class="translatable" data-fr="Classe :" data-en="Class:">Classe :</span>
                        </label>
                        <select id="class" name="class" required>
                            <option value="" class="translatable" data-fr="-- Sélectionnez une classe --" data-en="-- Select a class --">-- Sélectionnez une classe --</option>
                            <?php foreach ($classes as $class): ?>
                                <option value="<?= htmlspecialchars($class['id']) ?>">
                                    <?= htmlspecialchars($class->name) ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="password">
                                <i class="fas fa-lock"></i> 
                                <span class="translatable" data-fr="Mot de passe :" data-en="Password:">Mot de passe :</span>
                            </label>
                            <input type="password" id="password" name="password" 
                                   placeholder="<?php echo htmlspecialchars(isset($_SESSION['lang']) && $_SESSION['lang'] === 'en' ? 'Minimum 8 characters' : 'Minimum 8 caractères'); ?>" 
                                   required minlength="8">
                            <div class="password-info">
                                <i class="fas fa-info-circle"></i>
                                <span class="translatable" data-fr="Le mot de passe doit contenir au moins 8 caractères" data-en="Password must contain at least 8 characters">Le mot de passe doit contenir au moins 8 caractères</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirm_password">
                                <i class="fas fa-lock"></i> 
                                <span class="translatable" data-fr="Confirmer le mot de passe :" data-en="Confirm Password:">Confirmer le mot de passe :</span>
                            </label>
                            <input type="password" id="confirm_password" name="confirm_password" 
                                   placeholder="<?php echo htmlspecialchars(isset($_SESSION['lang']) && $_SESSION['lang'] === 'en' ? 'Repeat the password' : 'Répétez le mot de passe'); ?>" 
                                   required minlength="8">
                        </div>
                    </div>

                    <div class="form-note">
                        <i class="fas fa-lightbulb"></i>
                        <span class="translatable" data-fr="L'étudiant pourra se connecter avec son email et le mot de passe défini ci-dessus." 
                              data-en="The student will be able to log in with their email and the password defined above.">
                            L'étudiant pourra se connecter avec son email et le mot de passe défini ci-dessus.
                        </span>
                    </div>

                    <div class="form-buttons">
                        <a href="../dashboard.php" class="btn btn-secondary">
                            <i class="fas fa-times"></i> 
                            <span class="translatable" data-fr="Annuler" data-en="Cancel">Annuler</span>
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check"></i> 
                            <span class="translatable" data-fr="Ajouter l'étudiant" data-en="Add Student">Ajouter l'étudiant</span>
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <!-- Footer -->
    

    <script>
        // Fonction de changement de langue
        function switchLanguage(lang) {
            // Mettre à jour les boutons de langue
            document.querySelectorAll('.lang-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            document.querySelectorAll(`.lang-btn[onclick="switchLanguage('${lang}')"]`).forEach(btn => {
                btn.classList.add('active');
            });
            
            // Mettre à jour l'attribut lang de l'html
            document.documentElement.lang = lang;
            
            // Mettre à jour le titre de la page
            const title = document.querySelector('title');
            if (title.dataset[lang]) {
                title.textContent = title.dataset[lang];
            }
            
            // Traduire tous les éléments avec la classe "translatable"
            document.querySelectorAll('.translatable').forEach(element => {
                const text = element.getAttribute(`data-${lang}`);
                if (text) {
                    element.textContent = text;
                }
            });
            
            // Mettre à jour les placeholders
            updatePlaceholders(lang);
            
            // Stocker la préférence de langue
            localStorage.setItem('language', lang);
            
            // Envoyer la préférence au serveur via une requête AJAX
            fetch('../../../set_language.php?lang=' + lang, {
                method: 'GET'
            });
        }
        
        // Mettre à jour les placeholders
        function updatePlaceholders(lang) {
            const placeholders = {
                'name': {
                    'fr': 'Ex: Jean Dupont',
                    'en': 'Ex: John Doe'
                },
                'email': {
                    'fr': 'Ex: jean.dupont@ecole.fr',
                    'en': 'Ex: john.doe@school.edu'
                },
                'password': {
                    'fr': 'Minimum 8 caractères',
                    'en': 'Minimum 8 characters'
                },
                'confirm_password': {
                    'fr': 'Répétez le mot de passe',
                    'en': 'Repeat the password'
                }
            };
            
            for (const [field, translations] of Object.entries(placeholders)) {
                const input = document.getElementById(field);
                if (input && translations[lang]) {
                    input.placeholder = translations[lang];
                }
            }
        }
        
        // Initialiser la langue au chargement
        document.addEventListener('DOMContentLoaded', function() {
            // Récupérer la langue sauvegardée ou utiliser le français par défaut
            const savedLang = localStorage.getItem('language') || 'fr';
            if (savedLang !== 'fr') {
                switchLanguage(savedLang);
            }
        });

        // Validation du formulaire
        document.getElementById("studentForm").addEventListener("submit", function(e) {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirm_password").value;
            
            // Validation des mots de passe
            if (password !== confirmPassword) {
                e.preventDefault();
                const lang = localStorage.getItem('language') || 'fr';
                const message = lang === 'en' 
                    ? "Passwords don't match. Please check." 
                    : "Les mots de passe ne correspondent pas. Veuillez vérifier.";
                alert(message);
                document.getElementById("confirm_password").focus();
                return false;
            }
            
            // Validation de la longueur du mot de passe
            if (password.length < 8) {
                e.preventDefault();
                const lang = localStorage.getItem('language') || 'fr';
                const message = lang === 'en' 
                    ? "Password must contain at least 8 characters." 
                    : "Le mot de passe doit contenir au moins 8 caractères.";
                alert(message);
                document.getElementById("password").focus();
                return false;
            }
            
            // Validation de l'email
            const email = document.getElementById("email").value;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                const lang = localStorage.getItem('language') || 'fr';
                const message = lang === 'en' 
                    ? "Please enter a valid email address." 
                    : "Veuillez saisir une adresse email valide.";
                alert(message);
                document.getElementById("email").focus();
                return false;
            }
            
            // Validation du nom
            const name = document.getElementById("name").value;
            if (name.trim().length < 2) {
                e.preventDefault();
                const lang = localStorage.getItem('language') || 'fr';
                const message = lang === 'en' 
                    ? "Please enter a valid full name." 
                    : "Veuillez saisir un nom complet valide.";
                alert(message);
                document.getElementById("name").focus();
                return false;
            }
            
            // Validation de la classe
            const selectedClass = document.getElementById("class").value;
            if (!selectedClass) {
                e.preventDefault();
                const lang = localStorage.getItem('language') || 'fr';
                const message = lang === 'en' 
                    ? "Please select a class." 
                    : "Veuillez sélectionner une classe.";
                alert(message);
                document.getElementById("class").focus();
                return false;
            }
            
            // Confirmation avant soumission
            const lang = localStorage.getItem('language') || 'fr';
            const confirmationMessage = lang === 'en' 
                ? "Are you sure you want to add this student?" 
                : "Êtes-vous sûr de vouloir ajouter cet étudiant ?";
            
            const confirmation = confirm(confirmationMessage);
            if (!confirmation) {
                e.preventDefault();
                return false;
            }
            
            return true;
        });

        // Animation de chargement lors de la soumission
        const form = document.getElementById("studentForm");
        const submitBtn = form.querySelector('button[type="submit"]');
        
        form.addEventListener("submit", function() {
            const lang = localStorage.getItem('language') || 'fr';
            const loadingText = lang === 'en' 
                ? 'Adding...' 
                : 'Ajout en cours...';
            
            submitBtn.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${loadingText}`;
            submitBtn.disabled = true;
        });

        // Affichage dynamique de la force du mot de passe
        const passwordInput = document.getElementById("password");
        const passwordInfo = document.querySelector('.password-info span');
        
        passwordInput.addEventListener('input', function() {
            const lang = localStorage.getItem('language') || 'fr';
            const strength = calculatePasswordStrength(this.value);
            let message = '';
            let color = '';
            
            if (this.value.length === 0) {
                message = lang === 'en' 
                    ? 'Password must contain at least 8 characters' 
                    : 'Le mot de passe doit contenir au moins 8 caractères';
                color = '#7f8c8d';
            } else if (this.value.length < 8) {
                message = lang === 'en' 
                    ? 'Too short - minimum 8 characters' 
                    : 'Trop court - minimum 8 caractères';
                color = '#e74c3c';
            } else if (strength < 3) {
                message = lang === 'en' 
                    ? 'Weak - add uppercase, numbers and special characters' 
                    : 'Faible - ajoutez des majuscules, chiffres et caractères spéciaux';
                color = '#e67e22';
            } else if (strength < 5) {
                message = lang === 'en' 
                    ? 'Medium - can be improved' 
                    : 'Moyen - peut être amélioré';
                color = '#f39c12';
            } else {
                message = lang === 'en' 
                    ? 'Strong - excellent password' 
                    : 'Fort - excellent mot de passe';
                color = '#27ae60';
            }
            
            passwordInfo.textContent = message;
            passwordInfo.style.color = color;
        });

        function calculatePasswordStrength(password) {
            let strength = 0;
            
            // Longueur
            if (password.length >= 8) strength++;
            if (password.length >= 12) strength++;
            
            // Diversité
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            
            return strength;
        }
    </script>

</body>
</html>