<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/dashboard">
        <html>
        <head>
            <title>Dashboard Admin</title>
            <link rel="stylesheet" href="../../assets/css/style.css"/>
        </head>
        <body>
            <div class="container">
                <h1>🛠 Dashboard Admin</h1>

                <!-- Boutons Ajouter / Déconnexion -->
                <div class="actions">
                    <a href="students/add.php" class="btn">➕ Ajouter Étudiant</a>
                    <a href="teachers/add.php" class="btn">➕ Ajouter Enseignant</a>
                    <a href="../../logout.php" class="btn logout">🔒 Déconnexion</a>
                </div>

                <!-- ================= ÉTUDIANTS ================= -->
                <h2>👨‍🎓 Étudiants</h2>
                <table border="1">
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Email</th>
                        <th>Classe</th>
                        <th>Actions</th>
                    </tr>

                    <xsl:for-each select="students/student">
                        <tr>
                            <td><xsl:value-of select="@id"/></td>
                            <td><xsl:value-of select="name"/></td>
                            <td><xsl:value-of select="email"/></td>
                            <td><xsl:value-of select="class"/></td>
                            <td>
                                <a href="students/edit.php?id={@id}" class="edit">✏</a>
                                <a href="students/delete.php?id={@id}"
                                   class="delete"
                                   onclick="return confirm('Supprimer cet étudiant ?')">🗑</a>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>

                <!-- ================= ENSEIGNANTS ================= -->
                <h2>👨‍🏫 Enseignants</h2>
                <table border="1">
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Email</th>
                        <th>Classe</th>
                        <th>Module</th>
                        <th>Actions</th>
                    </tr>

                    <xsl:for-each select="teachers/teacher">
                        <tr>
                            <td><xsl:value-of select="@id"/></td>
                            <td><xsl:value-of select="name"/></td>
                            <td><xsl:value-of select="email"/></td>
                            <td><xsl:value-of select="class"/></td>
                            <td><xsl:value-of select="module"/></td>
                            <td>
                                <a href="teachers/edit.php?id={@id}" class="edit">✏</a>
                                <a href="teachers/delete.php?id={@id}"
                                   class="delete"
                                   onclick="return confirm('Supprimer cet enseignant ?')">🗑</a>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>

            </div>
        </body>
        </html>
    </xsl:template>

</xsl:stylesheet>