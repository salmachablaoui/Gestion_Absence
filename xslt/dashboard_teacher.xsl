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

  <xsl:template match="/">
    <html>
      <xsl:attribute name="lang">
        <xsl:value-of select="$lang"/>
      </xsl:attribute>
      <head>
        <meta charset="UTF-8"/>
        <title>
          <span class="translatable" data-fr="Tableau de Bord Enseignant" data-en="Teacher Dashboard">
            Tableau de Bord Enseignant
          </span>
        </title>
        <link rel="stylesheet" href="../../assets/css/style.css"/>
        <!-- Inclure Font Awesome pour les icônes -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
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
            margin-bottom: 30px;
            padding: 25px;
            background: linear-gradient(135deg, var(--primary-color), #283593);
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(26, 35, 126, 0.2);
            color: white;
          }
          
          .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
          }
          
          .header-content h1 {
            margin: 0;
            font-size: 28px;
            color: white;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
          }
          
          .header-content h1 i {
            font-size: 24px;
          }
          
          .header-content > div > p {
            margin: 8px 0 0 0;
            color: rgba(255, 255, 255, 0.9);
            font-size: 16px;
          }
          
          .header-actions {
            display: flex;
            align-items: center;
            gap: 20px;
          }
          
          .language-switcher {
            display: flex;
            gap: 10px;
          }
          
          .lang-btn {
            padding: 8px 16px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
            color: white;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            gap: 6px;
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
          
          .logout-btn {
            padding: 10px 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
            color: white;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            gap: 8px;
          }
          
          .logout-btn:hover {
            border-color: var(--accent-color);
            background: rgba(231, 76, 60, 0.2);
            transform: translateY(-2px);
          }
          
          /* Le reste du CSS reste le même... */
          
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
              padding: 20px;
            }
            
            .header-content {
              flex-direction: column;
              gap: 20px;
              align-items: flex-start;
            }
            
            .header-actions {
              width: 100%;
              justify-content: space-between;
            }
            
            .main-actions {
              flex-direction: column;
              gap: 20px;
              align-items: stretch;
            }
            
            .action-buttons {
              flex-direction: column;
            }
            
            table {
              display: block;
              overflow-x: auto;
            }
          }
        </style>
      </head>
      <body>
        <div class="container">
          <!-- En-tête avec informations enseignant -->
          <div class="header">
            <div class="header-content">
              <div>
                <h1><i class="fas fa-chalkboard-teacher"></i> 
                  <span class="translatable" data-fr="Tableau de Bord Enseignant" data-en="Teacher Dashboard">
                    Tableau de Bord Enseignant
                  </span>
                </h1>
                <p>
                  <span class="translatable" data-fr="Bienvenue," data-en="Welcome,">
                    Bienvenue,
                  </span> 
                  <strong>
                    <xsl:choose>
                      <xsl:when test="$teacherName != ''">
                        <xsl:value-of select="$teacherName"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <span class="translatable" data-fr="Enseignant" data-en="Teacher">
                          Enseignant
                        </span>
                      </xsl:otherwise>
                    </xsl:choose>
                  </strong>
                </p>
              </div>
              <div class="header-actions">
                <div class="language-switcher">
                  <button class="lang-btn" onclick="switchLanguage('fr')" title="Français">
                    <xsl:if test="$lang = 'fr'">
                      <xsl:attribute name="class">lang-btn active</xsl:attribute>
                    </xsl:if>
                    <i class="fas fa-flag"></i> 
                    <span class="translatable" data-fr="FR" data-en="FR">FR</span>
                  </button>
                  <button class="lang-btn" onclick="switchLanguage('en')" title="English">
                    <xsl:if test="$lang = 'en'">
                      <xsl:attribute name="class">lang-btn active</xsl:attribute>
                    </xsl:if>
                    <i class="fas fa-flag-usa"></i> 
                    <span class="translatable" data-fr="EN" data-en="EN">EN</span>
                  </button>
                </div>
                <button class="logout-btn" onclick="logout()">
                  <i class="fas fa-sign-out-alt"></i> 
                  <span class="logout-text translatable" data-fr="Déconnexion" data-en="Logout">
                    Déconnexion
                  </span>
                </button>
              </div>
            </div>
          </div>

          <!-- Actions principales -->
          <div class="main-actions">
            <div class="action-buttons">
              <button id="openAddSeance" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i>
                <span class="translatable" data-fr="Créer une séance" data-en="Create Session">
                  Créer une séance
                </span>
              </button>
              
            </div>
          </div>

          <!-- Section des séances -->
          <div class="sessions-section">
            <div class="section-header">
              <h2>
                <i class="fas fa-calendar-alt"></i>
                <span class="translatable" data-fr="Séances" data-en="Sessions">
                  Séances
                </span>
              </h2>
            </div>
            
            <!-- Message d'avertissement si aucune séance -->
            <xsl:if test="count($seances/seance[teacher_id = $teacherId]) = 0">
              <div class="warning-message">
                <p>
                  <i class="fas fa-exclamation-triangle"></i>
                  <span class="translatable" data-fr="⚠️ Aucune séance trouvée pour votre compte.&lt;br/&gt;&lt;small&gt;Créez votre première séance en cliquant sur le bouton &quot;➕ Créer une séance&quot;.&lt;/small&gt;" 
                        data-en="⚠️ No sessions found for your account.&lt;br/&gt;&lt;small&gt;Create your first session by clicking the &quot;➕ Create Session&quot; button.&lt;/small&gt;">
                    <xsl:text disable-output-escaping="yes">
                      &lt;span&gt;⚠️ Aucune séance trouvée pour votre compte.&lt;br/&gt;&lt;small&gt;Créez votre première séance en cliquant sur le bouton "➕ Créer une séance".&lt;/small&gt;&lt;/span&gt;
                    </xsl:text>
                  </span>
                </p>
              </div>
            </xsl:if>
            
            <table>
              <thead>
                <tr>
                  <th>
                    <span class="translatable" data-fr="ID" data-en="ID">ID</span>
                  </th>
                  <th>
                    <span class="translatable" data-fr="Classe" data-en="Class">Classe</span>
                  </th>
                  <th>
                    <span class="translatable" data-fr="Module" data-en="Module">Module</span>
                  </th>
                  <th>
                    <span class="translatable" data-fr="Date &amp; Heure" data-en="Date &amp; Time">
                      Date &amp; Heure
                    </span>
                  </th>
                  <th>
                    <span class="translatable" data-fr="Actions" data-en="Actions">Actions</span>
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
                                <span class="translatable" data-fr="Classe ID:" data-en="Class ID:">
                                  Classe ID:
                                </span>
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
                                <span class="translatable" data-fr="Date non spécifiée" data-en="Date not specified">
                                  Date non spécifiée
                                </span>
                              </span>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <button class="btn btn-primary manageAbsenceBtn" data-seance-id="{$currentSeanceId}">
                            <i class="fas fa-clipboard-list"></i>
                            <span class="translatable" data-fr="Gérer les absences" data-en="Manage Attendance">
                              Gérer les absences
                            </span>
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
                                      <span class="translatable" data-fr="Nom" data-en="Name">Nom</span>
                                    </th>
                                    <th>
                                      <span class="translatable" data-fr="Email" data-en="Email">Email</span>
                                    </th>
                                    <th>
                                      <span class="translatable" data-fr="Absent" data-en="Absent">Absent</span>
                                    </th>
                                    <th>
                                      <span class="translatable" data-fr="Statut" data-en="Status">Statut</span>
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
                                              <span class="translatable" data-fr="Absent" data-en="Absent">
                                                Absent
                                              </span>
                                            </label>
                                          </td>
                                          <td>
                                            <xsl:choose>
                                              <xsl:when test="$isAbsent = '1'">
                                                <span class="status-badge status-absent">
                                                  <i class="fas fa-times"></i>
                                                  <span class="translatable" data-fr="Absent" data-en="Absent">
                                                    Absent
                                                  </span>
                                                </span>
                                              </xsl:when>
                                              <xsl:otherwise>
                                                <span class="status-badge status-present">
                                                  <i class="fas fa-check"></i>
                                                  <span class="translatable" data-fr="Présent" data-en="Present">
                                                    Présent
                                                  </span>
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
                                            <span class="translatable" data-fr="Aucun étudiant dans cette classe" 
                                                  data-en="No students in this class">
                                              Aucun étudiant dans cette classe
                                            </span>
                                          </em>
                                        </td>
                                      </tr>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </tbody>
                              </table>
                              <div class="form-buttons">
                                <button type="submit" class="btn btn-primary">
                                  <i class="fas fa-save"></i>
                                  <span class="translatable" data-fr="Enregistrer les absences" data-en="Save Attendance">
                                    Enregistrer les absences
                                  </span>
                                </button>
                                <button type="button" class="btn btn-danger cancel-absence-btn" data-seance-id="{$currentSeanceId}">
                                  <i class="fas fa-times"></i>
                                  <span class="translatable" data-fr="Annuler" data-en="Cancel">
                                    Annuler
                                  </span>
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
                          <span class="translatable" data-fr="Aucune séance créée pour le moment" 
                                data-en="No sessions created yet">
                            Aucune séance créée pour le moment
                          </span>
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
                <i class="fas fa-plus-circle"></i>
                <span class="translatable" data-fr="Créer une séance" data-en="Create Session">
                  Créer une séance
                </span>
              </h2>
              
              <form method="post" action="create_seance.php" id="createSeanceForm">
                <input type="hidden" name="teacher_id" value="{$teacherId}"/>
                <input type="hidden" name="lang" value="{$lang}"/>
                
                <div class="form-group">
                  <label>
                    <span class="translatable" data-fr="Sélectionnez une classe" data-en="Select a class">
                      Sélectionnez une classe
                    </span>
                    :
                  </label>
                  <select name="class_id" id="classSelect" required="required">
                    <option value="">
                      <span class="translatable" data-fr="-- Choisir une classe --" data-en="-- Choose a class --">
                        -- Choisir une classe --
                      </span>
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
                    <span class="translatable" data-fr="Sélectionnez un module" data-en="Select a module">
                      Sélectionnez un module
                    </span>
                    :
                  </label>
                  <select name="module" id="moduleSelect" required="required" disabled="disabled">
                    <option value="">
                      <span class="translatable" data-fr="-- Sélectionnez d'abord une classe --" 
                            data-en="-- Select a class first --">
                        -- Sélectionnez d'abord une classe --
                      </span>
                    </option>
                  </select>
                  <small id="moduleHelp" style="display: block; margin-top: 8px; color: var(--light-text); font-size: 13px;"></small>
                </div>
                
                <div class="form-group">
                  <label>
                    <span class="translatable" data-fr="Date &amp; Heure" data-en="Date &amp; Time">
                      Date &amp; Heure
                    </span>
                    :
                  </label>
                  <input type="datetime-local" name="datetime" required="required"/>
                </div>

                <div class="form-buttons">
                  <button type="submit" class="btn btn-primary" id="submitBtn">
                    <i class="fas fa-plus"></i>
                    <span class="translatable" data-fr="Créer" data-en="Create">
                      Créer
                    </span>
                  </button>
                  <button type="button" class="btn btn-danger" id="cancelAddSeance">
                    <i class="fas fa-times"></i>
                    <span class="translatable" data-fr="Annuler" data-en="Cancel">
                      Annuler
                    </span>
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
        
        // Fonction pour basculer la langue
        function switchLanguage(lang) {
          // Mettre à jour l'attribut lang de la page
          document.documentElement.setAttribute('lang', lang);
          
          // Mettre à jour les boutons de langue
          document.querySelectorAll('.lang-btn').forEach(btn => {
            btn.classList.remove('active');
            if ((lang === 'fr' && btn.querySelector('i.fa-flag')) || 
                (lang === 'en' && btn.querySelector('i.fa-flag-usa'))) {
              btn.classList.add('active');
            }
          });
          
          // Mettre à jour tous les éléments traduisibles
          document.querySelectorAll('.translatable').forEach(element => {
            const frenchText = element.getAttribute('data-fr');
            const englishText = element.getAttribute('data-en');
            
            if (lang === 'fr' && frenchText) {
              // Remplacer le HTML si nécessaire
              if (frenchText.includes('<')) {
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = frenchText;
                element.innerHTML = tempDiv.innerHTML;
              } else {
                element.textContent = frenchText;
              }
            } else if (lang === 'en' && englishText) {
              if (englishText.includes('<')) {
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = englishText;
                element.innerHTML = tempDiv.innerHTML;
              } else {
                element.textContent = englishText;
              }
            }
          });
          
          // Mettre à jour les boutons qui ont des attributs data-fr/data-en
          document.querySelectorAll('button[data-fr], button[data-en], a[data-fr], a[data-en]').forEach(btn => {
            const frenchText = btn.getAttribute('data-fr');
            const englishText = btn.getAttribute('data-en');
            
            if (lang === 'fr' && frenchText) {
              const span = btn.querySelector('.logout-text') || btn;
              if (span.querySelector) {
                const textSpan = span.querySelector('.translatable') || span;
                textSpan.textContent = frenchText;
              }
            } else if (lang === 'en' && englishText) {
              const span = btn.querySelector('.logout-text') || btn;
              if (span.querySelector) {
                const textSpan = span.querySelector('.translatable') || span;
                textSpan.textContent = englishText;
              }
            }
          });
          
          // Mettre à jour le paramètre de langue dans les formulaires
          document.querySelectorAll('input[name="lang"]').forEach(input => {
            input.value = lang;
          });
          
          // Sauvegarder la préférence de langue
          localStorage.setItem('preferredLanguage', lang);
          
          // Mettre à jour le texte du module help
          updateModuleHelpText(lang);
        }
        
        // Fonction pour mettre à jour le texte d'aide des modules
        function updateModuleHelpText(lang) {
          const moduleHelp = document.getElementById('moduleHelp');
          if (moduleHelp) {
            const classId = document.getElementById('classSelect').value;
            const modules = modulesData[classId] || [];
            
            if (modules.length > 0) {
              if (lang === 'fr') {
                moduleHelp.textContent = modules.length + ' module(s) disponible(s)';
              } else {
                moduleHelp.textContent = modules.length + ' module(s) available';
              }
            } else {
              if (lang === 'fr') {
                moduleHelp.textContent = 'Aucun module configuré pour cette classe';
              } else {
                moduleHelp.textContent = 'No modules configured for this class';
              }
            }
          }
        }
        
        // Fonction de déconnexion
        function logout() {
          if (confirm(getTranslation('confirm_logout'))) {
            window.location.href = '../../logout.php';
          }
        }
        
        // Fonction pour obtenir une traduction
        function getTranslation(key) {
          const translations = {
            fr: {
              confirm_logout: 'Êtes-vous sûr de vouloir vous déconnecter ?',
              select_class_first: '-- Sélectionnez d\'abord une classe --',
              choose_module: '-- Choisir un module --',
              no_modules: 'Aucun module disponible',
              modules_available: 'module(s) disponible(s)',
              no_modules_configured: 'Aucun module configuré pour cette classe',
              close: 'Fermer',
              manage_absences: 'Gérer les absences',
              confirm_absences: 'Êtes-vous sûr de vouloir enregistrer les absences ?',
              saving: 'Enregistrement...',
              fill_required: 'Veuillez remplir tous les champs obligatoires'
            },
            en: {
              confirm_logout: 'Are you sure you want to logout?',
              select_class_first: '-- Select a class first --',
              choose_module: '-- Choose a module --',
              no_modules: 'No modules available',
              modules_available: 'module(s) available',
              no_modules_configured: 'No modules configured for this class',
              close: 'Close',
              manage_absences: 'Manage Attendance',
              confirm_absences: 'Are you sure you want to save attendance?',
              saving: 'Saving...',
              fill_required: 'Please fill all required fields'
            }
          };
          
          const lang = document.documentElement.getAttribute('lang') || 'fr';
          return translations[lang]?.[key] || key;
        }
        
        document.addEventListener('DOMContentLoaded', function() {
          // Restaurer la langue préférée
          const preferredLanguage = localStorage.getItem('preferredLanguage') || 'fr';
          if (preferredLanguage !== document.documentElement.getAttribute('lang')) {
            switchLanguage(preferredLanguage);
          }
          
          // Sauvegarder le texte original des boutons de gestion d'absences
          document.querySelectorAll('.manageAbsenceBtn').forEach(btn => {
            btn.setAttribute('data-original-text', btn.querySelector('.translatable').textContent);
          });
          
          // Initialiser la modal comme cachée
          document.getElementById('addSeanceModal').style.display = 'none';
          
          // Gestion des absences
          document.querySelectorAll(".manageAbsenceBtn").forEach(btn => {
            btn.addEventListener("click", function() {
              const seanceId = this.getAttribute('data-seance-id');
              const row = document.getElementById("absenceTable_" + seanceId);
              if (row) {
                const isHidden = row.style.display === "none";
                row.style.display = isHidden ? "table-row" : "none";
                
                const closeText = getTranslation('close');
                const translatableSpan = this.querySelector('.translatable');
                const originalText = this.getAttribute('data-original-text') || translatableSpan.textContent;
                
                translatableSpan.textContent = isHidden ? closeText : originalText;
                
                // Fermer les autres tableaux d'absence ouverts
                if (isHidden) {
                  document.querySelectorAll(".absenceTableRow").forEach(otherRow => {
                    if (otherRow.id !== "absenceTable_" + seanceId) {
                      otherRow.style.display = "none";
                      const otherBtn = document.querySelector('[data-seance-id="' + otherRow.id.replace('absenceTable_', '') + '"]');
                      if (otherBtn) {
                        const otherTranslatable = otherBtn.querySelector('.translatable');
                        const otherOriginalText = otherBtn.getAttribute('data-original-text') || otherTranslatable.textContent;
                        otherTranslatable.textContent = otherOriginalText;
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
                  const translatableSpan = manageBtn.querySelector('.translatable');
                  const originalText = manageBtn.getAttribute('data-original-text') || translatableSpan.textContent;
                  translatableSpan.textContent = originalText;
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
              moduleSelect.innerHTML = '<option value="">' + getTranslation('select_class_first') + '</option>';
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
              defaultOption.textContent = getTranslation('choose_module');
              moduleSelect.appendChild(defaultOption);
              
              // Ajouter chaque module
              modules.forEach(module => {
                const option = document.createElement('option');
                option.value = module;
                option.textContent = module;
                moduleSelect.appendChild(option);
              });
              
              // Afficher l'aide
              updateModuleHelpText(document.documentElement.getAttribute('lang') || 'fr');
              submitBtn.disabled = false;
            } else {
              const option = document.createElement('option');
              option.value = '';
              option.textContent = getTranslation('no_modules');
              moduleSelect.appendChild(option);
              moduleHelp.textContent = getTranslation('no_modules_configured');
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
              alert('❌ ' + getTranslation('fill_required'));
              return false;
            }
            
            return true;
          });
          
          // Gestion AJAX pour les absences
          document.querySelectorAll('form[id^="form_"]').forEach(form => {
            form.addEventListener('submit', function(e) {
              if (!confirm(getTranslation('confirm_absences'))) {
                e.preventDefault();
                return false;
              }
              
              // Afficher un indicateur de chargement
              const submitBtn = this.querySelector('button[type="submit"]');
              const originalText = submitBtn.querySelector('.translatable').textContent;
              submitBtn.querySelector('.translatable').textContent = getTranslation('saving');
              submitBtn.disabled = true;
              
              // Réactiver le bouton après 3 secondes (au cas où)
              setTimeout(() => {
                submitBtn.querySelector('.translatable').textContent = originalText;
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
              const statusSpan = statusCell.querySelector('.translatable');
              
              if (this.checked) {
                row.classList.add('absent-checked');
                if (statusSpan) {
                  statusSpan.textContent = getTranslation('absent');
                }
              } else {
                row.classList.remove('absent-checked');
                if (statusSpan) {
                  statusSpan.textContent = getTranslation('present');
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