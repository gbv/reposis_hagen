<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xfdf="http://ns.adobe.com/xfdf/" exclude-result-prefixes="mods">
  <xsl:template match="mycoreobject">
    <xfdf:xfdf>
      <xfdf:fields>
        <xfdf:field name="Titel">
          <xfdf:value>
            <xsl:value-of select="metadata/def.modsContainer/modsContainer/mods:mods/mods:titleInfo/mods:title" />
          </xfdf:value>
        </xfdf:field>
        <xsl:variable  name="user" select="document(concat('user:',service/servflags[@class='MCRMetaLangText']/servflag[@type='createdby']))" />
        <xsl:copy-of select="$user" />
      </xfdf:fields>
    </xfdf:xfdf>
  </xsl:template>
</xsl:stylesheet>