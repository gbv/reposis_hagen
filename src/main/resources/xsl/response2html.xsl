<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  exclude-result-prefixes="">

  <xsl:include href="layout-utils.xsl" />
  <xsl:include href="response-utils.xsl" />
  <xsl:include href="xslInclude:solrResponse" />

  <xsl:variable name="Select">
    <xsl:choose>
      <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin') or mcrxsl:isCurrentUserInRole('submitter')">
        <xsl:copy-of select="concat('servlets/solr/', 'select')"/> 
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="concat('servlets/solr/', 'selectPublic')" /> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Changed from find to select in order to work properly with the dashboard-->
  <xsl:param name="proxyBaseURL" select="concat($WebApplicationBaseURL, $Select)" />

  <xsl:template match="/">
    <div>
      <xsl:apply-templates select="/response/result/doc" mode="resultList" />
    </div>
  </xsl:template>

</xsl:stylesheet>