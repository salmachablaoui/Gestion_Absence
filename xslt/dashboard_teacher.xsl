<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Paramètres -->
  <xsl:param name="teacherId"/>
  <xsl:param name="studentsXmlPath"/>
  <xsl:param name="classesXmlPath"/>
  <xsl:param name="absencesXmlPath"/>

  <!-- Charger les fichiers XML externes -->
  <xsl:variable name="students" select="document($studentsXmlPath)/students"/>
  <xsl:variable name="classes" select="document($classesXmlPath)/classes"/>
  <xsl:variable name="absences" select="document($absencesXmlPath)/absences"/>

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
            color: #000000; /* AJOUTÉ ICI : couleur noire pour les noms de colonnes */
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
          
          <table>
            <thead>
              <tr>
                <th style="color: #000000;">ID</th> <!-- AJOUTÉ ICI -->
                <th style="color: #000000;">Classe</th> <!-- AJOUTÉ ICI -->
                <th style="color: #000000;">Module</th> <!-- AJOUTÉ ICI -->
                <th style="color: #000000;">Date &amp; Heure</th> <!-- AJOUTÉ ICI -->
                <th style="color: #000000;">Actions</th> <!-- AJOUTÉ ICI -->
              </tr>
            </thead>
            <tbody>
              <xsl:choose>
                <xsl:when test="root/seance[teacher_id = $teacherId]">
                  <xsl:for-each select="root/seance[teacher_id = $teacherId]">
                    <xsl:sort select="datetime" order="descending"/>
                    
                    <tr>
                      <td><xsl:value-of select="@id"/></td>
                      <td>
                        <xsl:variable name="classId" select="class_id"/>
                        <xsl:value-of select="$classes/class[@id=$classId]/name"/>
                      </td>
                      <td><xsl:value-of select="module"/></td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="datetime">
                            <xsl:value-of select="datetime"/>
                          </xsl:when>
                          <xsl:when test="date">
                            <xsl:value-of select="date"/>
                          </xsl:when>
                          <xsl:otherwise>Non spécifiée</xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <button class="btn manageAbsenceBtn" data-seance-id="{@id}">
                          📋 Gérer l'absence
                        </button>
                      </td>
                    </tr>
                    
                    <!-- Tableau des absences caché -->
                    <tr class="absenceTableRow" id="absenceTable_{@id}" style="display:none;">
                      <td colspan="5">
                        <form method="post" action="mark_absence.php">
                          <input type="hidden" name="seance_id" value="{@id}"/>
                          <input type="hidden" name="class_id" value="{class_id}"/>
                          
                          <table style="margin: 10px 0; width: 100%; border: 1px solid #000000;">
                            <thead>
                              <tr>
                                <th style="color: #000000;">Nom</th> <!-- AJOUTÉ ICI -->
                                <th style="color: #000000;">Email</th> <!-- AJOUTÉ ICI -->
                                <th style="color: #000000;">Absent</th> <!-- AJOUTÉ ICI -->
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
                                    <xsl:variable name="studentAbsence" select="$absences/absence[(studentId=$studentId or student_id=$studentId) and seanceId=current()/../@id]"/>
                                    
                                    <tr>
                                      <td><xsl:value-of select="name"/></td>
                                      <td><xsl:value-of select="email"/></td>
                                      <td>
                                        <input type="checkbox" name="absent_students[]" value="{$studentId}">
                                          <xsl:if test="$studentAbsence">
                                            <xsl:attribute name="checked">checked</xsl:attribute>
                                          </xsl:if>
                                        </input>
                                        <label style="display: inline; margin-left: 5px; color: #000000;">Absent</label>
                                      </td>
                                    </tr>
                                  </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                  <tr>
                                    <td colspan="3" style="text-align:center;padding:20px; color: #000000;">
                                      <em>Aucun étudiant dans cette classe</em>
                                    </td>
                                  </tr>
                                </xsl:otherwise>
                              </xsl:choose>
                            </tbody>
                          </table>
                          <button type="submit" class="btn" style="margin-top:10px; border: 1px solid #000000;">Enregistrer les absences</button>
                        </form>
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td colspan="5" style="text-align:center;padding:20px; color: #000000;">
                      <em>Aucune séance créée pour le moment.</em>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
            </tbody>
          </table>

          <!-- Modal création séance -->
          <div class="modal" id="addSeanceModal" style="display:none;">
            <div class="modal-content">
              <span class="close" id="closeAddSeance">✕</span>
              <h2>➕ Créer une séance</h2>
              
              <form method="post" action="create_seance.php" id="createSeanceForm">
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
                  <small id="moduleHelp" style="display: block; margin-top: 5px; color: #000000;"></small>
                </div>
                
                <div class="form-group">
                  <label>Date &amp; Heure :</label>
                  <input type="datetime-local" name="datetime" required="required"/>
                </div>

                <div class="form-buttons">
                  <button type="submit" class="btn" id="submitBtn" style="border: 1px solid #000000;">Créer</button>
                  <button type="button" class="btn logout" id="cancelAddSeance" style="border: 1px solid #000000;">Annuler</button>
                </div>
              </form>
            </div>
          </div>
          
        </div>
        
        <script>
        <![CDATA[
        // Données des modules par classe (sans AJAX)
        const modulesData = {
          'GI1': ['Mathématiques', 'Algorithmique'],
          'GI2': ['Base de données', 'Java']
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
            moduleHelp.style.color = '#000000';
            submitBtn.disabled = false;
          } else {
            const option = document.createElement('option');
            option.value = '';
            option.textContent = 'Aucun module disponible';
            moduleSelect.appendChild(option);
            moduleHelp.textContent = 'Aucun module configuré';
            moduleHelp.style.color = '#000000';
            submitBtn.disabled = true;
          }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
          // Gestion des absences
          document.querySelectorAll(".manageAbsenceBtn").forEach(btn => {
            btn.addEventListener("click", function() {
              const seanceId = this.getAttribute('data-seance-id');
              const row = document.getElementById("absenceTable_" + seanceId);
              if (row) {
                const isHidden = row.style.display === "none";
                row.style.display = isHidden ? "table-row" : "none";
                this.textContent = isHidden ? "📋 Fermer" : "📋 Gérer l'absence";
              }
            });
          });
          
          // Modal
          const modal = document.getElementById("addSeanceModal");
          
          document.getElementById("openAddSeance").onclick = function() {
            modal.style.display = "block";
            document.getElementById('createSeanceForm').reset();
            document.getElementById('moduleSelect').disabled = true;
            document.getElementById('moduleSelect').innerHTML = '<option value="">-- Sélectionnez d\'abord une classe --</option>';
            document.getElementById('moduleHelp').textContent = '';
            document.getElementById('submitBtn').disabled = true;
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
          
          // Validation
          document.getElementById('createSeanceForm').addEventListener('submit', function(e) {
            const classId = document.getElementById('classSelect').value;
            const module = document.getElementById('moduleSelect').value;
            const datetime = document.querySelector('input[name="datetime"]').value;
            
            if (!classId || !module || !datetime) {
              e.preventDefault();
              alert('Veuillez remplir tous les champs obligatoires');
              return false;
            }
            
            if (module === '' || module.includes('Sélectionnez') || module.includes('Choisir')) {
              e.preventDefault();
              alert('Veuillez sélectionner un module valide');
              return false;
            }
            
            return true;
          });
        });
        ]]>
        </script>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>