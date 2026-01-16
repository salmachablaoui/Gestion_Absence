<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
    <table>
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Email</th>
            <th>Classe</th>
            <th>Module</th>
            <th>Actions</th>
        </tr>

        <xsl:for-each select="students/student">
            <tr>
                <td><xsl:value-of select="@id"/></td>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="email"/></td>
                <td><xsl:value-of select="class"/></td>
                <td><xsl:value-of select="module"/></td>
                <td>
                    <a>
                        <xsl:attribute name="href">
                            students/edit.php?id=<xsl:value-of select="@id"/>
                        </xsl:attribute>
                        ✏
                    </a>
                    |
                    <a>
                        <xsl:attribute name="href">
                            students/delete.php?id=<xsl:value-of select="@id"/>
                        </xsl:attribute>
                        🗑
                    </a>
                </td>
            </tr>
        </xsl:for-each>
    </table>
</xsl:template>

</xsl:stylesheet>
