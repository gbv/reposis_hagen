<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mcrxml="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:math="http://exslt.org/math"
  xmlns:mcrdataurl="xalan://org.mycore.datamodel.common.MCRDataURL">

  <xsl:include href="copynodes.xsl" />
  <xsl:include href="editor/mods-node-utils.xsl" />
  <xsl:include href="mods-utils.xsl"/>
  <xsl:include href="coreFunctions.xsl"/>

  <xsl:template match="mods:mods">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates />
      
    </xsl:copy>
  </xsl:template>

  <xsl:template match="mods:accessCondition[@xlink:href='http://www.mycore.org/classifications/mir_access#']">
  </xsl:template>

</xsl:stylesheet>