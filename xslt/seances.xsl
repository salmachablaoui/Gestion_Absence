<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8"/>

<xsl:param name="teacherId"/>

<xsl:template match="/">
<html lang="fr">
<head>
    <meta charset="UTF-8"/>
    <title>Dashboard Enseignant</title>
    <link rel="stylesheet" href="../../assets/css/style.css"/>
</head>
<body>

<h1>👨‍🏫 Dashboard Enseignant</h1>

<table border="1" cellpadding="5" cellspacing="0">
<tr>
    <th>ID</th>
    <th>Classe</th>
    <th>Module</th>
    <th>Date & Heure</th>
</tr>

<xsl:for-each select="root/seance">
    <xsl:if test="teacher_id = $teacherId">
        <tr>
            <td><xsl:value-of select="@id"/></td>
            <td><xsl:value-of select="class_id"/></td>
            <td><xsl:value-of select="module"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="datetime">
                        <xsl:value-of select="datetime"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="date"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:if>
</xsl:for-each>

</table>

</body>
</html>
</xsl:template>
</xsl:stylesheet>
