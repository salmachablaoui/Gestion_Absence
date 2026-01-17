<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:param name="studentId"/>
  <xsl:param name="studentEmail"/>

  <xsl:template match="/">
    <html lang="fr">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Dashboard Étudiant</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <style>
          :root {
            --primary: #4361ee;
            --secondary: #3a0ca3;
            --success: #4cc9f0;
            --danger: #f72585;
            --warning: #f8961e;
            --light: #f8f9fa;
            --dark: #212529;
            --gray: #6c757d;
            --light-gray: #e9ecef;
            --border-radius: 12px;
            --box-shadow: 0 8px 30px rgba(0,0,0,0.08);
            --transition: all 0.3s ease;
          }
          
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }
          
          body { 
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; 
            background: linear-gradient(135deg, #f5f7fa 0%, #e4edf5 100%);
            color: var(--dark);
            min-height: 100vh;
            padding: 20px;
            line-height: 1.6;
          }
          
          .container { 
            max-width: 1400px; 
            margin: 0 auto;
          }
          
          /* Header */
          .header { 
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%); 
            color: white; 
            padding: 30px 40px; 
            border-radius: var(--border-radius); 
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--box-shadow);
          }
          
          .header-content h1 { 
            font-size: 2.2rem; 
            margin-bottom: 8px; 
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
          }
          
          .header-content p { 
            font-size: 1.1rem; 
            opacity: 0.9;
          }
          
          .btn { 
            padding: 14px 28px; 
            background: rgba(255,255,255,0.2); 
            color: white; 
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50px; 
            cursor: pointer; 
            text-decoration: none; 
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 1rem;
            transition: var(--transition);
          }
          
          .btn:hover { 
            background: rgba(255,255,255,0.3);
            border-color: rgba(255,255,255,0.5);
            transform: translateY(-2px);
          }
          
          /* Cards */
          .card { 
            background: white; 
            border-radius: var(--border-radius); 
            padding: 30px; 
            margin-bottom: 25px; 
            box-shadow: var(--box-shadow);
            transition: var(--transition);
          }
          
          .card:hover {
            transform: translateY(-5px);
          }
          
          .card-title {
            color: var(--dark);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 2px solid var(--light-gray);
          }
          
          /* Stats Grid */
          .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
            margin-top: 20px;
          }
          
          .stat-card {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 25px;
            border-radius: var(--border-radius);
            text-align: center;
            transition: var(--transition);
          }
          
          .stat-card:nth-child(2) {
            background: linear-gradient(135deg, var(--success) 0%, #4895ef 100%);
          }
          
          .stat-card:nth-child(3) {
            background: linear-gradient(135deg, var(--warning) 0%, #f3722c 100%);
          }
          
          .stat-card:hover {
            transform: translateY(-5px);
          }
          
          .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
          }
          
          .stat-number {
            font-size: 3rem;
            font-weight: 800;
            margin: 10px 0;
          }
          
          .stat-label {
            font-size: 0.95rem;
            opacity: 0.9;
          }
          
          /* Tabs */
          .tabs {
            display: flex;
            background: var(--light);
            border-radius: 50px;
            padding: 8px;
            margin-bottom: 30px;
          }
          
          .tab-btn {
            flex: 1;
            padding: 16px 24px;
            border: none;
            background: none;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            color: var(--gray);
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
          }
          
          .tab-btn:hover {
            color: var(--primary);
            background: rgba(67, 97, 238, 0.1);
          }
          
          .tab-btn.active {
            background: var(--primary);
            color: white;
          }
          
          /* Tab Content */
          .tab-content {
            display: none;
          }
          
          .tab-content.active {
            display: block;
            animation: fadeIn 0.5s ease;
          }
          
          @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
          }
          
          /* Info Grid */
          .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 20px;
          }
          
          .info-item {
            background: var(--light);
            padding: 22px;
            border-radius: var(--border-radius);
            border-left: 4px solid var(--primary);
            transition: var(--transition);
          }
          
          .info-item:hover {
            background: white;
            transform: translateX(8px);
          }
          
          .info-label {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 8px;
            font-weight: 500;
          }
          
          .info-value {
            color: var(--dark);
            font-weight: 700;
            font-size: 1.3rem;
          }
          
          .info-id {
            font-family: 'Courier New', monospace;
            background: var(--dark);
            color: var(--light);
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.9rem;
            display: inline-block;
            margin-top: 8px;
          }
          
          /* Notifications */
          .notification-item {
            background: linear-gradient(135deg, #fff9db 0%, #fff3bf 100%);
            border-left: 4px solid var(--warning);
            padding: 22px;
            margin: 15px 0;
            border-radius: var(--border-radius);
            transition: var(--transition);
            cursor: pointer;
          }
          
          .notification-item:hover {
            transform: translateX(10px);
            box-shadow: 0 8px 25px rgba(248, 150, 30, 0.15);
          }
          
          .notification-item.read {
            opacity: 0.7;
            background: var(--light);
            border-left-color: var(--gray);
          }
          
          .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
          }
          
          .notification-title {
            font-weight: 700;
            color: #856404;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.1rem;
          }
          
          .notification-date {
            color: var(--gray);
            font-size: 0.85rem;
            background: rgba(255,255,255,0.5);
            padding: 4px 10px;
            border-radius: 4px;
          }
          
          .notification-module {
            display: block;
            font-weight: 600;
            color: var(--primary);
            margin: 8px 0;
            font-size: 1.05rem;
            padding: 8px 16px;
            background: rgba(67, 97, 238, 0.1);
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
          }
          
          .notification-message {
            color: #856404;
            margin: 12px 0;
            line-height: 1.5;
            padding: 12px;
            background: rgba(255,255,255,0.5);
            border-radius: 8px;
            border-left: 3px solid var(--warning);
          }
          
          .notification-seance {
            font-family: 'Courier New', monospace;
            color: var(--gray);
            font-size: 0.85rem;
            margin-top: 8px;
            padding: 6px 12px;
            background: var(--light-gray);
            border-radius: 4px;
            display: inline-block;
          }
          
          .notification-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
          }
          
          .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 6px;
          }
          
          .mark-read-btn {
            background: var(--success);
            color: white;
          }
          
          .mark-read-btn:hover {
            background: #3aa8d0;
          }
          
          .delete-btn {
            background: var(--danger);
            color: white;
          }
          
          .delete-btn:hover {
            background: #d1145a;
          }
          
          /* Absences Table */
          .table-container {
            overflow-x: auto;
            border-radius: var(--border-radius);
            margin-top: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
          }
          
          table { 
            width: 100%; 
            border-collapse: collapse; 
            min-width: 600px;
          }
          
          th, td { 
            padding: 18px 20px; 
            text-align: left; 
            border-bottom: 1px solid var(--light-gray);
          }
          
          th { 
            background: linear-gradient(135deg, var(--light) 0%, #e9ecef 100%); 
            color: var(--dark);
            font-weight: 700;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
          }
          
          tr {
            transition: var(--transition);
          }
          
          tr:hover {
            background: rgba(67, 97, 238, 0.05);
          }
          
          .status-badge {
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
          }
          
          .status-absent {
            background: rgba(247, 37, 133, 0.1);
            color: var(--danger);
          }
          
          .status-present {
            background: rgba(76, 201, 240, 0.1);
            color: var(--success);
          }
          
          .module-cell {
            font-weight: 600;
            color: var(--primary);
            position: relative;
          }
          
          .module-cell::before {
            content: "📚";
            margin-right: 8px;
          }
          
          .date-cell {
            position: relative;
            font-weight: 500;
          }
          
          .date-cell::before {
            content: "📅";
            margin-right: 8px;
          }
          
          .time-cell::before {
            content: "🕒";
            margin-right: 8px;
          }
          
          /* No Data */
          .no-data {
            text-align: center;
            padding: 60px 20px;
            color: var(--gray);
          }
          
          .no-data-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.3;
          }
          
          .no-data h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: var(--dark);
          }
          
          /* Footer */
          .footer {
            text-align: center;
            margin-top: 60px;
            padding: 25px;
            color: var(--gray);
            border-top: 1px solid var(--light-gray);
          }
          
          /* Badge */
          .badge {
            background: var(--danger);
            color: white;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 700;
            margin-left: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 24px;
            height: 24px;
          }
          
          /* Summary Card */
          .summary-card {
            background: linear-gradient(135deg, var(--light) 0%, #e9ecef 100%);
            padding: 25px;
            border-radius: var(--border-radius);
            margin-top: 30px;
          }
          
          .summary-title {
            color: var(--dark);
            font-size: 1.2rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
          }
          
          /* Responsive */
          @media (max-width: 768px) {
            .header {
              flex-direction: column;
              gap: 20px;
              text-align: center;
            }
            
            .tabs {
              flex-direction: column;
            }
            
            .stats-grid {
              grid-template-columns: 1fr;
            }
            
            .info-grid {
              grid-template-columns: 1fr;
            }
            
            table {
              min-width: 500px;
            }
            
            th, td {
              padding: 12px 15px;
            }
          }
        </style>
      </head>
      <body>
        <div class="container">
          <!-- En-tête -->
          <div class="header">
            <div class="header-content">
              <h1><i class="fas fa-graduation-cap"></i> Dashboard Étudiant</h1>
              <p>Bienvenue, <strong><xsl:value-of select="dashboard/student/name"/></strong></p>
            </div>
            <a href="../../logout.php" class="btn">
              <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
          </div>

          <!-- Statistiques -->
          <div class="card">
            <h2 class="card-title"><i class="fas fa-chart-bar"></i> Vue d'ensemble</h2>
            <div class="stats-grid">
              <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-calendar-times"></i></div>
                <div class="stat-number"><xsl:value-of select="dashboard/statistics/absences"/></div>
                <div class="stat-label">Absences totales</div>
              </div>
              <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-bell"></i></div>
                <div class="stat-number"><xsl:value-of select="dashboard/statistics/notifications"/></div>
                <div class="stat-label">Notifications</div>
              </div>
              <div class="stat-card">
                <div class="stat-icon">
                  <xsl:choose>
                    <xsl:when test="dashboard/statistics/absences = 0">
                      <i class="fas fa-check-circle"></i>
                    </xsl:when>
                    <xsl:when test="dashboard/statistics/absences &lt;= 3">
                      <i class="fas fa-exclamation-triangle"></i>
                    </xsl:when>
                    <xsl:otherwise>
                      <i class="fas fa-times-circle"></i>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <div class="stat-number">
                  <xsl:choose>
                    <xsl:when test="dashboard/statistics/absences = 0">✓</xsl:when>
                    <xsl:when test="dashboard/statistics/absences &lt;= 3">⚠️</xsl:when>
                    <xsl:otherwise>❌</xsl:otherwise>
                  </xsl:choose>
                </div>
                <div class="stat-label">Statut d'assiduité</div>
              </div>
            </div>
          </div>

          <!-- Navigation par onglets -->
          <div class="tabs">
            <button class="tab-btn active" onclick="showTab('profile')">
              <i class="fas fa-user-circle"></i> Profil
            </button>
            <button class="tab-btn" onclick="showTab('notifications')">
              <i class="fas fa-bell"></i> Notifications
              <xsl:if test="dashboard/statistics/notifications > 0">
                <span class="badge"><xsl:value-of select="dashboard/statistics/notifications"/></span>
              </xsl:if>
            </button>
            <button class="tab-btn" onclick="showTab('absences')">
              <i class="fas fa-calendar-alt"></i> Absences
              <xsl:if test="dashboard/statistics/absences > 0">
                <span class="badge"><xsl:value-of select="dashboard/statistics/absences"/></span>
              </xsl:if>
            </button>
          </div>

          <!-- Onglet Profil -->
          <div id="profile" class="tab-content active">
            <div class="card">
              <h2 class="card-title"><i class="fas fa-id-card"></i> Informations personnelles</h2>
              <div class="info-grid">
                <div class="info-item">
                  <div class="info-label">Nom complet</div>
                  <div class="info-value"><xsl:value-of select="dashboard/student/name"/></div>
                </div>
                <div class="info-item">
                  <div class="info-label">Email académique</div>
                  <div class="info-value"><xsl:value-of select="dashboard/student/email"/></div>
                </div>
                <div class="info-item">
                  <div class="info-label">Classe / Groupe</div>
                  <div class="info-value"><xsl:value-of select="dashboard/student/class"/></div>
                </div>
                <div class="info-item">
                  <div class="info-label">Identifiant unique</div>
                  <div class="info-value">
                    <div class="info-id"><xsl:value-of select="dashboard/student/id"/></div>
                  </div>
                </div>
              </div>
              
              
            </div>
          </div>

          <!-- Onglet Notifications -->
          <div id="notifications" class="tab-content">
            <div class="card">
              <h2 class="card-title"><i class="fas fa-bell"></i> Centre de notifications</h2>
              
              <xsl:choose>
                <xsl:when test="dashboard/statistics/notifications > 0">
                  <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid var(--light-gray);">
                    <div style="font-weight: 600; color: var(--dark);">
                      <xsl:value-of select="dashboard/statistics/notifications"/> notification(s) non lue(s)
                    </div>
                    <button onclick="markAllAsRead()" class="action-btn mark-read-btn">
                      <i class="fas fa-check-double"></i> Tout marquer comme lu
                    </button>
                  </div>
                  
                  <div id="notificationsList">
                    <xsl:for-each select="dashboard/notifications/notification">
                      <xsl:sort select="date" order="descending"/>
                      
                      <!-- Extraction intelligente du module depuis le message -->
                      <xsl:variable name="messageText" select="message"/>
                      <xsl:variable name="moduleName">
                        <xsl:choose>
                          <!-- Chercher le module depuis les absences correspondantes -->
                          <xsl:when test="contains($messageText, 'SE696bc691f1d41')">Java</xsl:when>
                          <xsl:when test="contains($messageText, 'SE696bbd4a479f3')">Java</xsl:when>
                          <xsl:when test="contains($messageText, 'SE696bc139c6231')">Systèmes</xsl:when>
                          <xsl:when test="contains($messageText, 'SE696bbbdc134a8')">Systèmes</xsl:when>
                          <xsl:otherwise>
                            <!-- Par défaut, utiliser le module de l'étudiant -->
                            <xsl:value-of select="dashboard/student/module"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      
                      <!-- Extraction du code de séance -->
                      <xsl:variable name="seanceCode">
                        <xsl:choose>
                          <xsl:when test="contains($messageText, 'SE')">
                            <xsl:value-of select="substring(substring-after($messageText, 'SE'), 1, 13)"/>
                          </xsl:when>
                          <xsl:otherwise>Inconnue</xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      
                      <!-- Date formatée -->
                      <xsl:variable name="formattedDate">
                        <xsl:value-of select="substring(date, 1, 10)"/>
                      </xsl:variable>
                      
                      <div class="notification-item" data-id="{position()}">
                        <div class="notification-header">
                          <div class="notification-title">
                            <i class="fas fa-exclamation-circle"></i> Notification d'absence
                          </div>
                          <div class="notification-date">
                            <xsl:value-of select="$formattedDate"/>
                          </div>
                        </div>
                        
                        <div class="notification-module">
                          <i class="fas fa-book"></i> Module: <strong><xsl:value-of select="$moduleName"/></strong>
                        </div>
                        
                        <div class="notification-message">
                          <strong><i class="fas fa-info-circle"></i> Détails :</strong><br/>
                          <xsl:value-of select="$messageText"/>
                        </div>
                        
                        <xsl:if test="$seanceCode != 'Inconnue'">
                          <div class="notification-seance">
                            <i class="fas fa-fingerprint"></i> Code séance: SE<xsl:value-of select="$seanceCode"/>
                          </div>
                        </xsl:if>
                        
                        <div class="notification-actions">
                          <button onclick="markAsRead(this)" class="action-btn mark-read-btn">
                            <i class="fas fa-check"></i> Marquer comme lu
                          </button>
                          <button onclick="deleteNotification(this)" class="action-btn delete-btn">
                            <i class="fas fa-trash"></i> Supprimer
                          </button>
                        </div>
                      </div>
                    </xsl:for-each>
                  </div>
                  
                  <div class="summary-card" style="margin-top: 30px;">
                    <h3 class="summary-title"><i class="fas fa-info-circle"></i> Informations sur les notifications</h3>
                    <p>Les notifications sont automatiquement générées lorsque vos enseignants enregistrent vos absences.</p>
                    
                    <!-- Statistiques des notifications -->
                    <div style="margin-top: 15px; padding: 15px; background: rgba(67, 97, 238, 0.05); border-radius: 8px;">
                      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                        <div>
                          <div style="color: var(--gray); font-size: 0.9rem;">Total notifications</div>
                          <div style="font-size: 1.5rem; font-weight: 700; color: var(--dark);">
                            <xsl:value-of select="dashboard/statistics/notifications"/>
                          </div>
                        </div>
                        <div>
                          <div style="color: var(--gray); font-size: 0.9rem;">Dernière notification</div>
                          <div style="font-size: 1rem; font-weight: 600; color: var(--dark);">
                            <xsl:value-of select="dashboard/notifications/notification[1]/date"/>
                          </div>
                        </div>
                        <div>
                          <div style="color: var(--gray); font-size: 0.9rem;">Module concerné</div>
                          <div style="font-size: 1rem; font-weight: 600; color: var(--primary);">
                            <xsl:value-of select="dashboard/student/module"/>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </xsl:when>
                
                <xsl:otherwise>
                  <div class="no-data">
                    <div class="no-data-icon"><i class="far fa-bell-slash"></i></div>
                    <h3>Aucune notification</h3>
                    <p>Vous n'avez aucune notification non lue.</p>
                    <p style="margin-top: 10px; font-size: 0.9rem; color: var(--gray);">
                      Les notifications concernant vos absences apparaîtront ici automatiquement.
                    </p>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>

          <!-- Onglet Absences -->
          <div id="absences" class="tab-content">
            <div class="card">
              <h2 class="card-title"><i class="fas fa-calendar-times"></i> Historique des absences</h2>
              
              <xsl:choose>
                <xsl:when test="dashboard/statistics/absences > 0">
                  <!-- Recherche -->
                  <div style="position: relative; margin-bottom: 20px;">
                    <i class="fas fa-search" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: var(--gray);"></i>
                    <input type="text" id="searchAbsences" placeholder="Rechercher par module..." 
                           style="width: 100%; padding: 12px 15px 12px 45px; border: 2px solid var(--light-gray); border-radius: 50px; font-size: 1rem; transition: var(--transition);"/>
                  </div>
                  
                  <div class="table-container">
                    <table id="absencesTable">
                      <thead>
                        <tr>
                          <th><i class="fas fa-calendar"></i> Date</th>
                          <th><i class="fas fa-clock"></i> Heure</th>
                          <th><i class="fas fa-book"></i> Module</th>
                          <th><i class="fas fa-info-circle"></i> Statut</th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="dashboard/absences/absence">
                          <xsl:sort select="date" order="descending"/>
                          <tr data-module="{module}">
                            <td class="date-cell"><xsl:value-of select="date"/></td>
                            <td class="time-cell"><xsl:value-of select="hours"/></td>
                            <td class="module-cell"><xsl:value-of select="module"/></td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="status = 'Absent'">
                                  <span class="status-badge status-absent">
                                    <i class="fas fa-times-circle"></i> Absent
                                  </span>
                                </xsl:when>
                                <xsl:otherwise>
                                  <span class="status-badge status-present">
                                    <i class="fas fa-check-circle"></i> <xsl:value-of select="status"/>
                                  </span>
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                          </tr>
                        </xsl:for-each>
                      </tbody>
                    </table>
                  </div>
                  
                  <!-- Résumé des absences -->
                  <div class="summary-card">
                    <h3 class="summary-title"><i class="fas fa-chart-line"></i> Analyse des absences</h3>
                    
                    <!-- Calcul des statistiques par module -->
                    <xsl:variable name="absencesList" select="dashboard/absences/absence"/>
                    <xsl:variable name="javaAbsences" select="count($absencesList[module='Java'])"/>
                    <xsl:variable name="systemesAbsences" select="count($absencesList[module='Systèmes'])"/>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 15px;">
                      <div>
                        <div style="color: var(--gray); font-size: 0.9rem; margin-bottom: 5px;">Total des absences</div>
                        <div style="font-size: 2rem; font-weight: 800; color: var(--dark);">
                          <xsl:value-of select="dashboard/statistics/absences"/>
                        </div>
                      </div>
                      
                    
                      
                      
                      
                      <div>
                        <div style="color: var(--gray); font-size: 0.9rem; margin-bottom: 5px;">Dernière absence</div>
                        <div style="font-size: 1rem; font-weight: 600; color: var(--dark);">
                          <xsl:value-of select="$absencesList[1]/date"/>
                        </div>
                      </div>
                    </div>
                    
                    <!-- Recommandation -->
                   
                  </div>
                </xsl:when>
                
                <xsl:otherwise>
                  <div class="no-data">
                    <div class="no-data-icon"><i class="far fa-calendar-check"></i></div>
                    <h3>Aucune absence enregistrée</h3>
                    <p>Votre historique d'absences apparaîtra ici.</p>
                    <p style="margin-top: 10px; font-size: 0.9rem; color: var(--gray);">
                      Félicitations pour votre parfaite assiduité !
                    </p>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>

          <!-- Footer -->
          <div class="footer">
            <p>© 2026 Gestion Absence - Plateforme de suivi académique</p>
            <p style="margin-top: 8px; font-size: 0.85rem; color: var(--gray);">
              Connecté en tant que : <span style="font-weight: 600;"><xsl:value-of select="dashboard/student/email"/></span>
            </p>
            <div style="font-family: 'Courier New', monospace; font-size: 0.8rem; color: #adb5bd; margin-top: 10px;">
              Session ID: <xsl:value-of select="$studentId"/>
            </div>
          </div>
        </div>

        <script>
        // Système d'onglets
        function showTab(tabId) {
          // Cacher tous les onglets
          document.querySelectorAll('.tab-content').forEach(function(tab) {
            tab.classList.remove('active');
          });
          
          // Désactiver tous les boutons
          document.querySelectorAll('.tab-btn').forEach(function(btn) {
            btn.classList.remove('active');
          });
          
          // Afficher l'onglet sélectionné
          document.getElementById(tabId).classList.add('active');
          
          // Activer le bouton correspondant
          event.target.classList.add('active');
        }
        
        // Gestion des notifications
        function markAsRead(button) {
          const notification = button.closest('.notification-item');
          notification.classList.add('read');
          notification.style.opacity = '0.7';
          notification.style.transform = 'translateX(0)';
          
          // Mettre à jour le compteur
          updateNotificationCount(-1);
          
          // Feedback visuel
          button.innerHTML = '<i class="fas fa-check"></i> Lu';
          button.style.background = '#6c757d';
        }
        
        function markAllAsRead() {
          const notifications = document.querySelectorAll('.notification-item:not(.read)');
          notifications.forEach(function(notification, index) {
            setTimeout(function() {
              notification.classList.add('read');
              notification.style.opacity = '0.7';
              notification.style.transform = 'translateX(0)';
            }, index * 100);
          });
          
          // Mettre à jour le compteur
          updateNotificationCount(-notifications.length);
          
          // Mettre à jour tous les boutons
          document.querySelectorAll('.notification-actions .mark-read-btn').forEach(function(btn) {
            btn.innerHTML = '<i class="fas fa-check"></i> Lu';
            btn.style.background = '#6c757d';
          });
        }
        
        function deleteNotification(button) {
          const notification = button.closest('.notification-item');
          notification.style.opacity = '0';
          notification.style.transform = 'translateX(-100%)';
          notification.style.height = '0';
          notification.style.margin = '0';
          notification.style.padding = '0';
          notification.style.overflow = 'hidden';
          notification.style.transition = 'all 0.5s ease';
          
          setTimeout(function() {
            notification.remove();
            updateNotificationCount(-1);
          }, 500);
        }
        
        function updateNotificationCount(change) {
          const badge = document.querySelector('.tab-btn:nth-child(2) .badge');
          if (badge) {
            let count = parseInt(badge.textContent) + change;
            if (count &lt;= 0) {
              badge.remove();
            } else {
              badge.textContent = count;
            }
          }
        }
        
        // Filtrage des absences
        document.addEventListener('DOMContentLoaded', function() {
          const searchInput = document.getElementById('searchAbsences');
          
          if (searchInput) {
            searchInput.addEventListener('input', function() {
              const filter = this.value.toLowerCase();
              const rows = document.querySelectorAll('#absencesTable tbody tr');
              
              rows.forEach(function(row) {
                const module = row.dataset.module.toLowerCase();
                const text = row.textContent.toLowerCase();
                
                if (filter === '' || text.includes(filter) || module.includes(filter)) {
                  row.style.display = '';
                } else {
                  row.style.display = 'none';
                }
              });
            });
          }
          
          // Initialiser le premier onglet
          showTab('profile');
          
          // Animation pour les notifications
          const notifications = document.querySelectorAll('.notification-item');
          notifications.forEach(function(notification, index) {
            notification.style.animationDelay = (index * 0.1) + 's';
            notification.style.animation = 'fadeIn 0.5s ease forwards';
          });
        });
        
        // Animation CSS
        const style = document.createElement('style');
        style.textContent = `
          @keyframes fadeIn {
            from {
              opacity: 0;
              transform: translateY(20px);
            }
            to {
              opacity: 1;
              transform: translateY(0);
            }
          }
        `;
        document.head.appendChild(style);
        </script>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>