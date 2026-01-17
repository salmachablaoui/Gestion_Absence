<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Paramètres -->
  <xsl:param name="teacherId"/>
  <xsl:param name="studentsXmlPath"/>
  <xsl:param name="classesXmlPath"/>
  <xsl:param name="absencesXmlPath"/>
  <xsl:param name="seancesXmlPath"/>

  <!-- Charger les fichiers XML externes -->
  <xsl:variable name="students" select="document($studentsXmlPath)/students"/>
  <xsl:variable name="classes" select="document($classesXmlPath)/classes"/>
  <xsl:variable name="absences" select="document($absencesXmlPath)/absences"/>
  <xsl:variable name="seances" select="document($seancesXmlPath)/seances"/>

  <xsl:template match="/">
    <html lang="fr">
      <head>
        <meta charset="UTF-8"/>
        <title>Dashboard Enseignant</title>
        <link rel="stylesheet" href="../../assets/css/style.css"/>
        <style>
          .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
          .actions { margin: 20px 0; display: flex; gap: 10px; }
          .btn { padding: 10px 15px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
          .btn.logout { background: #dc3545; }
          .btn:hover { opacity: 0.9; }
          table { width: 100%; border-collapse: collapse; margin: 20px 0; }
          th, td { border: 1px solid #000000; padding: 10px; text-align: left; }
          th { 
            background-color: #f8f9fa; 
            color: #000000;
            font-weight: bold;
          }
          .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
          .modal-content { background-color: white; margin: 10% auto; padding: 20px; border-radius: 5px; width: 80%; max-width: 500px; border: 1px solid #000000; }
          .close { float: right; font-size: 24px; cursor: pointer; color: #000000; }
          .close:hover { color: #333; }
          .form-group { margin: 15px 0; }
          label { display: block; margin-bottom: 5px; font-weight: bold; color: #000000; }
          select, input[type="datetime-local"] { 
            width: 100%; 
            padding: 8px; 
            border: 1px solid #000000;
            border-radius: 4px; 
            box-sizing: border-box; 
          }
          .form-buttons { margin-top: 20px; display: flex; gap: 10px; }
          h1, h2 { color: #000000; }
          .no-seances { text-align: center; padding: 20px; color: #666; font-style: italic; }
          .warning-message { background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 4px; margin: 15px 0; }
          .warning-message p { margin: 0; color: #856404; }
          .absent-checked { background-color: #fff3cd; } /* Jaune pour les absents */
        </style>
      </head>
      <body>
        <div class="container">
          <h1>👨‍🏫 Dashboard Enseignant</h1>

          <div class="actions">
            <button id="openAddSeance" class="btn">➕ Créer une séance</button>
            <a href="../../logout.php" class="btn logout">🔒 Déconnexion</a>
          </div>

          <h2>📅 Séances</h2>
          
          <!-- Afficher un message si aucune séance n'est trouvée -->
          <xsl:if test="count($seances/seance[teacher_id = $teacherId]) = 0">
            <div class="warning-message">
              <p>
                ⚠️ Aucune séance trouvée pour votre compte.<br/>
                <small>Créez votre première séance en cliquant sur le bouton "➕ Créer une séance".</small>
              </p>
            </div>
          </xsl:if>
          
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Classe</th>
                <th>Module</th>
                <th>Date &amp; Heure</th>
                <th>Actions</th>
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
                            <xsl:value-of select="$classes/class[@id=$classId]/name"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <span style="color: #dc3545;">Classe ID: <xsl:value-of select="$classId"/></span>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td><xsl:value-of select="module"/></td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="datetime and datetime != ''">
                            <!-- Formater la date pour un meilleur affichage -->
                            <xsl:variable name="dateTime" select="datetime"/>
                            <xsl:variable name="formattedDate">
                              <xsl:choose>
                                <xsl:when test="contains($dateTime, 'T')">
                                  <xsl:value-of select="substring($dateTime, 9, 2)"/>/<xsl:value-of select="substring($dateTime, 6, 2)"/>/<xsl:value-of select="substring($dateTime, 1, 4)"/>
                                  à <xsl:value-of select="substring($dateTime, 12, 5)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="$dateTime"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:variable>
                            <xsl:value-of select="$formattedDate"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <span style="color: #dc3545;">Date non spécifiée</span>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <button class="btn manageAbsenceBtn" data-seance-id="{$currentSeanceId}">
                          📋 Gérer l'absence
                        </button>
                      </td>
                    </tr>
                    
                    <!-- Tableau des absences -->
                    <tr class="absenceTableRow" id="absenceTable_{$currentSeanceId}" style="display:none;">
                      <td colspan="5">
                        <form method="post" action="mark_absence.php" id="form_{$currentSeanceId}">
                          <input type="hidden" name="seance_id" value="{$currentSeanceId}"/>
                          <input type="hidden" name="class_id" value="{class_id}"/>
                          <input type="hidden" name="teacher_id" value="{$teacherId}"/>
                          
                          <table style="margin: 10px 0; width: 100%; border: 1px solid #ddd;">
                            <thead>
                              <tr>
                                <th>Nom</th>
                                <th>Email</th>
                                <th>Absent</th>
                                <th>Statut</th>
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
                                    
                                    <!-- VÉRIFICATION AMÉLIORÉE DES ABSENCES -->
                                    <xsl:variable name="isAbsent">
                                      <xsl:choose>
                                        <!-- Chercher dans absences/absence -->
                                        <xsl:when test="$absences/absence[student_id=$studentId and seance_id=$currentSeanceId]">1</xsl:when>
                                        <xsl:when test="$absences/absence[studentId=$studentId and seanceId=$currentSeanceId]">1</xsl:when>
                                        <!-- Alternative: chercher par nom si pas d'ID -->
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
                                            <xsl:attribute name="data-was-absent">true</xsl:attribute>
                                          </xsl:if>
                                        </input>
                                        <label style="display: inline; margin-left: 5px;">Absent</label>
                                      </td>
                                      <td>
                                        <xsl:choose>
                                          <xsl:when test="$isAbsent = '1'">
                                            <span style="color: #dc3545; font-weight: bold;">❌ Absent</span>
                                          </xsl:when>
                                          <xsl:otherwise>
                                            <span style="color: #28a745;">✅ Présent</span>
                                          </xsl:otherwise>
                                        </xsl:choose>
                                      </td>
                                    </tr>
                                  </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                  <tr>
                                    <td colspan="4" style="text-align:center;padding:20px;">
                                      <em>Aucun étudiant dans cette classe</em>
                                    </td>
                                  </tr>
                                </xsl:otherwise>
                              </xsl:choose>
                            </tbody>
                          </table>
                          <div class="form-buttons">
                            <button type="submit" class="btn">💾 Enregistrer les absences</button>
                            <button type="button" class="btn logout cancel-absence-btn" data-seance-id="{$currentSeanceId}">Annuler</button>
                          </div>
                        </form>
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td colspan="5" class="no-seances">
                      <em>Aucune séance créée pour le moment.</em>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
            </tbody>
          </table>

          <!-- Modal création séance -->
          <div class="modal" id="addSeanceModal">
            <div class="modal-content">
              <span class="close" id="closeAddSeance">✕</span>
              <h2>➕ Créer une séance</h2>
              
              <form method="post" action="create_seance.php" id="createSeanceForm">
                <input type="hidden" name="teacher_id" value="{$teacherId}"/>
                
                <div class="form-group">
                  <label>Classe :</label>
                  <select name="class_id" id="classSelect" required="required">
                    <option value="">-- Choisir une classe --</option>
                    <xsl:for-each select="$classes/class">
                      <xsl:sort select="name"/>
                      <option value="{@id}">
                        <xsl:value-of select="name"/>
                      </option>
                    </xsl:for-each>
                  </select>
                </div>
                
                <div class="form-group">
                  <label>Module :</label>
                  <select name="module" id="moduleSelect" required="required" disabled="disabled">
                    <option value="">-- Sélectionnez d'abord une classe --</option>
                  </select>
                  <small id="moduleHelp" style="display: block; margin-top: 5px;"></small>
                </div>
                
                <div class="form-group">
                  <label>Date &amp; Heure :</label>
                  <input type="datetime-local" name="datetime" required="required"/>
                </div>

                <div class="form-buttons">
                  <button type="submit" class="btn" id="submitBtn">Créer</button>
                  <button type="button" class="btn logout" id="cancelAddSeance">Annuler</button>
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
        
        // Fonction pour charger les modules
        function loadModules() {
          const classId = document.getElementById('classSelect').value;
          const moduleSelect = document.getElementById('moduleSelect');
          const moduleHelp = document.getElementById('moduleHelp');
          const submitBtn = document.getElementById('submitBtn');
          
          if (!classId) {
            moduleSelect.disabled = true;
            moduleSelect.innerHTML = '<option value="">-- Sélectionnez d\'abord une classe --</option>';
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
            defaultOption.textContent = '-- Choisir un module --';
            moduleSelect.appendChild(defaultOption);
            
            // Ajouter chaque module
            modules.forEach(module => {
              const option = document.createElement('option');
              option.value = module;
              option.textContent = module;
              moduleSelect.appendChild(option);
            });
            
            // Afficher l'aide
            moduleHelp.textContent = modules.length + ' module(s) disponible(s)';
            moduleHelp.style.color = 'green';
            submitBtn.disabled = false;
          } else {
            const option = document.createElement('option');
            option.value = '';
            option.textContent = 'Aucun module disponible';
            moduleSelect.appendChild(option);
            moduleHelp.textContent = 'Aucun module configuré pour cette classe';
            moduleHelp.style.color = 'orange';
            submitBtn.disabled = true;
          }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
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
                this.textContent = isHidden ? "📋 Fermer" : "📋 Gérer l'absence";
                
                // Fermer les autres tableaux d'absence ouverts
                if (isHidden) {
                  document.querySelectorAll(".absenceTableRow").forEach(otherRow => {
                    if (otherRow.id !== "absenceTable_" + seanceId) {
                      otherRow.style.display = "none";
                      const otherBtn = document.querySelector('[data-seance-id="' + otherRow.id.replace('absenceTable_', '') + '"]');
                      if (otherBtn) otherBtn.textContent = "📋 Gérer l'absence";
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
                if (manageBtn) manageBtn.textContent = "📋 Gérer l'absence";
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
          
          // Événement changement de classe
          document.getElementById('classSelect').addEventListener('change', loadModules);
          
          // Validation du formulaire création séance
          document.getElementById('createSeanceForm').addEventListener('submit', function(e) {
            const classId = document.getElementById('classSelect').value;
            const module = document.getElementById('moduleSelect').value;
            const datetime = document.querySelector('input[name="datetime"]').value;
            
            if (!classId || !module || !datetime) {
              e.preventDefault();
              alert('❌ Veuillez remplir tous les champs obligatoires');
              return false;
            }
            
            return true;
          });
          
          // Gestion AJAX pour les absences (optionnel - pour éviter rechargement page)
          document.querySelectorAll('form[id^="form_"]').forEach(form => {
            form.addEventListener('submit', function(e) {
              // Vous pouvez ajouter ici une requête AJAX si vous voulez
              // sinon, laisser le formulaire se soumettre normalement
              
              // Afficher un message de confirmation
              if (!confirm('Êtes-vous sûr de vouloir enregistrer les absences ?')) {
                e.preventDefault();
                return false;
              }
              
              // Afficher un indicateur de chargement
              const submitBtn = this.querySelector('button[type="submit"]');
              const originalText = submitBtn.textContent;
              submitBtn.textContent = '⏳ Enregistrement...';
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
                  statusCell.innerHTML = '<span style="color: #dc3545; font-weight: bold;">❌ Absent</span>';
                }
              } else {
                row.classList.remove('absent-checked');
                if (statusCell) {
                  statusCell.innerHTML = '<span style="color: #28a745;">✅ Présent</span>';
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