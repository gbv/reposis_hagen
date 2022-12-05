<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:mods="http://www.loc.gov/mods/v3" 
    xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
    xmlns:xfdf="http://ns.adobe.com/xfdf/" 
    exclude-result-prefixes="mods mcrxsl">
    
  <xsl:param name="CurrentUser" />
  
  
  <xsl:template match="mycoreobject">
    <xfdf>
      <fields>
        <xsl:if test="mcrxsl:isCurrentUserInRole('admin') or service/servflags[@class='MCRMetaLangText']/servflag[@type='createdby'] = $CurrentUser">
          <field name="Titel der Veröffentlichung">
            <value>
              <xsl:value-of select="metadata/def.modsContainer/modsContainer/mods:mods/mods:titleInfo/mods:title" />
            </value>
          </field>
          <xsl:variable  name="user" select="document(concat('user:',service/servflags[@class='MCRMetaLangText']/servflag[@type='createdby']))" />
          <field name="Autor o sonstiger Rechteinhaber">
            <value>
              <xsl:value-of select="$user/user/realName"/>
            </value>
          </field>
          <field name="Fakultät Fachrichtung Institut">
            <value>
              <xsl:value-of select="$user/user/attributes/attribute[@name='institution']/@value"/>
            </value>
          </field>
          <field name="Adresse">
            <value>
              <xsl:value-of select="$user/user/attributes/attribute[@name='street']/@value"/>
              <xsl:value-of select="' '"/>
              <xsl:value-of select="$user/user/attributes/attribute[@name='postalcode']/@value"/>
              <xsl:value-of select="' '"/>
              <xsl:value-of select="$user/user/attributes/attribute[@name='city']/@value"/>
            </value>
          </field>
          <field name="Telefon">
            <value>
              <xsl:value-of select="$user/user/attributes/attribute[@name='tel']/@value"/>
            </value>
          </field>
          <field name="EMail">
            <value>
              <xsl:value-of select="$user/user/eMail"/>
            </value>
          </field>
        </xsl:if>
       </fields>
    </xfdf>
  </xsl:template>
</xsl:stylesheet>