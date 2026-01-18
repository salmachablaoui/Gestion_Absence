<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html lang="fr">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title data-fr="Dashboard Étudiant | Gestion Absences" data-en="Student Dashboard | Absence Management">Dashboard Étudiant | Gestion Absences</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
          /* Variables de couleurs */
          :root {
            --primary-blue: #0a2463;
            --secondary-blue: #1e3a8a;
            --accent-blue: #3b82f6;
            --light-blue: #93c5fd;
            --light-gray: #f8fafc;
            --white: #ffffff;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --text-dark: #1e293b;
            --text-light: #64748b;
          }
          
          /* Reset et styles de base */
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }
          
          body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f1f5f9;
            color: var(--text-dark);
            line-height: 1.6;
          }
          
          /* Header */
          .header {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
            color: var(--white);
            padding: 25px 40px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            position: relative;
          }
          
          .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
          }
          
          .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
          }
          
          .header h1 {
            font-size: 2.2rem;
            font-weight: 600;
            letter-spacing: 0.5px;
          }
          
          .header p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-top: 8px;
          }
          
          /* Boutons d'action header */
          .header-actions {
            display: flex;
            gap: 15px;
            align-items: center;
          }
          
          /* Boutons de langue */
          .language-switcher {
            display: flex;
            gap: 5px;
            background-color: rgba(255, 255, 255, 0.15);
            border-radius: 8px;
            padding: 5px;
            border: 1px solid rgba(255, 255, 255, 0.2);
          }
          
          .lang-btn {
            background: none;
            border: none;
            color: var(--white);
            padding: 8px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
          }
          
          .lang-btn.active {
            background-color: rgba(255, 255, 255, 0.25);
          }
          
          .lang-btn:hover:not(.active) {
            background-color: rgba(255, 255, 255, 0.1);
          }
          
          /* Bouton Logout */
          .logout-btn {
            background-color: rgba(255, 255, 255, 0.15);
            color: var(--white);
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 12px 25px;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
          }
          
          .logout-btn:hover {
            background-color: rgba(255, 255, 255, 0.25);
            border-color: rgba(255, 255, 255, 0.5);
            transform: translateY(-2px);
          }
          
          /* Onglets */
          .tabs-container {
            background-color: var(--white);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 0 40px;
            max-width: 1400px;
            margin: 0 auto;
          }
          
          .tabs {
            display: flex;
            border-bottom: 2px solid #e2e8f0;
          }
          
          .tab-btn {
            background: none;
            border: none;
            padding: 20px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-light);
            cursor: pointer;
            position: relative;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
          }
          
          .tab-btn:hover {
            color: var(--primary-blue);
            background-color: #f1f5f9;
          }
          
          .tab-btn.active {
            color: var(--primary-blue);
          }
          
          .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 4px;
            background-color: var(--accent-blue);
            border-radius: 2px 2px 0 0;
          }
          
          /* Contenu principal */
          .main-content {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 40px;
          }
          
          .tab-content {
            display: none;
            animation: fadeIn 0.5s ease;
          }
          
          .tab-content.active {
            display: block;
          }
          
          /* Cartes */
          .card {
            background-color: var(--white);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 25px;
            border-left: 5px solid var(--accent-blue);
          }
          
          .card h2 {
            color: var(--primary-blue);
            font-size: 1.8rem;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 12px;
          }
          
          /* Profil */
          .profile-info {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
          }
          
          .info-item {
            background-color: #f8fafc;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid var(--light-blue);
          }
          
          .info-label {
            font-weight: 600;
            color: var(--primary-blue);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
          }
          
          .info-value {
            font-size: 1.2rem;
            color: var(--text-dark);
          }
          
          /* Notifications */
          .notifications-count {
            background-color: var(--accent-blue);
            color: white;
            border-radius: 50%;
            width: 28px;
            height: 28px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            margin-left: 10px;
          }
          
          .notification-item {
            background-color: #fef3c7;
            border-left: 5px solid var(--warning);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            transition: transform 0.2s ease;
          }
          
          .notification-item:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
          }
          
          .notification-item.unread {
            background-color: #f0f9ff;
            border-left-color: var(--accent-blue);
          }
          
          .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
          }
          
          .notification-module {
            font-weight: 700;
            color: var(--primary-blue);
            font-size: 1.1rem;
          }
          
          .notification-date {
            color: var(--text-light);
            font-size: 0.9rem;
          }
          
          .notification-message {
            color: var(--text-dark);
            margin: 10px 0;
            line-height: 1.5;
          }
          
          .notification-badges {
            display: flex;
            gap: 10px;
            margin-top: 10px;
          }
          
          .badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
          }
          
          .badge.important {
            background-color: var(--warning);
            color: var(--text-dark);
          }
          
          .badge.unread {
            background-color: var(--accent-blue);
            color: white;
          }
          
          /* Tableau des absences */
          .absences-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border-radius: 8px;
            overflow: hidden;
          }
          
          .absences-table th {
            background-color: var(--primary-blue);
            color: white;
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
          }
          
          .absences-table td {
            padding: 16px 15px;
            border-bottom: 1px solid #e2e8f0;
          }
          
          .absences-table tr:last-child td {
            border-bottom: none;
          }
          
          .absences-table tr:hover {
            background-color: #f8fafc;
          }
          
          /* Stats */
          .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
          }
          
          .stat-card {
            background-color: var(--white);
            border-radius: 10px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.07);
            transition: transform 0.3s ease;
          }
          
          .stat-card:hover {
            transform: translateY(-5px);
          }
          
          .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-blue);
            margin: 10px 0;
          }
          
          .stat-label {
            color: var(--text-light);
            font-size: 1rem;
            font-weight: 600;
          }
          
          /* Messages vides */
          .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-light);
          }
          
          .empty-state i {
            font-size: 4rem;
            color: #cbd5e1;
            margin-bottom: 20px;
          }
          
          .empty-state p {
            font-size: 1.2rem;
          }
          
          /* Footer */
          .footer {
            text-align: center;
            padding: 25px;
            color: var(--text-light);
            font-size: 0.9rem;
            border-top: 1px solid #e2e8f0;
            margin-top: 50px;
            background-color: var(--white);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
          }
          
          .footer-content {
            flex: 1;
          }
          
          .footer-lang {
            display: flex;
            gap: 10px;
          }
          
          /* Animations */
          @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
          }
          
          /* Responsive */
          @media (max-width: 768px) {
            .header-content {
              flex-direction: column;
              align-items: flex-start;
              gap: 20px;
            }
            
            .header-actions {
              flex-direction: column;
              width: 100%;
              gap: 10px;
            }
            
            .language-switcher {
              order: 1;
              width: 100%;
              justify-content: center;
            }
            
            .logout-btn {
              order: 2;
              width: 100%;
              justify-content: center;
            }
            
            .tabs {
              overflow-x: auto;
            }
            
            .tab-btn {
              padding: 15px 20px;
              white-space: nowrap;
            }
            
            .main-content {
              padding: 0 20px;
            }
            
            .profile-info {
              grid-template-columns: 1fr;
            }
            
            .stats-container {
              grid-template-columns: 1fr;
            }
            
            .footer {
              flex-direction: column;
              gap: 15px;
            }
            
            .footer-lang {
              justify-content: center;
            }
          }
        </style>
      </head>
      <body>
        <!-- Header avec Logout et traduction -->
        <div class="header">
          <div class="header-content">
            <div>
              <h1><i class="fas fa-user-graduate"></i> <span class="translatable" data-fr="Dashboard Étudiant" data-en="Student Dashboard">Dashboard Étudiant</span></h1>
              <p><span class="translatable" data-fr="Bienvenue," data-en="Welcome,">Bienvenue,</span> <strong><xsl:value-of select="dashboard/student/name"/></strong></p>
            </div>
            <div class="header-actions">
              <div class="language-switcher">
                <button class="lang-btn active" onclick="switchLanguage('fr')" title="Français">
                  <i class="fas fa-flag"></i> <span class="translatable" data-fr="FR" data-en="FR">FR</span>
                </button>
                <button class="lang-btn" onclick="switchLanguage('en')" title="English">
                  <i class="fas fa-flag-usa"></i> <span class="translatable" data-fr="EN" data-en="EN">EN</span>
                </button>
              </div>
              <button class="logout-btn" onclick="logout()" data-fr="Déconnexion" data-en="Logout">
                <i class="fas fa-sign-out-alt"></i> <span class="logout-text translatable" data-fr="Déconnexion" data-en="Logout">Déconnexion</span>
              </button>
            </div>
          </div>
        </div>
        
        <!-- Statistiques rapides -->
        <div class="main-content">
          <div class="stats-container">
            <div class="stat-card">
              <div class="stat-label"><i class="fas fa-user"></i> <span class="stat-label-text translatable" data-fr="Étudiant" data-en="Student">Étudiant</span></div>
              <div class="stat-number"><xsl:value-of select="dashboard/student/class"/></div>
            </div>
            
            <div class="stat-card">
              <div class="stat-label"><i class="fas fa-calendar-times"></i> <span class="stat-label-text translatable" data-fr="Absences" data-en="Absences">Absences</span></div>
              <div class="stat-number"><xsl:value-of select="dashboard/statistics/absences"/></div>
            </div>
            
            <div class="stat-card">
              <div class="stat-label"><i class="fas fa-bell"></i> <span class="stat-label-text translatable" data-fr="Notifications" data-en="Notifications">Notifications</span></div>
              <div class="stat-number"><xsl:value-of select="dashboard/statistics/notifications"/></div>
            </div>
          </div>
        </div>
        
        <!-- Onglets -->
        <div class="tabs-container">
          <div class="tabs">
            <button class="tab-btn active" onclick="showTab('profile')">
              <i class="fas fa-user-circle"></i> <span class="tab-text translatable" data-fr="Profil" data-en="Profile">Profil</span>
            </button>
            <button class="tab-btn" onclick="showTab('notifications')">
              <i class="fas fa-bell"></i> <span class="tab-text translatable" data-fr="Notifications" data-en="Notifications">Notifications</span>
              <xsl:if test="dashboard/statistics/unread_notifications > 0">
                <span class="notifications-count"><xsl:value-of select="dashboard/statistics/unread_notifications"/></span>
              </xsl:if>
            </button>
            <button class="tab-btn" onclick="showTab('absences')">
              <i class="fas fa-clipboard-list"></i> <span class="tab-text translatable" data-fr="Absences" data-en="Absences">Absences</span>
            </button>
          </div>
        </div>
        
        <!-- Contenu des onglets -->
        <div class="main-content">
          <!-- Onglet Profil -->
          <div id="profile" class="tab-content active">
            <div class="card">
              <h2><i class="fas fa-id-card"></i> <span class="card-title translatable" data-fr="Informations personnelles" data-en="Personal Information">Informations personnelles</span></h2>
              <div class="profile-info">
                <div class="info-item">
                  <div class="info-label"><i class="fas fa-user"></i> <span class="info-label-text translatable" data-fr="Nom complet" data-en="Full Name">Nom complet</span></div>
                  <div class="info-value"><xsl:value-of select="dashboard/student/name"/></div>
                </div>
                
                <div class="info-item">
                  <div class="info-label"><i class="fas fa-envelope"></i> <span class="info-label-text translatable" data-fr="Adresse email" data-en="Email Address">Adresse email</span></div>
                  <div class="info-value"><xsl:value-of select="dashboard/student/email"/></div>
                </div>
                
                <div class="info-item">
                  <div class="info-label"><i class="fas fa-users"></i> <span class="info-label-text translatable" data-fr="Classe" data-en="Class">Classe</span></div>
                  <div class="info-value"><xsl:value-of select="dashboard/student/class"/></div>
                </div>
                
                <div class="info-item">
                  <div class="info-label"><i class="fas fa-book"></i> <span class="info-label-text translatable" data-fr="Module" data-en="Module">Module</span></div>
                  <div class="info-value"><xsl:value-of select="dashboard/student/module"/></div>
                </div>
                
                <div class="info-item">
                  <div class="info-label"><i class="fas fa-id-badge"></i> <span class="info-label-text translatable" data-fr="Identifiant" data-en="ID">Identifiant</span></div>
                  <div class="info-value"><xsl:value-of select="dashboard/student/id"/></div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Onglet Notifications -->
          <div id="notifications" class="tab-content">
            <div class="card">
              <h2><i class="fas fa-bell"></i> <span class="card-title translatable" data-fr="Mes notifications" data-en="My Notifications">Mes notifications</span></h2>
              
              <xsl:choose>
                <xsl:when test="dashboard/statistics/notifications > 0">
                  <xsl:for-each select="dashboard/notifications/notification">
                    <div class="notification-item">
                      <xsl:if test="read = 'false'">
                        <xsl:attribute name="class">notification-item unread</xsl:attribute>
                      </xsl:if>
                      
                      <div class="notification-header">
                        <div class="notification-module">
                          <i class="fas fa-book"></i> <xsl:value-of select="seance_module"/>
                        </div>
                        <div class="notification-date">
                          <i class="far fa-clock"></i> <xsl:value-of select="created_at"/>
                        </div>
                      </div>
                      
                      <div class="notification-message">
                        <xsl:value-of select="message"/>
                      </div>
                    </div>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <div class="empty-state">
                    <i class="far fa-bell-slash"></i>
                    <p class="translatable" data-fr="Aucune notification pour le moment" data-en="No notifications at the moment">Aucune notification pour le moment</p>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
          
          <!-- Onglet Absences -->
          <div id="absences" class="tab-content">
            <div class="card">
              <h2><i class="fas fa-calendar-times"></i> <span class="card-title translatable" data-fr="Historique des absences" data-en="Absence History">Historique des absences</span></h2>
              
              <xsl:choose>
                <xsl:when test="dashboard/statistics/absences > 0">
                  <table class="absences-table">
                    <thead>
                      <tr>
                        <th><i class="far fa-calendar"></i> <span class="th-text translatable" data-fr="Date" data-en="Date">Date</span></th>
                        <th><i class="far fa-clock"></i> <span class="th-text translatable" data-fr="Heure" data-en="Time">Heure</span></th>
                        <th><i class="fas fa-book"></i> <span class="th-text translatable" data-fr="Module" data-en="Module">Module</span></th>
                      </tr>
                    </thead>
                    <tbody>
                      <xsl:for-each select="dashboard/absences/absence">
                        <tr>
                          <td><xsl:value-of select="date"/></td>
                          <td><xsl:value-of select="hours"/></td>
                          <td><strong><xsl:value-of select="module"/></strong></td>
                        </tr>
                      </xsl:for-each>
                    </tbody>
                  </table>
                </xsl:when>
                <xsl:otherwise>
                  <div class="empty-state">
                    <i class="far fa-check-circle" style="color: var(--success);"></i>
                    <p class="translatable" data-fr="Félicitations ! Aucune absence enregistrée" data-en="Congratulations! No absences recorded">Félicitations ! Aucune absence enregistrée</p>
                    <p style="font-size: 1rem; margin-top: 10px;" class="translatable" data-fr="Continuez votre assiduité" data-en="Keep up your attendance">Continuez votre assiduité</p>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
        </div>
        
        <!-- Footer -->
        <div class="footer">
          <div class="footer-content">
            <p><span class="translatable" data-fr="Système de Gestion des Absences" data-en="Absence Management System">Système de Gestion des Absences</span> - <xsl:value-of select="dashboard/student/class"/> - © 2024</p>
            <p><span class="translatable" data-fr="Dernière mise à jour :" data-en="Last updated:">Dernière mise à jour :</span> <span id="last-update"><xsl:value-of select="dashboard/student/last_update"/></span></p>
          </div>
          <div class="footer-lang">
            <button class="lang-btn" onclick="switchLanguage('fr')" title="Français">
              <i class="fas fa-flag"></i> <span class="translatable" data-fr="FR" data-en="FR">FR</span>
            </button>
            <button class="lang-btn" onclick="switchLanguage('en')" title="English">
              <i class="fas fa-flag-usa"></i> <span class="translatable" data-fr="EN" data-en="EN">EN</span>
            </button>
          </div>
        </div>
        
        <script>
  // Fonction pour changer de langue
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
    
    // Sauvegarder la préférence de langue
    localStorage.setItem('student-dashboard-lang', lang);
  }
  
  // Fonction pour changer d'onglet
  function showTab(tabId) {
    // Désactiver tous les onglets
    document.querySelectorAll('.tab-btn').forEach(btn => {
      btn.classList.remove('active');
    });
    document.querySelectorAll('.tab-content').forEach(content => {
      content.classList.remove('active');
    });
    
    // Activer l'onglet sélectionné
    document.querySelector(`[onclick="showTab('${tabId}')"]`).classList.add('active');
    document.getElementById(tabId).classList.add('active');
  }
  
  // Fonction de déconnexion
  function logout() {
    const lang = localStorage.getItem('student-dashboard-lang') || 'fr';
    const message = lang === 'en' ? 'Are you sure you want to logout?' : 'Êtes-vous sûr de vouloir vous déconnecter ?';
    
    if (confirm(message)) {
      window.location.href = '../logout.php';
    }
  }
  
  // Initialisation
  document.addEventListener('DOMContentLoaded', function() {
    // Récupérer la langue sauvegardée ou utiliser le français par défaut
    const savedLang = localStorage.getItem('student-dashboard-lang') || 'fr';
    if (savedLang !== 'fr') {
      switchLanguage(savedLang);
    }
    
    // Mettre à jour la date de dernière mise à jour
    const now = new Date();
    const dateStr = now.toLocaleDateString('fr-FR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
    
    const lastUpdateEl = document.getElementById('last-update');
    if (lastUpdateEl) {
      if (!lastUpdateEl.textContent || lastUpdateEl.textContent.trim() === '') {
        lastUpdateEl.textContent = dateStr;
      }
    }
  });
</script>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>