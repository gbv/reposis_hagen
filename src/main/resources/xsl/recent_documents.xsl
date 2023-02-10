<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
                xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
                exclude-result-prefixes="">

  <xsl:variable name="Find">
    <xsl:copy-of select="concat('../servlets/solr/', 'find')"/>
    <!-- does not work atm -->
    <!--  xsl:choose>
      <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
        <xsl:copy-of select="concat('../servlets/solr/', 'find')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="concat('../servlets/solr/', 'findPublic')" />
      </xsl:otherwise>
    </xsl:choose -->
  </xsl:variable>

  <xsl:template match="recent_documents">
    <div class="result_list">
      <div id="hit_list">
        <xsl:copy-of select="document('xslStyle:response2html:xslTransform:response-prepared:solr:q=state:published AND objectType:mods&amp;rows=5&amp;start=0&amp;sort=created+desc')/div/*" />
      </div>
    </div>
    <div class="text-center">
      <a href="{$Find}" class="btn btn-primary btn-sm">
        <xsl:value-of select="i18n:translate('index.button.furtherPublications')"/>
      </a>
    </div>
  </xsl:template>

</xsl:stylesheet>