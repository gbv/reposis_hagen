<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mcrxml="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="mcrxml mods xlink">
  <xsl:import href="xslImport:modsmeta:metadata/mir-breadcrumbs.xsl" />
  <xsl:template match="/">
    <xsl:variable name="mods" select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods" />
    <div id="mir-breadcrumb">
      <ul class="breadcrumb" itemprop="breadcrumb">
        <li>
          <a href="{$WebApplicationBaseURL}">
            <svg xmlns="http://www.w3.org/2000/svg" width="23" height="23" fill="currentColor" class="bi bi-house-door-fill" viewBox="0 0 23 23">
              <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5Z"/>
            </svg>
          </a>
        </li>
        <xsl:if test="$mods/mods:relatedItem[@type='series']">
          <li>
            <span class="d-inline-block text-truncate" style="max-width: 300px;">
              /
              <xsl:call-template name="objectLink">
                <xsl:with-param select="$mods/mods:relatedItem[@type='series']/@xlink:href" name="obj_id" />
              </xsl:call-template>
            </span>
          </li>
        </xsl:if>
        <xsl:call-template name="mir-breadcrumb-parentli">
          <xsl:with-param name="parentID" select="$mods/mods:relatedItem[@type='host']/@xlink:href"/>
        </xsl:call-template>
        <li class="active">
          <span class="d-inline-block text-truncate" style="max-width: 300px;">
            /
            <xsl:variable name="completeTitle">
              <xsl:apply-templates select="$mods" mode="mods.title" />
            </xsl:variable>
            <xsl:value-of select="mcrxml:shortenText($completeTitle,70)" />
          </span>
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
        <span class="d-inline-block text-truncate" style="max-width: 300px;">
              /
          <xsl:call-template name="objectLink">
            <xsl:with-param select="$parentID" name="obj_id" />
          </xsl:call-template>
        </span>
      </li>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>