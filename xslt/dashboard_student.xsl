<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Paramètres -->
  <xsl:param name="studentEmail"/>
  <xsl:param name="studentsXmlPath"/>
  <xsl:param name="absencesXmlPath"/>
  <xsl:param name="teachersXmlPath"/>
  <xsl:param name="seancesXmlPath"/> <!-- AJOUT: Chemin vers le XML des séances -->

  <!-- Charger les fichiers XML externes -->
  <xsl:variable name="students" select="document($studentsXmlPath)/students"/>
  <xsl:variable name="absences" select="document($absencesXmlPath)/absences"/>
  <xsl:variable name="teachers" select="document($teachersXmlPath)/teachers"/>
  <xsl:variable name="seances" select="document($seancesXmlPath)/seances"/> <!-- AJOUT -->

  <!-- Trouver l'étudiant connecté -->
  <xsl:variable name="studentData" select="$students/student[email=$studentEmail]"/>
  <xsl:variable name="studentId" select="$studentData/@id"/>

  <!-- Récupérer les absences de l'étudiant -->
  <xsl:variable name="studentAbsences" select="$absences/absence[studentId=$studentId or student_id=$studentId]"/>

  <!-- Vérifier pénalité (plus de 10 absences) -->
  <xsl:variable name="penalty" select="count($studentAbsences) >= 10"/>

  <xsl:template match="/">
    <html lang="fr">
      <head>
        <meta charset="UTF-8"/>
        <title>Dashboard Étudiant</title>
        <link rel="stylesheet" href="../../assets/css/style.css"/>
        <style>
          .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
          .actions { margin: 20px 0; display: flex; justify-content: space-between; align-items: center; }
          .btn { 
            padding: 10px 15px; 
            background: #007bff; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            text-decoration: none; 
            display: inline-block;
          }
          .btn.logout { background: #dc3545; }
          .btn:hover { opacity: 0.9; }
          table { width: 100%; border-collapse: collapse; margin: 20px 0; }
          th, td { border: 1px solid #000000; padding: 10px; text-align: left; }
          th { 
            background-color: #f8f9fa; 
            color: #000000;
            font-weight: bold;
          }
          h1, h2 { color: #000000; }
          .info-section { background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0; }
          .info-item { margin: 8px 0; }
          .warning { 
            background-color: #fff3cd; 
            color: #856404; 
            padding: 15px; 
            border-radius: 4px; 
            margin: 15px 0;
            border: 1px solid #ffeaa7;
            font-weight: bold;
          }
          .no-data { 
            text-align: center; 
            padding: 20px; 
            color: #6c757d; 
            font-style: italic;
          }
          .absence-count {
            display: inline-block;
            background: #e9ecef;
            padding: 5px 10px;
            border-radius: 20px;
            font-weight: bold;
            margin-left: 10px;
          }
          .count-high {
            background: #f8d7da;
            color: #721c24;
          }
          .count-low {
            background: #d4edda;
            color: #155724;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>🎓 Dashboard Étudiant</h1>

          <div class="actions">
            <div>
              <span>Bienvenue, <strong><xsl:value-of select="$studentData/name"/></strong></span>
              <span class="absence-count">
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="$penalty">absence-count count-high</xsl:when>
                    <xsl:otherwise>absence-count count-low</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="count($studentAbsences)"/> absence(s)
              </span>
            </div>
            <a href="../../logout.php" class="btn logout">🔒 Déconnexion</a>
          </div>

          <xsl:if test="$penalty">
            <div class="warning">
              ⚠️ Attention : Vous avez atteint le nombre maximum d'absences (10+) !
              Des sanctions peuvent être appliquées.
            </div>
          </xsl:if>

          <h2>📋 Informations personnelles</h2>
          <div class="info-section">
            <div class="info-item">
              <strong>Nom :</strong> <xsl:value-of select="$studentData/name"/>
            </div>
            <div class="info-item">
              <strong>Email :</strong> <xsl:value-of select="$studentData/email"/>
            </div>
            <div class="info-item">
              <strong>Classe :</strong> <xsl:value-of select="$studentData/class"/>
            </div>
            <div class="info-item">
              <strong>ID étudiant :</strong> <xsl:value-of select="$studentId"/>
            </div>
          </div>

          <h2>📅 Mes absences</h2>
          <table>
            <thead>
              <tr>
                <th style="color: #000000;">Date</th>
                <th style="color: #000000;">Heure</th>
                <th style="color: #000000;">Module</th>
                <th style="color: #000000;">Professeur</th>
                <th style="color: #000000;">Séance ID</th>
              </tr>
            </thead>
            <tbody>
              <xsl:choose>
                <xsl:when test="$studentAbsences">
                  <xsl:for-each select="$studentAbsences">
                    <xsl:sort select="date" order="descending"/>
                    
                    <xsl:variable name="currentAbsence" select="."/>
                    <xsl:variable name="teacherId" select="teacherId"/>
                    <xsl:variable name="teacherName" select="$teachers/teacher[@id=$teacherId]/name"/>
                    
                    <!-- Récupérer le seanceId (avec différentes possibilités de nommage) -->
                    <xsl:variable name="seanceId">
                      <xsl:choose>
                        <xsl:when test="seanceId">
                          <xsl:value-of select="seanceId"/>
                        </xsl:when>
                        <xsl:when test="seance_id">
                          <xsl:value-of select="seance_id"/>
                        </xsl:when>
                        <xsl:when test="seanceId/text()">
                          <xsl:value-of select="seanceId/text()"/>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    
                    <!-- Trouver le module correspondant à la séance -->
                    <xsl:variable name="seanceModule">
                      <xsl:if test="$seanceId != ''">
                        <xsl:value-of select="$seances/seance[@id=$seanceId or id=$seanceId]/module"/>
                      </xsl:if>
                    </xsl:variable>
                    
                    <tr>
                      <td>
                        <xsl:value-of select="date"/>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="hours and hours != ''">
                            <xsl:value-of select="hours"/>
                          </xsl:when>
                          <xsl:otherwise>-</xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <!-- AFFICHER le module dans l'ordre de priorité -->
                        <xsl:choose>
                          <!-- 1. Module directement dans l'absence -->
                          <xsl:when test="module and module != ''">
                            <xsl:value-of select="module"/>
                          </xsl:when>
                          <!-- 2. Module de la séance -->
                          <xsl:when test="$seanceModule != ''">
                            <xsl:value-of select="$seanceModule"/>
                          </xsl:when>
                          <!-- 3. Module par défaut de l'étudiant -->
                          <xsl:otherwise>
                            <xsl:value-of select="$studentData/module"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$teacherName">
                            <xsl:value-of select="$teacherName"/>
                          </xsl:when>
                          <xsl:otherwise>-</xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:value-of select="$seanceId"/>
                      </td>
                    </tr>
                  </xsl:for-each>
                  <!-- Résumé -->
                  <tr style="background-color: #f8f9fa;">
                    <td colspan="5" style="text-align: center; font-weight: bold;">
                      Total: <xsl:value-of select="count($studentAbsences)"/> absence(s)
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td colspan="5" class="no-data">
                      ✅ Aucune absence enregistrée
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
            </tbody>
          </table>

          <xsl:if test="$studentAbsences">
            <div style="margin-top: 20px; padding: 15px; background: #e8f4f8; border-radius: 5px;">
              <h3>📊 Statistiques des absences</h3>
              <div class="info-item">
                <strong>Total des absences :</strong> <xsl:value-of select="count($studentAbsences)"/>
              </div>
              <div class="info-item">
                <strong>Dernière absence :</strong> 
                <xsl:variable name="lastAbsence" select="$studentAbsences[last()]"/>
                <xsl:value-of select="$lastAbsence/date"/>
                <xsl:if test="$lastAbsence/hours != ''">
                  à <xsl:value-of select="$lastAbsence/hours"/>
                </xsl:if>
              </div>
              <div class="info-item">
                <strong>Module(s) concerné(s) :</strong>
                <!-- Afficher la liste des modules uniques -->
                <xsl:variable name="uniqueModules">
                  <modules>
                    <xsl:for-each select="$studentAbsences">
                      <xsl:variable name="currentModule">
                        <xsl:choose>
                          <xsl:when test="module and module != ''">
                            <xsl:value-of select="module"/>
                          </xsl:when>
                          <xsl:when test="seanceId">
                            <xsl:value-of select="$seances/seance[@id=current()/seanceId]/module"/>
                          </xsl:when>
                          <xsl:when test="seance_id">
                            <xsl:value-of select="$seances/seance[@id=current()/seance_id]/module"/>
                          </xsl:when>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:if test="$currentModule != '' and not(preceding-sibling::absence[
                        (module = $currentModule) or 
                        (seanceId and $seances/seance[@id=current()/seanceId]/module = $currentModule) or
                        (seance_id and $seances/seance[@id=current()/seance_id]/module = $currentModule)
                      ])">
                        <module><xsl:value-of select="$currentModule"/></module>
                      </xsl:if>
                    </xsl:for-each>
                  </modules>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="exsl:node-set($uniqueModules)/module">
                    <xsl:for-each select="exsl:node-set($uniqueModules)/module">
                      <xsl:value-of select="."/>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>-</xsl:otherwise>
                </xsl:choose>
              </div>
              <div class="info-item">
                <strong>État :</strong>
                <xsl:choose>
                  <xsl:when test="$penalty">
                    <span style="color: #dc3545; font-weight: bold;">⚠️ Dépasse la limite</span>
                  </xsl:when>
                  <xsl:when test="count($studentAbsences) >= 5">
                    <span style="color: #ffc107; font-weight: bold;">⚠️ Attention</span> (plus de 5 absences)
                  </xsl:when>
                  <xsl:otherwise>
                    <span style="color: #28a745; font-weight: bold;">✅ Dans les limites</span>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </div>
          </xsl:if>
        </div>

        <script>
        <![CDATA[
        document.addEventListener('DOMContentLoaded', function() {
          console.log('Dashboard étudiant chargé');
          
          // Mettre en évidence les lignes d'absence récentes (moins de 7 jours)
          const rows = document.querySelectorAll('table tbody tr');
          const today = new Date();
          
          rows.forEach(row => {
            const dateCell = row.cells[0];
            if (dateCell && dateCell.textContent !== '-' && dateCell.textContent.includes('202')) {
              const absenceDate = new Date(dateCell.textContent);
              const diffTime = Math.abs(today - absenceDate);
              const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
              
              if (diffDays <= 7) {
                row.style.backgroundColor = '#fff3cd';
                row.style.fontWeight = 'bold';
              }
            }
          });
          
          // Ajouter un événement pour exporter les absences
          const exportBtn = document.createElement('button');
          exportBtn.className = 'btn';
          exportBtn.style.marginTop = '20px';
          exportBtn.textContent = '📄 Exporter mes absences';
          exportBtn.onclick = function() {
            const table = document.querySelector('table');
            let csv = [];
            
            // En-têtes
            const headers = [];
            table.querySelectorAll('thead th').forEach(th => {
              headers.push(th.textContent);
            });
            csv.push(headers.join(','));
            
            // Données
            table.querySelectorAll('tbody tr').forEach(row => {
              const rowData = [];
              row.querySelectorAll('td').forEach(cell => {
                rowData.push(cell.textContent);
              });
              csv.push(rowData.join(','));
            });
            
            // Télécharger
            const csvContent = csv.join('\n');
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'mes_absences_' + new Date().toISOString().slice(0,10) + '.csv';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
          };
          
          // Ajouter le bouton si des absences existent
          if (document.querySelector('table tbody tr:not(.no-data)')) {
            document.querySelector('.container').appendChild(exportBtn);
          }
        });
        ]]>
        </script>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>