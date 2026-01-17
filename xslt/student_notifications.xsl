<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8"/>

<xsl:template match="/">
    <div class="notifications-container">
        <h3>📢 Notifications Récentes</h3>
        <div class="notification-list">
            <xsl:apply-templates select="notifications/notification">
                <xsl:sort select="date" order="descending"/>
            </xsl:apply-templates>
        </div>
    </div>
</xsl:template>

<xsl:template match="notification">
    <div class="notification-item">
        <div class="notification-icon">
            <xsl:choose>
                <xsl:when test="contains(message, 'Absence')">⚠️</xsl:when>
                <xsl:otherwise>📢</xsl:otherwise>
            </xsl:choose>
        </div>
        <div class="notification-content">
            <div class="notification-message">
                <xsl:value-of select="message"/>
            </div>
            <div class="notification-meta">
                <span class="notification-date">
                    <xsl:value-of select="date"/>
                </span>
                <span class="student-id">
                    ID: <xsl:value-of select="student_id"/>
                </span>
            </div>
        </div>
    </div>
</xsl:template>

<xsl:template match="notification[position() > 10]">
    <!-- Limit to 10 most recent notifications -->
</xsl:template>

</xsl:stylesheet>