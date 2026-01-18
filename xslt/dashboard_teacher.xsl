<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Paramètres -->
  <xsl:param name="teacherId"/>
  <xsl:param name="teacherName"/>
  <xsl:param name="studentsXmlPath"/>
  <xsl:param name="classesXmlPath"/>
  <xsl:param name="absencesXmlPath"/>
  <xsl:param name="seancesXmlPath"/>
  <xsl:param name="lang" select="'fr'"/>

  <!-- Charger les fichiers XML externes -->
  <xsl:variable name="students" select="document($studentsXmlPath)/students"/>
  <xsl:variable name="classes" select="document($classesXmlPath)/classes"/>
  <xsl:variable name="absences" select="document($absencesXmlPath)/absences"/>
  <xsl:variable name="seances" select="document($seancesXmlPath)/seances"/>

  <!-- Fonction de traduction simplifiée -->
  <xsl:template name="translate">
    <xsl:param name="key"/>
    <xsl:choose>
      <xsl:when test="$lang = 'fr'">
        <xsl:choose>
          <xsl:when test="$key = 'title'">Tableau de Bord Enseignant</xsl:when>
          <xsl:when test="$key = 'welcome'">Bienvenue</xsl:when>
          <xsl:when test="$key = 'create_session'">➕ Créer une séance</xsl:when>
          <xsl:when test="$key = 'logout'">🔒 Déconnexion</xsl:when>
          <xsl:when test="$key = 'sessions'">📅 Séances</xsl:when>
          <xsl:when test="$key = 'no_sessions_warning'">⚠️ Aucune séance trouvée pour votre compte.<br/><small>Créez votre première séance en cliquant sur le bouton "➕ Créer une séance".</small></xsl:when>
          <xsl:when test="$key = 'id'">ID</xsl:when>
          <xsl:when test="$key = 'class'">Classe</xsl:when>
          <xsl:when test="$key = 'module'">Module</xsl:when>
          <xsl:when test="$key = 'datetime'">Date &amp; Heure</xsl:when>
          <xsl:when test="$key = 'actions'">Actions</xsl:when>
          <xsl:when test="$key = 'manage_absences'">📋 Gérer les absences</xsl:when>
          <xsl:when test="$key = 'close'">Fermer</xsl:when>
          <xsl:when test="$key = 'name'">Nom</xsl:when>
          <xsl:when test="$key = 'email'">Email</xsl:when>
          <xsl:when test="$key = 'absent'">Absent</xsl:when>
          <xsl:when test="$key = 'status'">Statut</xsl:when>
          <xsl:when test="$key = 'absent_label'">❌ Absent</xsl:when>
          <xsl:when test="$key = 'present_label'">✅ Présent</xsl:when>
          <xsl:when test="$key = 'no_students'">Aucun étudiant dans cette classe</xsl:when>
          <xsl:when test="$key = 'no_sessions'">Aucune séance créée pour le moment</xsl:when>
          <xsl:when test="$key = 'save_absences'">💾 Enregistrer les absences</xsl:when>
          <xsl:when test="$key = 'cancel'">Annuler</xsl:when>
          <xsl:when test="$key = 'create_session_title'">➕ Créer une séance</xsl:when>
          <xsl:when test="$key = 'select_class'">Sélectionnez une classe</xsl:when>
          <xsl:when test="$key = 'select_module'">Sélectionnez un module</xsl:when>
          <xsl:when test="$key = 'datetime_label'">Date &amp; Heure</xsl:when>
          <xsl:when test="$key = 'create'">Créer</xsl:when>
          <xsl:when test="$key = 'select_class_first'">-- Sélectionnez d'abord une classe --</xsl:when>
          <xsl:when test="$key = 'choose_class'">-- Choisir une classe --</xsl:when>
          <xsl:when test="$key = 'choose_module'">-- Choisir un module --</xsl:when>
          <xsl:when test="$key = 'no_modules'">Aucun module disponible</xsl:when>
          <xsl:when test="$key = 'modules_available'">module(s) disponible(s)</xsl:when>
          <xsl:when test="$key = 'no_modules_configured'">Aucun module configuré pour cette classe</xsl:when>
          <xsl:when test="$key = 'class_not_found'">Classe ID:</xsl:when>
          <xsl:when test="$key = 'date_not_specified'">Date non spécifiée</xsl:when>
          <xsl:when test="$key = 'confirm_absences'">Êtes-vous sûr de vouloir enregistrer les absences ?</xsl:when>
          <xsl:when test="$key = 'saving'">⏳ Enregistrement...</xsl:when>
          <xsl:when test="$key = 'fill_required'">Veuillez remplir tous les champs obligatoires</xsl:when>
          <xsl:otherwise><xsl:value-of select="$key"/></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$lang = 'en'">
        <xsl:choose>
          <xsl:when test="$key = 'title'">Teacher Dashboard</xsl:when>
          <xsl:when test="$key = 'welcome'">Welcome</xsl:when>
          <xsl:when test="$key = 'create_session'">➕ Create Session</xsl:when>
          <xsl:when test="$key = 'logout'">🔒 Logout</xsl:when>
          <xsl:when test="$key = 'sessions'">📅 Sessions</xsl:when>
          <xsl:when test="$key = 'no_sessions_warning'">⚠️ No sessions found for your account.<br/><small>Create your first session by clicking the "➕ Create Session" button.</small></xsl:when>
          <xsl:when test="$key = 'id'">ID</xsl:when>
          <xsl:when test="$key = 'class'">Class</xsl:when>
          <xsl:when test="$key = 'module'">Module</xsl:when>
          <xsl:when test="$key = 'datetime'">Date &amp; Time</xsl:when>
          <xsl:when test="$key = 'actions'">Actions</xsl:when>
          <xsl:when test="$key = 'manage_absences'">📋 Manage Attendance</xsl:when>
          <xsl:when test="$key = 'close'">Close</xsl:when>
          <xsl:when test="$key = 'name'">Name</xsl:when>
          <xsl:when test="$key = 'email'">Email</xsl:when>
          <xsl:when test="$key = 'absent'">Absent</xsl:when>
          <xsl:when test="$key = 'status'">Status</xsl:when>
          <xsl:when test="$key = 'absent_label'">❌ Absent</xsl:when>
          <xsl:when test="$key = 'present_label'">✅ Present</xsl:when>
          <xsl:when test="$key = 'no_students'">No students in this class</xsl:when>
          <xsl:when test="$key = 'no_sessions'">No sessions created yet</xsl:when>
          <xsl:when test="$key = 'save_absences'">💾 Save Attendance</xsl:when>
          <xsl:when test="$key = 'cancel'">Cancel</xsl:when>
          <xsl:when test="$key = 'create_session_title'">➕ Create Session</xsl:when>
          <xsl:when test="$key = 'select_class'">Select a class</xsl:when>
          <xsl:when test="$key = 'select_module'">Select a module</xsl:when>
          <xsl:when test="$key = 'datetime_label'">Date &amp; Time</xsl:when>
          <xsl:when test="$key = 'create'">Create</xsl:when>
          <xsl:when test="$key = 'select_class_first'">-- Select a class first --</xsl:when>
          <xsl:when test="$key = 'choose_class'">-- Choose a class --</xsl:when>
          <xsl:when test="$key = 'choose_module'">-- Choose a module --</xsl:when>
          <xsl:when test="$key = 'no_modules'">No modules available</xsl:when>
          <xsl:when test="$key = 'modules_available'">module(s) available</xsl:when>
          <xsl:when test="$key = 'no_modules_configured'">No modules configured for this class</xsl:when>
          <xsl:when test="$key = 'class_not_found'">Class ID:</xsl:when>
          <xsl:when test="$key = 'date_not_specified'">Date not specified</xsl:when>
          <xsl:when test="$key = 'confirm_absences'">Are you sure you want to save attendance?</xsl:when>
          <xsl:when test="$key = 'saving'">⏳ Saving...</xsl:when>
          <xsl:when test="$key = 'fill_required'">Please fill all required fields</xsl:when>
          <xsl:otherwise><xsl:value-of select="$key"/></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$key = 'title'">Tableau de Bord Enseignant</xsl:when>
          <xsl:when test="$key = 'welcome'">Bienvenue</xsl:when>
          <xsl:when test="$key = 'create_session'">➕ Créer une séance</xsl:when>
          <xsl:when test="$key = 'logout'">🔒 Déconnexion</xsl:when>
          <xsl:when test="$key = 'sessions'">📅 Séances</xsl:when>
          <xsl:when test="$key = 'no_sessions_warning'">⚠️ Aucune séance trouvée pour votre compte.<br/><small>Créez votre première séance en cliquant sur le bouton "➕ Créer une séance".</small></xsl:when>
          <xsl:when test="$key = 'id'">ID</xsl:when>
          <xsl:when test="$key = 'class'">Classe</xsl:when>
          <xsl:when test="$key = 'module'">Module</xsl:when>
          <xsl:when test="$key = 'datetime'">Date &amp; Heure</xsl:when>
          <xsl:when test="$key = 'actions'">Actions</xsl:when>
          <xsl:when test="$key = 'manage_absences'">📋 Gérer les absences</xsl:when>
          <xsl:when test="$key = 'close'">Fermer</xsl:when>
          <xsl:when test="$key = 'name'">Nom</xsl:when>
          <xsl:when test="$key = 'email'">Email</xsl:when>
          <xsl:when test="$key = 'absent'">Absent</xsl:when>
          <xsl:when test="$key = 'status'">Statut</xsl:when>
          <xsl:when test="$key = 'absent_label'">❌ Absent</xsl:when>
          <xsl:when test="$key = 'present_label'">✅ Présent</xsl:when>
          <xsl:when test="$key = 'no_students'">Aucun étudiant dans cette classe</xsl:when>
          <xsl:when test="$key = 'no_sessions'">Aucune séance créée pour le moment</xsl:when>
          <xsl:when test="$key = 'save_absences'">💾 Enregistrer les absences</xsl:when>
          <xsl:when test="$key = 'cancel'">Annuler</xsl:when>
          <xsl:when test="$key = 'create_session_title'">➕ Créer une séance</xsl:when>
          <xsl:when test="$key = 'select_class'">Sélectionnez une classe</xsl:when>
          <xsl:when test="$key = 'select_module'">Sélectionnez un module</xsl:when>
          <xsl:when test="$key = 'datetime_label'">Date &amp; Heure</xsl:when>
          <xsl:when test="$key = 'create'">Créer</xsl:when>
          <xsl:when test="$key = 'select_class_first'">-- Sélectionnez d'abord une classe --</xsl:when>
          <xsl:when test="$key = 'choose_class'">-- Choisir une classe --</xsl:when>
          <xsl:when test="$key = 'choose_module'">-- Choisir un module --</xsl:when>
          <xsl:when test="$key = 'no_modules'">Aucun module disponible</xsl:when>
          <xsl:when test="$key = 'modules_available'">module(s) disponible(s)</xsl:when>
          <xsl:when test="$key = 'no_modules_configured'">Aucun module configuré pour cette classe</xsl:when>
          <xsl:when test="$key = 'class_not_found'">Classe ID:</xsl:when>
          <xsl:when test="$key = 'date_not_specified'">Date non spécifiée</xsl:when>
          <xsl:when test="$key = 'confirm_absences'">Êtes-vous sûr de vouloir enregistrer les absences ?</xsl:when>
          <xsl:when test="$key = 'saving'">⏳ Enregistrement...</xsl:when>
          <xsl:when test="$key = 'fill_required'">Veuillez remplir tous les champs obligatoires</xsl:when>
          <xsl:otherwise><xsl:value-of select="$key"/></xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/">
    <html>
      <xsl:attribute name="lang">
        <xsl:value-of select="$lang"/>
      </xsl:attribute>
      <head>
        <meta charset="UTF-8"/>
        <title>
          <xsl:call-template name="translate">
            <xsl:with-param name="key">title</xsl:with-param>
          </xsl:call-template>
        </title>
        <link rel="stylesheet" href="../../assets/css/style.css"/>
        <style>
          /* Variables CSS pour les thèmes - Bleu Marine */
          :root {
            --primary-color: #0e134a; /* Bleu marine */
            --secondary-color: #1e2767; /* Bleu marine plus clair */
            --accent-color: #e74c3c;
            --success-color: #27ae60;
            --warning-color: #f39c12;
            --light-bg: #f8f9fa;
            --dark-text: #0c103a; /* Bleu marine pour texte */
            --light-text: #4c5aa9; /* Bleu marine clair */
            --border-color: #c5cae9; /* Bleu marine très clair */
            --shadow: 0 2px 10px rgba(26, 35, 126, 0.1);
            --transition: all 0.3s ease;
          }
          
          body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e3f2fd 100%);
            color: var(--dark-text);
            margin: 0;
            padding: 0;
            min-height: 100vh;
          }
          
          .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px;
          }
          
          /* En-tête */
          .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 25px;
            background: linear-gradient(135deg, var(--primary-color), #283593);
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(26, 35, 126, 0.2);
            color: white;
          }
          
          .teacher-info {
            display: flex;
            align-items: center;
            gap: 20px;
          }
          
          .teacher-avatar {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #ffffff, #e3f2fd);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            font-size: 28px;
            font-weight: bold;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            border: 3px solid white;
          }
          
          .teacher-details h1 {
            margin: 0;
            font-size: 28px;
            color: white;
            font-weight: 600;
          }
          
          .teacher-details .welcome {
            margin: 8px 0 0 0;
            color: rgba(255, 255, 255, 0.9);
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
          }
          
          .welcome-icon {
            font-size: 20px;
          }
          
          /* Boutons de langue */
          .language-switcher {
            display: flex;
            gap: 12px;
            margin-left: auto;
            margin-right: 20px;
          }
          
          .lang-btn {
            padding: 10px 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.1);
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
            color: white;
            backdrop-filter: blur(10px);
          }
          
          .lang-btn:hover {
            border-color: white;
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
          }
          
          .lang-btn.active {
            background: white;
            color: var(--primary-color);
            border-color: white;
            box-shadow: 0 2px 10px rgba(255, 255, 255, 0.3);
          }
          
          /* Actions principales */
          .main-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
          }
          
          .action-buttons {
            display: flex;
            gap: 15px;
          }
          
          .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            font-size: 15px;
          }
          
          .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            box-shadow: 0 4px 15px rgba(26, 35, 126, 0.3);
          }
          
          .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(26, 35, 126, 0.4);
          }
          
          .btn-danger {
            background: linear-gradient(135deg, var(--accent-color), #c0392b);
            color: white;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
          }
          
          .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(231, 76, 60, 0.4);
          }
          
          /* Tableau des séances */
          .sessions-section {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border: 1px solid var(--border-color);
          }
          
          .section-header {
            padding: 25px;
            background: linear-gradient(135deg, #f8f9fa, #e8eaf6);
            border-bottom: 2px solid var(--border-color);
          }
          
          .section-header h2 {
            margin: 0;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 20px;
            font-weight: 600;
          }
          
          table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
          }
          
          thead {
            background: linear-gradient(135deg, #e8eaf6, #d1d9ff);
          }
          
          th {
            padding: 18px;
            text-align: left;
            font-weight: 600;
            color: var(--primary-color);
            border-bottom: 3px solid var(--border-color);
            font-size: 15px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
          }
          
          td {
            padding: 18px;
            border-bottom: 1px solid var(--border-color);
            color: var(--dark-text);
            font-size: 15px;
          }
          
          tbody tr {
            transition: var(--transition);
          }
          
          tbody tr:hover {
            background-color: #f5f7ff;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(26, 35, 126, 0.1);
          }
          
          /* Badges */
          .class-badge {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
            box-shadow: 0 2px 8px rgba(26, 35, 126, 0.2);
          }
          
          .module-badge {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: var(--primary-color);
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
            border: 1px solid #bbdefb;
          }
          
          /* Modal */
          .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
          }
          
          .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 35px;
            border-radius: 20px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.2);
            animation: modalFadeIn 0.3s ease;
            border: 2px solid var(--border-color);
          }
          
          @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
          }
          
          .close {
            float: right;
            font-size: 28px;
            cursor: pointer;
            color: var(--light-text);
            transition: var(--transition);
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
          }
          
          .close:hover {
            color: var(--accent-color);
            background: #f5f5f5;
          }
          
          /* Formulaires */
          .form-group {
            margin: 25px 0;
          }
          
          label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: var(--primary-color);
            font-size: 15px;
          }
          
          select, input[type="datetime-local"] {
            width: 100%;
            padding: 14px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 15px;
            transition: var(--transition);
            color: var(--dark-text);
          }
          
          select:focus, input[type="datetime-local"]:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(26, 35, 126, 0.1);
          }
          
          .form-buttons {
            margin-top: 35px;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
          }
          
          /* Absences */
          .absence-table-container {
            background: linear-gradient(135deg, #f8f9fa, #e8eaf6);
            border-radius: 12px;
            padding: 25px;
            margin: 20px 0;
            border: 2px solid var(--border-color);
          }
          
          .absence-table-container table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
          }
          
          .absence-checkbox {
            width: 22px;
            height: 22px;
            cursor: pointer;
            accent-color: var(--primary-color);
          }
          
          .absent-checked {
            background-color: #fff3cd !important;
          }
          
          .status-badge {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
          }
          
          .status-present {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border: 1px solid #c3e6cb;
          }
          
          .status-absent {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border: 1px solid #f5c6cb;
          }
          
          /* Messages */
          .warning-message {
            background: #fff3cd;
            border-left: 5px solid var(--warning-color);
            padding: 25px;
            border-radius: 10px;
            margin: 25px;
          }
          
          .no-data {
            text-align: center;
            padding: 60px;
            color: var(--light-text);
          }
          
          .no-data i {
            font-size: 60px;
            margin-bottom: 20px;
            color: var(--border-color);
          }
          
          /* Responsive */
          @media (max-width: 768px) {
            .container {
              padding: 15px;
            }
            
            .header {
              flex-direction: column;
              gap: 20px;
              align-items: flex-start;
              padding: 20px;
            }
            
            .main-actions {
              flex-direction: column;
              gap: 20px;
              align-items: stretch;
            }
            
            .action-buttons {
              flex-direction: column;
            }
            
            .language-switcher {
              margin: 15px 0 0 0;
              width: 100%;
              justify-content: center;
            }
            
            table {
              display: block;
              overflow-x: auto;
            }
            
            .teacher-info {
              flex-direction: column;
              text-align: center;
              gap: 15px;
            }
            
            .teacher-avatar {
              width: 60px;
              height: 60px;
              font-size: 24px;
            }
          }
        </style>
      </head>
      <body>
        <div class="container">
          <!-- En-tête avec informations enseignant -->
          <div class="header">
            <div class="teacher-info">
              <div class="teacher-avatar">
                <xsl:choose>
                  <xsl:when test="$teacherName != ''">
                    <xsl:value-of select="substring($teacherName, 1, 1)"/>
                  </xsl:when>
                  <xsl:otherwise>E</xsl:otherwise>
                </xsl:choose>
              </div>
              <div class="teacher-details">
                <h1>
                  <xsl:choose>
                    <xsl:when test="$teacherName != ''">
                      <xsl:value-of select="$teacherName"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="translate">
                        <xsl:with-param name="key">welcome</xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </h1>
                <p class="welcome">
                  <span class="welcome-icon">👋</span>
                  <xsl:call-template name="translate">
                    <xsl:with-param name="key">welcome</xsl:with-param>
                  </xsl:call-template>
                  <xsl:text>, </xsl:text>
                  <xsl:choose>
                    <xsl:when test="$teacherName != ''">
                      <strong><xsl:value-of select="$teacherName"/></strong>
                    </xsl:when>
                    <xsl:otherwise>
                      <strong>Enseignant</strong>
                    </xsl:otherwise>
                  </xsl:choose>
                </p>
              </div>
            </div>
            
            <!-- Boutons de langue -->
            <div class="language-switcher">
              <button class="lang-btn" data-lang="fr">
                <xsl:if test="$lang = 'fr'">
                  <xsl:attribute name="class">lang-btn active</xsl:attribute>
                </xsl:if>
                🇫🇷 FR
              </button>
              <button class="lang-btn" data-lang="en">
                <xsl:if test="$lang = 'en'">
                  <xsl:attribute name="class">lang-btn active</xsl:attribute>
                </xsl:if>
                🇬🇧 EN
              </button>
            </div>
          </div>

          <!-- Actions principales -->
          <div class="main-actions">
            <div class="action-buttons">
              <button id="openAddSeance" class="btn btn-primary">
                <xsl:call-template name="translate">
                  <xsl:with-param name="key">create_session</xsl:with-param>
                </xsl:call-template>
              </button>
              <a href="../../logout.php" class="btn btn-danger">
                <xsl:call-template name="translate">
                  <xsl:with-param name="key">logout</xsl:with-param>
                </xsl:call-template>
              </a>
            </div>
          </div>

          <!-- Section des séances -->
          <div class="sessions-section">
            <div class="section-header">
              <h2>
                <xsl:call-template name="translate">
                  <xsl:with-param name="key">sessions</xsl:with-param>
                </xsl:call-template>
              </h2>
            </div>
            
            <!-- Message d'avertissement si aucune séance -->
            <xsl:if test="count($seances/seance[teacher_id = $teacherId]) = 0">
              <div class="warning-message">
                <p>
                  <xsl:call-template name="translate">
                    <xsl:with-param name="key">no_sessions_warning</xsl:with-param>
                  </xsl:call-template>
                </p>
              </div>
            </xsl:if>
            
            <table>
              <thead>
                <tr>
                  <th>
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">id</xsl:with-param>
                    </xsl:call-template>
                  </th>
                  <th>
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">class</xsl:with-param>
                    </xsl:call-template>
                  </th>
                  <th>
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">module</xsl:with-param>
                    </xsl:call-template>
                  </th>
                  <th>
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">datetime</xsl:with-param>
                    </xsl:call-template>
                  </th>
                  <th>
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">actions</xsl:with-param>
                    </xsl:call-template>
                  </th>
                </tr>
              </thead>
              <tbody>
                <xsl:choose>
                  <xsl:when test="$seances/seance[teacher_id = $teacherId]">
                    <xsl:for-each select="$seances/seance[teacher_id = $teacherId]">
                      <xsl:sort select="datetime" order="descending"/>
                      
                      <xsl:variable name="currentSeanceId" select="@id"/>
                      
                      <tr>
                        <td><xsl:value-of select="@id"/></td>
                        <td>
                          <xsl:variable name="classId" select="class_id"/>
                          <xsl:choose>
                            <xsl:when test="$classes/class[@id=$classId]">
                              <span class="class-badge">
                                <xsl:value-of select="$classes/class[@id=$classId]/name"/>
                              </span>
                            </xsl:when>
                            <xsl:otherwise>
                              <span style="color: var(--accent-color);">
                                <xsl:call-template name="translate">
                                  <xsl:with-param name="key">class_not_found</xsl:with-param>
                                </xsl:call-template>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$classId"/>
                              </span>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <span class="module-badge">
                            <xsl:value-of select="module"/>
                          </span>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="datetime and datetime != ''">
                              <xsl:variable name="dateTime" select="datetime"/>
                              <xsl:variable name="formattedDate">
                                <xsl:choose>
                                  <xsl:when test="contains($dateTime, 'T')">
                                    <xsl:value-of select="substring($dateTime, 9, 2)"/>/<xsl:value-of select="substring($dateTime, 6, 2)"/>/<xsl:value-of select="substring($dateTime, 1, 4)"/>
                                    <xsl:text> à </xsl:text>
                                    <xsl:value-of select="substring($dateTime, 12, 5)"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="$dateTime"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:variable>
                              <xsl:value-of select="$formattedDate"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <span style="color: var(--accent-color);">
                                <xsl:call-template name="translate">
                                  <xsl:with-param name="key">date_not_specified</xsl:with-param>
                                </xsl:call-template>
                              </span>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <button class="btn btn-primary manageAbsenceBtn" data-seance-id="{$currentSeanceId}">
                            <xsl:call-template name="translate">
                              <xsl:with-param name="key">manage_absences</xsl:with-param>
                            </xsl:call-template>
                          </button>
                        </td>
                      </tr>
                      
                      <!-- Tableau des absences -->
                      <tr class="absenceTableRow" id="absenceTable_{$currentSeanceId}" style="display:none;">
                        <td colspan="5">
                          <div class="absence-table-container">
                            <form method="post" action="mark_absence.php" id="form_{$currentSeanceId}">
                              <input type="hidden" name="seance_id" value="{$currentSeanceId}"/>
                              <input type="hidden" name="class_id" value="{class_id}"/>
                              <input type="hidden" name="teacher_id" value="{$teacherId}"/>
                              <input type="hidden" name="lang" value="{$lang}"/>
                              
                              <table>
                                <thead>
                                  <tr>
                                    <th>
                                      <xsl:call-template name="translate">
                                        <xsl:with-param name="key">name</xsl:with-param>
                                      </xsl:call-template>
                                    </th>
                                    <th>
                                      <xsl:call-template name="translate">
                                        <xsl:with-param name="key">email</xsl:with-param>
                                      </xsl:call-template>
                                    </th>
                                    <th>
                                      <xsl:call-template name="translate">
                                        <xsl:with-param name="key">absent</xsl:with-param>
                                      </xsl:call-template>
                                    </th>
                                    <th>
                                      <xsl:call-template name="translate">
                                        <xsl:with-param name="key">status</xsl:with-param>
                                      </xsl:call-template>
                                    </th>
                                  </tr>
                                </thead>
                                <tbody>
                                  <xsl:variable name="classId" select="class_id"/>
                                  <xsl:variable name="classStudents" select="$students/student[class=$classId]"/>
                                  
                                  <xsl:choose>
                                    <xsl:when test="$classStudents">
                                      <xsl:for-each select="$classStudents">
                                        <xsl:sort select="name"/>
                                        <xsl:variable name="studentId" select="@id"/>
                                        <xsl:variable name="studentName" select="name"/>
                                        
                                        <xsl:variable name="isAbsent">
                                          <xsl:choose>
                                            <xsl:when test="$absences/absence[student_id=$studentId and seance_id=$currentSeanceId]">1</xsl:when>
                                            <xsl:when test="$absences/absence[studentId=$studentId and seanceId=$currentSeanceId]">1</xsl:when>
                                            <xsl:when test="$absences/absence[student=$studentName and seance=$currentSeanceId]">1</xsl:when>
                                            <xsl:otherwise>0</xsl:otherwise>
                                          </xsl:choose>
                                        </xsl:variable>
                                        
                                        <tr>
                                          <td><xsl:value-of select="$studentName"/></td>
                                          <td><xsl:value-of select="email"/></td>
                                          <td>
                                            <input type="checkbox" 
                                                   name="absent_students[]" 
                                                   value="{$studentId}"
                                                   class="absence-checkbox"
                                                   data-student-id="{$studentId}"
                                                   data-student-name="{$studentName}">
                                              <xsl:if test="$isAbsent = '1'">
                                                <xsl:attribute name="checked">checked</xsl:attribute>
                                              </xsl:if>
                                            </input>
                                            <label style="display: inline; margin-left: 8px;">
                                              <xsl:call-template name="translate">
                                                <xsl:with-param name="key">absent</xsl:with-param>
                                              </xsl:call-template>
                                            </label>
                                          </td>
                                          <td>
                                            <xsl:choose>
                                              <xsl:when test="$isAbsent = '1'">
                                                <span class="status-badge status-absent">
                                                  <xsl:call-template name="translate">
                                                    <xsl:with-param name="key">absent_label</xsl:with-param>
                                                  </xsl:call-template>
                                                </span>
                                              </xsl:when>
                                              <xsl:otherwise>
                                                <span class="status-badge status-present">
                                                  <xsl:call-template name="translate">
                                                    <xsl:with-param name="key">present_label</xsl:with-param>
                                                  </xsl:call-template>
                                                </span>
                                              </xsl:otherwise>
                                            </xsl:choose>
                                          </td>
                                        </tr>
                                      </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <tr>
                                        <td colspan="4" class="no-data">
                                          <em>
                                            <xsl:call-template name="translate">
                                              <xsl:with-param name="key">no_students</xsl:with-param>
                                            </xsl:call-template>
                                          </em>
                                        </td>
                                      </tr>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </tbody>
                              </table>
                              <div class="form-buttons">
                                <button type="submit" class="btn btn-primary">
                                  <xsl:call-template name="translate">
                                    <xsl:with-param name="key">save_absences</xsl:with-param>
                                  </xsl:call-template>
                                </button>
                                <button type="button" class="btn btn-danger cancel-absence-btn" data-seance-id="{$currentSeanceId}">
                                  <xsl:call-template name="translate">
                                    <xsl:with-param name="key">cancel</xsl:with-param>
                                  </xsl:call-template>
                                </button>
                              </div>
                            </form>
                          </div>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <tr>
                      <td colspan="5" class="no-data">
                        <em>
                          <xsl:call-template name="translate">
                            <xsl:with-param name="key">no_sessions</xsl:with-param>
                          </xsl:call-template>
                        </em>
                      </td>
                    </tr>
                  </xsl:otherwise>
                </xsl:choose>
              </tbody>
            </table>
          </div>

          <!-- Modal création séance -->
          <div class="modal" id="addSeanceModal">
            <div class="modal-content">
              <span class="close" id="closeAddSeance">✕</span>
              <h2>
                <xsl:call-template name="translate">
                  <xsl:with-param name="key">create_session_title</xsl:with-param>
                </xsl:call-template>
              </h2>
              
              <form method="post" action="create_seance.php" id="createSeanceForm">
                <input type="hidden" name="teacher_id" value="{$teacherId}"/>
                <input type="hidden" name="lang" value="{$lang}"/>
                
                <div class="form-group">
                  <label>
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">select_class</xsl:with-param>
                    </xsl:call-template>
                    :
                  </label>
                  <select name="class_id" id="classSelect" required="required">
                    <option value="">
                      <xsl:call-template name="translate">
                        <xsl:with-param name="key">choose_class</xsl:with-param>
                      </xsl:call-template>
                    </option>
                    <xsl:for-each select="$classes/class">
                      <xsl:sort select="name"/>
                      <option value="{@id}">
                        <xsl:value-of select="name"/>
                      </option>
                    </xsl:for-each>
                  </select>
                </div>
                
                <div class="form-group">
                  <label>
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">select_module</xsl:with-param>
                    </xsl:call-template>
                    :
                  </label>
                  <select name="module" id="moduleSelect" required="required" disabled="disabled">
                    <option value="">
                      <xsl:call-template name="translate">
                        <xsl:with-param name="key">select_class_first</xsl:with-param>
                      </xsl:call-template>
                    </option>
                  </select>
                  <small id="moduleHelp" style="display: block; margin-top: 8px; color: var(--light-text); font-size: 13px;"></small>
                </div>
                
                <div class="form-group">
                  <label>
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">datetime_label</xsl:with-param>
                    </xsl:call-template>
                    :
                  </label>
                  <input type="datetime-local" name="datetime" required="required"/>
                </div>

                <div class="form-buttons">
                  <button type="submit" class="btn btn-primary" id="submitBtn">
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">create</xsl:with-param>
                    </xsl:call-template>
                  </button>
                  <button type="button" class="btn btn-danger" id="cancelAddSeance">
                    <xsl:call-template name="translate">
                      <xsl:with-param name="key">cancel</xsl:with-param>
                    </xsl:call-template>
                  </button>
                </div>
              </form>
            </div>
          </div>
          
        </div>
        
        <script>
        <![CDATA[
        // Données des modules par classe
        const modulesData = {
          'GI1': ['Mathématiques', 'Algorithmique', 'Programmation Web', 'Réseaux', 'Base de données'],
          'GI2': ['Base de données', 'Java', 'Programmation Web', 'Systèmes', 'Réseaux'],
          'GI3': ['Intelligence Artificielle', 'Big Data', 'Sécurité', 'Cloud', 'Web Avancé'],
          'TM': ['Électronique', 'Automatisme', 'Robotique', 'Mécanique'],
          'TC': ['Chimie', 'Physique', 'Maths Appliquées', 'Thermodynamique']
        };
        
        // Traductions JavaScript synchronisées avec XSLT
        const translations = {
          fr: {
            select_class_first: '-- Sélectionnez d\'abord une classe --',
            choose_module: '-- Choisir un module --',
            no_modules: 'Aucun module disponible',
            modules_available: 'module(s) disponible(s)',
            no_modules_configured: 'Aucun module configuré pour cette classe',
            close: 'Fermer',
            manage_absences: '📋 Gérer les absences',
            confirm_absences: 'Êtes-vous sûr de vouloir enregistrer les absences ?',
            saving: '⏳ Enregistrement...',
            fill_required: 'Veuillez remplir tous les champs obligatoires',
            absent_label: '❌ Absent',
            present_label: '✅ Présent'
          },
          en: {
            select_class_first: '-- Select a class first --',
            choose_module: '-- Choose a module --',
            no_modules: 'No modules available',
            modules_available: 'module(s) available',
            no_modules_configured: 'No modules configured for this class',
            close: 'Close',
            manage_absences: '📋 Manage Attendance',
            confirm_absences: 'Are you sure you want to save attendance?',
            saving: '⏳ Saving...',
            fill_required: 'Please fill all required fields',
            absent_label: '❌ Absent',
            present_label: '✅ Present'
          }
        };
        
        // Fonction pour obtenir la langue actuelle
        function getCurrentLang() {
          return document.documentElement.getAttribute('lang') || 'fr';
        }
        
        // Fonction pour traduire en JavaScript
        function translate(key) {
          const lang = getCurrentLang();
          return translations[lang]?.[key] || key;
        }
        
        document.addEventListener('DOMContentLoaded', function() {
          // Sauvegarder le texte original des boutons
          document.querySelectorAll('.manageAbsenceBtn').forEach(btn => {
            btn.setAttribute('data-original-text', btn.textContent);
          });
          
          // Initialiser la modal comme cachée
          document.getElementById('addSeanceModal').style.display = 'none';
          
          // Gestion des boutons de langue
          document.querySelectorAll('.lang-btn').forEach(btn => {
            btn.addEventListener('click', function() {
              const lang = this.getAttribute('data-lang');
              // Rediriger avec le paramètre de langue
              const url = new URL(window.location.href);
              url.searchParams.set('lang', lang);
              window.location.href = url.toString();
            });
          });
          
          // Gestion des absences
          document.querySelectorAll(".manageAbsenceBtn").forEach(btn => {
            btn.addEventListener("click", function() {
              const seanceId = this.getAttribute('data-seance-id');
              const row = document.getElementById("absenceTable_" + seanceId);
              if (row) {
                const isHidden = row.style.display === "none";
                row.style.display = isHidden ? "table-row" : "none";
                
                const closeText = translate('close');
                const originalText = this.getAttribute('data-original-text') || this.textContent;
                
                this.textContent = isHidden ? closeText : originalText;
                
                // Fermer les autres tableaux d'absence ouverts
                if (isHidden) {
                  document.querySelectorAll(".absenceTableRow").forEach(otherRow => {
                    if (otherRow.id !== "absenceTable_" + seanceId) {
                      otherRow.style.display = "none";
                      const otherBtn = document.querySelector('[data-seance-id="' + otherRow.id.replace('absenceTable_', '') + '"]');
                      if (otherBtn) {
                        otherBtn.textContent = otherBtn.getAttribute('data-original-text') || otherBtn.textContent;
                      }
                    }
                  });
                }
              }
            });
          });
          
          // Gestion des boutons Annuler dans les formulaires d'absence
          document.querySelectorAll(".cancel-absence-btn").forEach(btn => {
            btn.addEventListener("click", function() {
              const seanceId = this.getAttribute('data-seance-id');
              const row = document.getElementById("absenceTable_" + seanceId);
              if (row) {
                row.style.display = "none";
                const manageBtn = document.querySelector('[data-seance-id="' + seanceId + '"]');
                if (manageBtn) {
                  manageBtn.textContent = manageBtn.getAttribute('data-original-text') || manageBtn.textContent;
                }
              }
            });
          });
          
          // Modal
          const modal = document.getElementById("addSeanceModal");
          
          document.getElementById("openAddSeance").onclick = function() {
            modal.style.display = "block";
            document.getElementById('createSeanceForm').reset();
            loadModules();
            
            // Mettre la date/heure actuelle par défaut
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            document.querySelector('input[name="datetime"]').value = now.toISOString().slice(0, 16);
          };
          
          document.getElementById("closeAddSeance").onclick = function() {
            modal.style.display = "none";
          };
          
          document.getElementById("cancelAddSeance").onclick = function() {
            modal.style.display = "none";
          };
          
          window.onclick = function(e) {
            if (e.target === modal) {
              modal.style.display = "none";
            }
          };
          
          // Fonction pour charger les modules
          function loadModules() {
            const classId = document.getElementById('classSelect').value;
            const moduleSelect = document.getElementById('moduleSelect');
            const moduleHelp = document.getElementById('moduleHelp');
            const submitBtn = document.getElementById('submitBtn');
            
            if (!classId) {
              moduleSelect.disabled = true;
              moduleSelect.innerHTML = '<option value="">' + translate('select_class_first') + '</option>';
              moduleHelp.textContent = '';
              submitBtn.disabled = true;
              return;
            }
            
            // Activer le select
            moduleSelect.disabled = false;
            moduleSelect.innerHTML = '';
            
            // Récupérer les modules pour cette classe
            const modules = modulesData[classId] || [];
            
            if (modules.length > 0) {
              // Ajouter l'option par défaut
              const defaultOption = document.createElement('option');
              defaultOption.value = '';
              defaultOption.textContent = translate('choose_module');
              moduleSelect.appendChild(defaultOption);
              
              // Ajouter chaque module
              modules.forEach(module => {
                const option = document.createElement('option');
                option.value = module;
                option.textContent = module;
                moduleSelect.appendChild(option);
              });
              
              // Afficher l'aide
              moduleHelp.textContent = modules.length + ' ' + translate('modules_available');
              moduleHelp.style.color = '#27ae60';
              submitBtn.disabled = false;
            } else {
              const option = document.createElement('option');
              option.value = '';
              option.textContent = translate('no_modules');
              moduleSelect.appendChild(option);
              moduleHelp.textContent = translate('no_modules_configured');
              moduleHelp.style.color = '#e74c3c';
              submitBtn.disabled = true;
            }
          }
          
          // Événement changement de classe
          document.getElementById('classSelect').addEventListener('change', loadModules);
          
          // Validation du formulaire création séance
          document.getElementById('createSeanceForm').addEventListener('submit', function(e) {
            const classId = document.getElementById('classSelect').value;
            const module = document.getElementById('moduleSelect').value;
            const datetime = document.querySelector('input[name="datetime"]').value;
            
            if (!classId || !module || !datetime) {
              e.preventDefault();
              alert('❌ ' + translate('fill_required'));
              return false;
            }
            
            return true;
          });
          
          // Gestion AJAX pour les absences
          document.querySelectorAll('form[id^="form_"]').forEach(form => {
            form.addEventListener('submit', function(e) {
              if (!confirm(translate('confirm_absences'))) {
                e.preventDefault();
                return false;
              }
              
              // Afficher un indicateur de chargement
              const submitBtn = this.querySelector('button[type="submit"]');
              const originalText = submitBtn.textContent;
              submitBtn.textContent = translate('saving');
              submitBtn.disabled = true;
              
              // Réactiver le bouton après 3 secondes (au cas où)
              setTimeout(() => {
                submitBtn.textContent = originalText;
                submitBtn.disabled = false;
              }, 3000);
            });
          });
          
          // Mettre en évidence les lignes des étudiants absents
          document.querySelectorAll('.absence-checkbox[checked]').forEach(checkbox => {
            const row = checkbox.closest('tr');
            if (row) {
              row.classList.add('absent-checked');
            }
          });
          
          // Mettre à jour le style quand une case est cochée/décochée
          document.querySelectorAll('.absence-checkbox').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
              const row = this.closest('tr');
              const statusCell = row.querySelector('td:nth-child(4)');
              
              if (this.checked) {
                row.classList.add('absent-checked');
                if (statusCell) {
                  statusCell.innerHTML = '<span class="status-badge status-absent">' + 
                    translate('absent_label') + 
                    '</span>';
                }
              } else {
                row.classList.remove('absent-checked');
                if (statusCell) {
                  statusCell.innerHTML = '<span class="status-badge status-present">' + 
                    translate('present_label') + 
                    '</span>';
                }
              }
            });
          });
        });
        ]]>
        </script>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>