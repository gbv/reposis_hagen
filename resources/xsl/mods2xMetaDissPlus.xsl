<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================== -->
<!-- $Revision: 1.8 $ $Date: 2007-04-20 15:18:23 $ -->
<!-- ============================================== -->
<xsl:stylesheet 
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:exslt="http://exslt.org/common"
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:mcrurn="xalan://org.mycore.urn.MCRXMLFunctions"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:piUtil="xalan://org.mycore.mir.pi.MCRPIUtil"
  xmlns:xalan="http://xml.apache.org/xalan"

  xmlns:cmd="http://www.cdlib.org/inside/diglib/copyrightMD"
  xmlns:gndo="http://d-nb.info/standards/elementset/gnd#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:xMetaDiss="http://www.d-nb.de/standards/xmetadissplus/"
  xmlns:cc="http://www.d-nb.de/standards/cc/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcmitype="http://purl.org/dc/dcmitype/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:pc="http://www.d-nb.de/standards/pc/"
  xmlns:urn="http://www.d-nb.de/standards/urn/"
  xmlns:thesis="http://www.ndltd.org/standards/metadata/etdms/1.0/"
  xmlns:ddb="http://www.d-nb.de/standards/ddb/"
  xmlns:dini="http://www.d-nb.de/standards/xmetadissplus/type/"
  xmlns:sub="http://www.d-nb.de/standards/subject/"

  exclude-result-prefixes="xalan mcrxsl mcrurn cc dc dcmitype dcterms pc urn thesis ddb dini xlink exslt mods i18n xsl gndo rdf cmd piUtil"
  xsi:schemaLocation="http://www.d-nb.de/standards/xmetadissplus/  http://files.dnb.de/standards/xmetadissplus/xmetadissplus.xsd">

  <xsl:include href="mods2xMetaDissPlus_Original.xsl" />
  
  <xsl:param name="MCR.URN.SubNamespace.Default.Prefix" select="''" />
  
  <xsl:template mode="publisher" match="mods:mods">
    <xsl:variable name="publisherRoles" select="$marcrelator/mycoreclass/categories/category[@ID='pbl']/descendant-or-self::category" />
    <xsl:variable name="publisher_name">
      <xsl:choose>
        <xsl:when test="mods:originInfo[not(@eventType) or @eventType='publication']/mods:publisher">
          <xsl:value-of select="mods:originInfo[not(@eventType) or @eventType='publication']/mods:publisher" />
        </xsl:when>
        <xsl:when test="mods:name[$publisherRoles/@ID=mods:role/mods:roleTerm/text()]">
          <xsl:value-of select="mods:name[mods:role/mods:roleTerm/text()='pbl']/mods:displayForm" />
        </xsl:when>
        <xsl:when test="mods:accessCondition[@type='copyrightMD']/cmd:copyright/cmd:rights.holder/cmd:name">
          <xsl:value-of select="mods:accessCondition[@type='copyrightMD']/cmd:copyright/cmd:rights.holder/cmd:name" />
        </xsl:when>
        <xsl:when test="mods:relatedItem[@type='host']/mods:originInfo[not(@eventType) or @eventType='publication']/mods:publisher">
          <xsl:value-of
            select="mods:mods/mods:relatedItem[@type='host']/mods:originInfo[not(@eventType) or @eventType='publication']/mods:publisher" />
        </xsl:when>
        <xsl:when test="mods:relatedItem[@type='host']/mods:name[mods:role/mods:roleTerm/text()='pbl']">
          <xsl:value-of select="mods:relatedItem[@type='host']/mods:name[mods:role/mods:roleTerm/text()='pbl']/mods:displayForm" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="publisher_place">
      <xsl:choose>
        <xsl:when test="mods:originInfo[not(@eventType) or @eventType='publication']/mods:place/mods:placeTerm[@type='text']">
          <xsl:value-of select="mods:originInfo[not(@eventType) or @eventType='publication']/mods:place/mods:placeTerm[@type='text']" />
        </xsl:when>
        <xsl:when
          test="mods:relatedItem[@type='host']/mods:originInfo[not(@eventType) or @eventType='publication']/mods:place/mods:placeTerm[@type='text']">
          <xsl:value-of
            select="mods:relatedItem[@type='host']/mods:originInfo[not(@eventType) or @eventType='publication']/mods:place/mods:placeTerm[@type='text']" />
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="string-length($publisher_name) &gt; 0">
      <xsl:choose>
        <xsl:when test="contains($publisher_name,'FernUniversit') or contains($publisher_name,'Fernuniversit') ">
        </xsl:when>
        <xsl:when test="string-length($publisher_place) &gt; 0">
          <dc:source xsi:type="ddb:noScheme">
            <xsl:value-of select="concat($publisher_place,' : ',$publisher_name)" />
          </dc:source>
        </xsl:when>
        <xsl:otherwise>
          <dc:source xsi:type="ddb:noScheme">
            <xsl:value-of select="$publisher_name" />
          </dc:source>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <xsl:template mode="identifier" match="mods:mods">
    <xsl:choose>
      <xsl:when test="mods:identifier[@type='doi']">
        <dc:identifier xsi:type="doi:doi">
          <xsl:value-of select="mods:identifier[@type='doi'][1]" />
        </dc:identifier>
      </xsl:when>
      <xsl:when test="mods:identifier[@type='hdl' or @type='handle']">
        <dc:identifier xsi:type="hdl:hdl">
          <xsl:value-of select="mods:identifier[@type='hdl' or @type='handle'][1]" />
        </dc:identifier>
      </xsl:when> 
    </xsl:choose>
    <xsl:variable name="piServiceInformation" select="piUtil:getPIServiceInformation(/mycoreobject/@ID)" />
    <xsl:if test="$piServiceInformation[@type='dnbUrn'][@inscribed='true']">
      <xsl:element name="dc:identifier">
        <xsl:attribute name="xsi:type">urn:nbn</xsl:attribute>
        <xsl:value-of select="//mods:mods/mods:identifier[@type='urn']" />
      </xsl:element>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
