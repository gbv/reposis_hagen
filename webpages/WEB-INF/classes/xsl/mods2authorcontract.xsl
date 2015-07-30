<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xfdf="http://ns.adobe.com/xfdf/" exclude-result-prefixes="mods">
  <xsl:template match="mycoreobject">
    <xfdf>
      <fields>
        <field name="Titel">
          <value>
            <xsl:value-of select="metadata/def.modsContainer/modsContainer/mods:mods/mods:titleInfo/mods:title" />
          </value>
        </field>
        <xsl:variable  name="user" select="document(concat('user:',service/servflags[@class='MCRMetaLangText']/servflag[@type='createdby']))" />
        <xsl:copy-of select="$user" />
        <field name="Rechteinhaber">
          <value>
            <xsl:value-of select="$user/user/realName"/>
          </value>
        </field>
        <field name="Zugehörigkeit">
          <value>
            <xsl:value-of select="$user/user/attributes/attribute[@name='institution']/@value"/>
          </value>
        </field>
        <field name="Adresse">
          <value>
            <xsl:value-of select="$user/user/attributes/attribute[@name='street']/@value"/>
            <xsl:value-of select="$user/user/attributes/attribute[@name='postalcode']/@value"/>
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
            <xsl:value-of select="$user/user/attributes/attribute[@name='tel']/@value"/>
          </value>
        </field>
      </fields>
    </xfdf>
  </xsl:template>
</xsl:stylesheet>