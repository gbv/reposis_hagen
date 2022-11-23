<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mcrxml="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="mcrxml mods xlink">
  <xsl:import href="xslImport:modsmeta:metadata/mir-breadcrumbs.xsl" />
  <xsl:template match="/">
    <xsl:variable name="mods" select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods" />
    <div id="mir-breadcrumb">
      <ul class="breadcrumb" itemprop="breadcrumb">
        <xsl:if test="$mods/mods:relatedItem[@type='series']">
          <li>
            <xsl:call-template name="objectLink">
              <xsl:with-param select="$mods/mods:relatedItem[@type='series']/@xlink:href" name="obj_id" />
            </xsl:call-template>
          </li>
        </xsl:if>
        <xsl:call-template name="mir-breadcrumb-parentli">
          <xsl:with-param name="parentID" select="$mods/mods:relatedItem[@type='host']/@xlink:href"/>
        </xsl:call-template>
        <li class="active">
          <xsl:variable name="completeTitle">
            <xsl:apply-templates select="$mods" mode="mods.title" />
          </xsl:variable>
          <xsl:value-of select="mcrxml:shortenText($completeTitle,70)" />
        </li>
      </ul>
    </div>
    <xsl:apply-imports />
  </xsl:template>
  
  <xsl:template name="mir-breadcrumb-parentli">
    <xsl:param name="parentID" />
    <xsl:if test="$parentID">
      <xsl:variable name="parentID2" select="document(concat('mcrobject:',$parentID))/mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/mods:relatedItem[@type='host']/@xlink:href"/>
      <xsl:call-template name="mir-breadcrumb-parentli">
        <xsl:with-param name="parentID" select="$parentID2"/>
      </xsl:call-template>
      <li>
        <xsl:call-template name="objectLink">
          <xsl:with-param select="$parentID" name="obj_id" />
        </xsl:call-template>
      </li>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>