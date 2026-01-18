<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/dashboard">
        <html lang="fr">
        <head>
            <title data-fr="Dashboard Administrateur" data-en="Admin Dashboard">Dashboard Administrateur</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
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
                    padding: 20px;
                }
                
                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 5px 20px rgba(0, 30, 84, 0.1);
                    overflow: hidden;
                }
                
                /* Header complet en bleu marine */
                .header {
                    background: linear-gradient(135deg, #1a365d, #2c5282);
                    color: white;
                    padding: 25px 30px;
                    border-radius: 12px 12px 0 0;
                }
                
                .header-top {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 20px;
                    flex-wrap: wrap;
                    gap: 15px;
                }
                
                h1 {
                    color: white;
                    border-bottom: none;
                    padding-bottom: 0;
                    margin-bottom: 0;
                    font-size: 28px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }
                
                .header-title {
                    font-size: 28px;
                    font-weight: 700;
                    color: white;
                }
                
                .header-right-section {
                    display: flex;
                    align-items: center;
                    gap: 20px;
                    flex-wrap: wrap;
                }
                
                .language-switcher {
                    display: flex;
                    gap: 8px;
                }
                
                .lang-btn {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    padding: 10px 15px;
                    background: rgba(255, 255, 255, 0.15);
                    color: white;
                    text-decoration: none;
                    border-radius: 6px;
                    font-weight: 600;
                    transition: all 0.3s ease;
                    border: 2px solid rgba(255, 255, 255, 0.3);
                    cursor: pointer;
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
                
                /* Bouton déconnexion dans le header */
                .logout-header {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    padding: 10px 18px;
                    background: rgba(255, 255, 255, 0.1);
                    color: white;
                    text-decoration: none;
                    border-radius: 6px;
                    font-weight: 600;
                    transition: all 0.3s ease;
                    border: 2px solid rgba(255, 255, 255, 0.2);
                }
                
                .logout-header:hover {
                    background: rgba(255, 255, 255, 0.2);
                    transform: translateY(-2px);
                    border-color: white;
                }
                
                /* Boutons d'action dans le header */
                .header-actions {
                    display: flex;
                    gap: 15px;
                    flex-wrap: wrap;
                }
                
                .header-btn {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    padding: 12px 20px;
                    background: rgba(255, 255, 255, 0.15);
                    color: white;
                    text-decoration: none;
                    border-radius: 6px;
                    font-weight: 600;
                    transition: all 0.3s ease;
                    border: 2px solid rgba(255, 255, 255, 0.2);
                }
                
                .header-btn:hover {
                    background: rgba(255, 255, 255, 0.25);
                    transform: translateY(-2px);
                    border-color: white;
                }
                
                .main-content {
                    padding: 30px;
                }
                
                h2 {
                    color: #2c5282;
                    margin: 30px 0 15px 0;
                    padding-left: 10px;
                    border-left: 4px solid #4299e1;
                    font-size: 22px;
                }
                
                /* Boutons dans le contenu principal - SUPPRIMÉS */
                .content-actions {
                    display: none; /* Masquer cette section car les boutons sont déjà dans le header */
                }
                
                .btn {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    padding: 12px 20px;
                    background: linear-gradient(135deg, #1a365d, #2c5282);
                    color: white;
                    text-decoration: none;
                    border-radius: 6px;
                    font-weight: 600;
                    transition: all 0.3s ease;
                    border: none;
                    cursor: pointer;
                }
                
                .btn:hover {
                    background: linear-gradient(135deg, #2c5282, #3182ce);
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(44, 82, 130, 0.2);
                }
                
                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin: 20px 0;
                    border-radius: 8px;
                    overflow: hidden;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                }
                
                th {
                    background: linear-gradient(to right, #1a365d, #2c5282);
                    color: white;
                    font-weight: 600;
                    padding: 15px;
                    text-align: left;
                    font-size: 15px;
                }
                
                td {
                    padding: 14px 15px;
                    border-bottom: 1px solid #e2e8f0;
                }
                
                tr:nth-child(even) {
                    background-color: #f7fafc;
                }
                
                tr:hover {
                    background-color: #ebf8ff;
                }
                
                .edit, .delete {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    width: 36px;
                    height: 36px;
                    border-radius: 50%;
                    text-decoration: none;
                    font-size: 16px;
                    margin: 0 5px;
                    transition: all 0.2s ease;
                }
                
                .edit {
                    background-color: #e6fffa;
                    color: #00a78e;
                    border: 1px solid #00a78e;
                }
                
                .edit:hover {
                    background-color: #00a78e;
                    color: white;
                }
                
                .delete {
                    background-color: #fff5f5;
                    color: #e53e3e;
                    border: 1px solid #e53e3e;
                }
                
                .delete:hover {
                    background-color: #e53e3e;
                    color: white;
                }
                
                @media (max-width: 768px) {
                    .container {
                        padding: 0;
                    }
                    
                    .header {
                        padding: 20px 15px;
                    }
                    
                    .header-top {
                        flex-direction: column;
                        align-items: stretch;
                        gap: 20px;
                    }
                    
                    .header-right-section {
                        justify-content: center;
                        flex-wrap: wrap;
                    }
                    
                    .header-actions {
                        justify-content: center;
                        width: 100%;
                    }
                    
                    .main-content {
                        padding: 20px 15px;
                    }
                    
                    .content-actions {
                        flex-direction: column;
                        width: 100%;
                    }
                    
                    .btn {
                        width: 100%;
                        justify-content: center;
                    }
                    
                    table {
                        display: block;
                        overflow-x: auto;
                    }
                    
                    th, td {
                        padding: 10px;
                        font-size: 14px;
                    }
                }
                
                @media (max-width: 480px) {
                    .header-right-section {
                        flex-direction: column;
                        align-items: stretch;
                        gap: 10px;
                    }
                    
                    .language-switcher {
                        width: 100%;
                        justify-content: center;
                    }
                    
                    .logout-header {
                        width: 100%;
                        justify-content: center;
                    }
                    
                    .header-actions {
                        flex-direction: column;
                    }
                    
                    .header-btn {
                        width: 100%;
                        justify-content: center;
                    }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <!-- Header complet en bleu marine -->
                <div class="header">
                    <div class="header-top">
                        <h1>
                            <span style="font-size:28px">🛠</span>
                            <span class="header-title translatable" data-fr="Dashboard Administrateur" data-en="Admin Dashboard">Dashboard Administrateur</span>
                        </h1>
                        
                        <div class="header-right-section">
                            <div class="language-switcher">
                                <button class="lang-btn active" onclick="switchLanguage('fr')">
                                    <span style="font-size:18px">🇫🇷</span> <span class="translatable" data-fr="FR" data-en="FR">FR</span>
                                </button>
                                <button class="lang-btn" onclick="switchLanguage('en')">
                                    <span style="font-size:18px">🇬🇧</span> <span class="translatable" data-fr="EN" data-en="EN">EN</span>
                                </button>
                            </div>
                            <a href="../../logout.php" class="logout-header">
                                <span style="font-size:18px">🔒</span> <span class="translatable" data-fr="Déconnexion" data-en="Logout">Déconnexion</span>
                            </a>
                        </div>
                    </div>
                    
                    <!-- Boutons Ajouter Étudiant/Enseignant dans le header -->
                    <div class="header-actions">
                        <a href="students/add.php" class="header-btn">
                            <span style="font-size:18px">➕</span> <span class="btn-text translatable" data-fr="Ajouter Étudiant" data-en="Add Student">Ajouter Étudiant</span>
                        </a>
                        <a href="teachers/add.php" class="header-btn">
                            <span style="font-size:18px">➕</span> <span class="btn-text translatable" data-fr="Ajouter Enseignant" data-en="Add Teacher">Ajouter Enseignant</span>
                        </a>
                    </div>
                </div>
                
                <!-- Contenu principal -->
                <div class="main-content">
                    <!-- Section .content-actions supprimée car les boutons sont dans le header -->

                    <!-- ================= ÉTUDIANTS ================= -->
                    <h2 class="translatable" data-fr="👨‍🎓 Étudiants" data-en="👨‍🎓 Students">👨‍🎓 Étudiants</h2>
                    <table>
                        <thead>
                            <tr>
                                <th><span class="translatable" data-fr="ID" data-en="ID">ID</span></th>
                                <th><span class="translatable" data-fr="Nom" data-en="Name">Nom</span></th>
                                <th><span class="translatable" data-fr="Email" data-en="Email">Email</span></th>
                                <th><span class="translatable" data-fr="Classe" data-en="Class">Classe</span></th>
                                <th><span class="translatable" data-fr="Actions" data-en="Actions">Actions</span></th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="students/student">
                                <tr>
                                    <td><xsl:value-of select="@id"/></td>
                                    <td><xsl:value-of select="name"/></td>
                                    <td><xsl:value-of select="email"/></td>
                                    <td><xsl:value-of select="class"/></td>
                                    <td>
                                        <a href="students/edit.php?id={@id}" class="edit" title="Modifier" data-fr-title="Modifier" data-en-title="Edit">
                                            <span class="translatable" data-fr="✏" data-en="✏">✏</span>
                                        </a>
                                        <a href="students/delete.php?id={@id}"
                                           class="delete"
                                           data-fr-confirm="Êtes-vous sûr de vouloir supprimer cet étudiant ?"
                                           data-en-confirm="Are you sure you want to delete this student?"
                                           title="Supprimer"
                                           data-fr-title="Supprimer"
                                           data-en-title="Delete">
                                            <span class="translatable" data-fr="🗑" data-en="🗑">🗑</span>
                                        </a>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>

                    <!-- ================= ENSEIGNANTS ================= -->
                    <h2 class="translatable" data-fr="👨‍🏫 Enseignants" data-en="👨‍🏫 Teachers">👨‍🏫 Enseignants</h2>
                    <table>
                        <thead>
                            <tr>
                                <th><span class="translatable" data-fr="ID" data-en="ID">ID</span></th>
                                <th><span class="translatable" data-fr="Nom" data-en="Name">Nom</span></th>
                                <th><span class="translatable" data-fr="Email" data-en="Email">Email</span></th>
                                <th><span class="translatable" data-fr="Classe" data-en="Class">Classe</span></th>
                                <th><span class="translatable" data-fr="Module" data-en="Module">Module</span></th>
                                <th><span class="translatable" data-fr="Actions" data-en="Actions">Actions</span></th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="teachers/teacher">
                                <tr>
                                    <td><xsl:value-of select="@id"/></td>
                                    <td><xsl:value-of select="name"/></td>
                                    <td><xsl:value-of select="email"/></td>
                                    <td><xsl:value-of select="class"/></td>
                                    <td><xsl:value-of select="module"/></td>
                                    <td>
                                        <a href="teachers/edit.php?id={@id}" class="edit" title="Modifier" data-fr-title="Modifier" data-en-title="Edit">
                                            <span class="translatable" data-fr="✏" data-en="✏">✏</span>
                                        </a>
                                        <a href="teachers/delete.php?id={@id}"
                                           class="delete"
                                           data-fr-confirm="Êtes-vous sûr de vouloir supprimer cet enseignant ?"
                                           data-en-confirm="Are you sure you want to delete this teacher?"
                                           title="Supprimer"
                                           data-fr-title="Supprimer"
                                           data-en-title="Delete">
                                            <span class="translatable" data-fr="🗑" data-en="🗑">🗑</span>
                                        </a>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </div>
            </div>
            
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
                    
                    // Mettre à jour les attributs title
                    document.querySelectorAll('[data-fr-title]').forEach(element => {
                        const titleText = element.getAttribute(`data-${lang}-title`);
                        if (titleText) {
                            element.title = titleText;
                        }
                    });
                    
                    // Stocker la préférence de langue
                    localStorage.setItem('dashboard-language', lang);
                }
                
                // Fonction pour gérer la suppression avec confirmation
                function confirmDelete(event, element) {
                    event.preventDefault();
                    
                    const lang = localStorage.getItem('dashboard-language') || 'fr';
                    const confirmAttr = element.getAttribute(`data-${lang}-confirm`);
                    let message = '';
                    
                    if (confirmAttr) {
                        message = confirmAttr;
                    } else {
                        message = lang === 'en' 
                            ? 'Are you sure you want to delete this item?' 
                            : 'Êtes-vous sûr de vouloir effectuer cette suppression ?';
                    }
                    
                    if (confirm(message)) {
                        window.location.href = element.href;
                    }
                    
                    return false;
                }
                
                // Initialiser la langue au chargement
                document.addEventListener('DOMContentLoaded', function() {
                    // Récupérer la langue sauvegardée ou utiliser le français par défaut
                    const savedLang = localStorage.getItem('dashboard-language') || 'fr';
                    if (savedLang !== 'fr') {
                        switchLanguage(savedLang);
                    }
                    
                    // Configurer les événements de suppression
                    document.querySelectorAll('a.delete').forEach(link => {
                        link.addEventListener('click', function(e) {
                            return confirmDelete(e, this);
                        });
                        
                        // Supprimer l'attribut onclick existant
                        link.removeAttribute('onclick');
                    });
                    
                    // Configurer les événements des boutons de langue
                    document.querySelectorAll('.lang-btn').forEach(btn => {
                        btn.addEventListener('click', function() {
                            const lang = this.getAttribute('onclick').includes("'fr'") ? 'fr' : 'en';
                            switchLanguage(lang);
                        });
                    });
                });
            </script>
        </body>
        </html>
    </xsl:template>

</xsl:stylesheet>