<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="i18n mods xlink">
  <xsl:import href="xslImport:modsmeta:metadata/mir-abstract.xsl" />
  <xsl:template match="/">
    <xsl:variable name="mods" select="mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods" />
    <div id="mir-abstract">
        <xsl:variable name="dateIssued">
          <xsl:apply-templates mode="mods.datePublished" select="$mods" />
        </xsl:variable>
        <!-- TODO: Update badges -->
        <div class="badges_block">
          <div id="badges" class="text-left">
            <xsl:call-template name="categorySearchLink">
              <xsl:with-param name="class" select="'mods_genre label label-info'" />
              <xsl:with-param name="node" select="($mods/mods:genre[@type='kindof']|$mods/mods:genre[@type='intern'])[1]" />
            </xsl:call-template>

            <time itemprop="datePublished" datetime="{$dateIssued}" data-toggle="tooltip" title="Publication date">
              <span class="date_published label label-primary">
                <xsl:variable name="format">
                  <xsl:choose>
                    <xsl:when test="string-length(normalize-space($dateIssued))=4">
                      <xsl:value-of select="i18n:translate('metaData.dateYear')" />
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space($dateIssued))=7">
                      <xsl:value-of select="i18n:translate('metaData.dateYearMonth')" />
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space($dateIssued))=10">
                      <xsl:value-of select="i18n:translate('metaData.dateYearMonthDay')" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="i18n:translate('metaData.dateTime')" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="formatISODate">
                  <xsl:with-param name="date" select="$dateIssued" />
                  <xsl:with-param name="format" select="$format" />
                </xsl:call-template>
              </span>
            </time>
          </div>
          
          <xsl:variable name="objectRights" select="key('rights', mycoreobject/@ID)" />
	      <xsl:variable name="write" select="boolean($objectRights/@write)" />
	      <xsl:variable name="delete" select="boolean($objectRights/@delete)" />
	      <div class="mir-edit text-right">
	        <!-- Start: EDIT -->
	        <xsl:apply-templates select="mycoreobject" mode="objectActions">
	          <xsl:with-param name="accessedit" select="$write" />
	          <xsl:with-param name="accessdelete" select="$delete" />
	          <xsl:with-param name="mods-type" select="$mods-type" />
	          <!-- xsl:with-param name="collection" select="'mods'" / --> <!-- TODO: We have to fix this in next mycore release -->
	        </xsl:apply-templates>
            <!-- End: EDIT -->
          </div>
        </div>
      
      <h1 itemprop="name"> 
        <xsl:apply-templates mode="mods.title" select="$mods" />
        <xsl:if test="$mods/mods:titleInfo[1]/mods:subTitle">
          <span class="subtitle">
            : <xsl:apply-templates mode="mods.subtitle" select="$mods" />
          </span>
        </xsl:if>
      </h1>
      <p id="authors_short">
        <xsl:for-each select="$mods/mods:name[mods:role/mods:roleTerm/text()='aut']">
          <xsl:if test="position()!=1">
            <xsl:value-of select="'; '" />
          </xsl:if>
          <xsl:apply-templates select="." mode="authors_short" />
        </xsl:for-each>
      </p>
      <p>
        <span itemprop="description">
          <xsl:value-of select="$mods/mods:abstract" />
        </span>
      </p>
      <table class="children">
        <xsl:if test="mycoreobject/structure/children/child">
          <xsl:apply-templates mode="printChildren" select="mycoreobject/structure/children">
            <xsl:with-param name="label" select="i18n:translate('component.mods.metaData.dictionary.contains')" />
          </xsl:apply-templates>
        </xsl:if>

        <!-- check for relatedItem type!="host" and containing mycoreobject ID using solr query on field mods.relatedItem -->
        <xsl:variable name="hits"
                      xmlns:encoder="xalan://java.net.URLEncoder"
                      select="document(concat('solr:q=',encoder:encode(concat('mods.relatedItem:', mycoreobject/@ID, '* AND NOT(mods.relatedItem:*|host)'))))/response/result" />
        <xsl:if test="count($hits/doc) &gt; 0">
          <tr>
            <td valign="top" class="metaname">
              <xsl:value-of select="concat(i18n:translate('component.mods.metaData.dictionary.contains'),':')" />
            </td>
            <td class="metavalue">
              <ul>
                <xsl:for-each select="$hits/doc">
                  <li>
                    <xsl:call-template name="objectLink">
                      <xsl:with-param name="obj_id" select="str[@name='returnId']" />
                    </xsl:call-template>
                  </li>
                </xsl:for-each>
              </ul>
            </td>
          </tr>
        </xsl:if>

      </table>
    </div>
    <xsl:apply-imports />
  </xsl:template>

  <xsl:template match="mods:name" mode="authors_short">
    <!-- TODO: Link to search? -->
    <xsl:variable name="gnd">
      <xsl:if test="starts-with(@valueURI, 'http://d-nb.info/gnd/')">
        <xsl:value-of select="substring-after(@valueURI, 'http://d-nb.info/gnd/')" />
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="query">
      <xsl:choose>
        <xsl:when test="string-length($gnd)&gt;0">
          <xsl:value-of select="concat($ServletsBaseURL,'solr/mods_gnd?q=',$gnd)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($ServletsBaseURL,'solr/find?qry=')" />
          <xsl:value-of select="concat('+mods.author:&quot;',mods:displayForm,'&quot;')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <a itemprop="creator" href="{$query}">
      <span itemscope="itemscope" itemtype="http://schema.org/Person">
        <span itemprop="name">
          <xsl:value-of select="mods:displayForm" />
        </span>
        <xsl:if test="string-length($gnd)&gt;0">
          <xsl:text>&#160;</xsl:text><!-- add whitespace here -->
          <a href="http://d-nb.info/gnd/{$gnd}" title="Link zur GND">
            <sup>GND</sup>
          </a>
        </xsl:if>
      </span>
    </a>
  </xsl:template>

</xsl:stylesheet>