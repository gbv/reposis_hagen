<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="DefaultLang" />
  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="ServletsBaseURL" />
  <xsl:param name="MCR.mir-module.MailSender" />
  <xsl:variable name="newline" select="'&#xA;'" />

  <xsl:template match="/">
    <email>
      <from>dms@lists.gbv.de</from>
      <replyTo>publizieren.ub@fernuni-hagen.de</replyTo>
      <xsl:apply-templates select="/*" mode="email" />
    </email>
  </xsl:template>

  <xsl:template match="user" mode="email">
    <to>
      <xsl:value-of select="eMail/text()" />
    </to>
    <to>paul.borchert@gbv.de</to>
    <subject>
      Ihre Benutzerkennung wurde angelegt!
    </subject>
    <body>
      Bitte benutzen Sie folgenden Link um ihre E-Mail-Adresse zu bestätigen und die Registrierung abzuschließen.
      <xsl:value-of select="$newline" />
      <xsl:value-of
        select="concat($ServletsBaseURL, 'MirSelfRegistrationServlet?action=verify&amp;user=', @name, '&amp;realm=', @realm, '&amp;token=', attributes/attribute[@name='mailtoken']/@value)" />
      <xsl:value-of select="$newline" />
    </body>
  </xsl:template>
</xsl:stylesheet>
