<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY html-output SYSTEM "xsl/xsl-output-html.fragment">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:encoder="xalan://java.net.URLEncoder"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" xmlns:xalan="http://xml.apache.org/xalan" xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions" exclude-result-prefixes="xalan i18n encoder">
  &html-output;
  <xsl:include href="MyCoReLayout.xsl" />
  <xsl:include href="response-utils.xsl" />
  <xsl:include href="xslInclude:solrResponse" />

  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="MCR.Results.FetchHit" />

  <xsl:decimal-format name="european" decimal-separator=',' grouping-separator='.' />

  <xsl:variable name="PageTitle">
    <xsl:value-of select="i18n:translate('component.solr.searchresult.resultList')" />
  </xsl:variable>

  <xsl:variable name="numFound">
    <xsl:choose>
      <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
        <xsl:value-of select="count(/response/lst[@name='terms']/lst[@name='mods.pindexname']/int)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(/response/lst[@name='terms']/lst[@name='mods.pindexname.published']/int)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="resultsText">
    <xsl:choose>
      <xsl:when test="$numFound=0">
        <xsl:value-of select="i18n:translate('pindex.noObject')" />
      </xsl:when>
      <xsl:when test="$numFound=1">
        <xsl:value-of select="i18n:translate('pindex.oneObject')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="i18n:translate('pindex.nObjects',format-number($numFound, '###.###', 'european'))" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="query" select="/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='terms.regex']" />

  <!-- retain the original query parameters, for attaching them to a url -->
  <xsl:variable name="params">
    <xsl:for-each select="./response/lst[@name='responseHeader']/lst[@name='params']/str[not(@name='start' or @name='rows')]">
      <!-- parameterName=parameterValue -->
      <xsl:value-of select="concat(@name,'=', encoder:encode(., 'UTF-8'))" />
      <xsl:if test="not (position() = last())">
        <xsl:value-of select="'&amp;'" />
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:template match="int">
    <xsl:variable name="gnd" select="substring-after(@name, ':')" />

    <xsl:variable name="name2">
      <xsl:choose>
        <xsl:when test="contains(@name, ' ')">
          <xsl:value-of select="concat(substring-before(@name, ' '),'\ ',substring-after(@name, ' '))" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="linkText">
      <xsl:choose>
        <xsl:when test="contains($name2, ':')">
          <xsl:value-of select="substring-before($name2, ':')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$name2" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- if user is in role editor or admin, show all; other users only gets their own and published publications -->
    <xsl:variable name="filter_query">
      <xsl:choose>
        <xsl:when test="mcrxsl:isCurrentUserInRole('admin') or mcrxsl:isCurrentUserInRole('editor')">state:*</xsl:when>
        <xsl:otherwise>state:published OR createdby:<xsl:value-of select="$CurrentUser" /></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="linkTo">
      <xsl:choose>
        <xsl:when test="string-length($gnd)>0">
          <xsl:value-of select="concat($ServletsBaseURL,'solr/select?q=mods.gnd:', $gnd, ' AND (', $filter_query, ')')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($ServletsBaseURL,'solr/select?q=')" />
          <xsl:value-of select="concat('+mods.pindexname:&quot;',$linkText,'&quot;')" />
          <xsl:value-of select="concat(' AND (', $filter_query, ')')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="toolTip">
      <xsl:choose>
        <xsl:when test="$gnd">
          <xsl:value-of select="$gnd" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$linkText" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <li>
      <a href="{$linkTo}" title="{$toolTip}">
        <xsl:value-of select="$linkText" />
      </a>
      <xsl:if test="string-length($gnd)>0">
        <a title="http://d-nb.info/gnd/{$gnd}" href="http://d-nb.info/gnd/{$gnd}">
          <sup>GND</sup>
        </a>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="/response">

    <xsl:variable name="a2z">
      <A search="[a|ä|Ä].*" />
      <B search="b.*" />
      <C search="c.*" />
      <D search="d.*" />
      <E search="e.*" />
      <F search="f.*" />
      <G search="g.*" />
      <H search="h.*" />
      <I search="i.*" />
      <J search="j.*" />
      <K search="k.*" />
      <L search="l.*" />
      <M search="m.*" />
      <N search="n.*" />
      <O search="[o|ö|Ö].*" />
      <P search="p.*" />
      <Q search="q.*" />
      <R search="r.*" />
      <S search="s.*" />
      <T search="t.*" />
      <U search="[u|ü|Ü].*" />
      <V search="v.*" />
      <W search="w.*" />
      <X search="x.*" />
      <Y search="y.*" />
      <Z search="z.*" />
    </xsl:variable>

    <div class="row">
      <div id="main_content" class="col-md-12">

        <div class="row">
          <div class="col-md-4">
            <h2><xsl:value-of select="i18n:translate('browse.person.foundPersons')" /></h2>

            <xsl:choose>
              <xsl:when test="lst[@name='terms']/lst[@name='mods.pindexname']/int or
                              lst[@name='terms']/lst[@name='mods.pindexname.published']/int">
                <!-- show results -->
                <ul id="resultList">
                  <xsl:choose>
                    <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
                      <xsl:apply-templates select="lst[@name='terms']/lst[@name='mods.pindexname']/int" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="lst[@name='terms']/lst[@name='mods.pindexname.published']/int" />
                    </xsl:otherwise>
                  </xsl:choose>
                </ul>
              </xsl:when>
              <xsl:otherwise>
                <p><xsl:value-of select="i18n:translate('browse.person.personNotFound')" /></p>
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="col-md-4">
            <h3><xsl:value-of select="i18n:translate('browse.person.firstLetter')" /></h3>
            <ul class="names">
              <xsl:for-each select="xalan:nodeset($a2z)/*">
                <li>
                  <xsl:if test="$query = @search">
                    <xsl:attribute name="class">active</xsl:attribute>
                  </xsl:if>
                  <a href="{concat($proxyBaseURL,$HttpSession, '?XSL.Style=person&amp;terms.regex=', @search)}">
                    <xsl:value-of select="name()" />
                  </a>
                  <xsl:if test="position() != last()">
                    <span> | </span>
                  </xsl:if>
                </li>
              </xsl:for-each>
            </ul>
          </div>

          <div class="col-md-4">
            <h3><xsl:value-of select="i18n:translate('browse.person.searchPerson')" /></h3>

            <form class="form-inline"
                  role="form"
                  id="index_search_form"
                  method="get"
                  action="{concat($proxyBaseURL,$HttpSession)}">
              <xsl:for-each
                select="lst[@name='responseHeader']/lst[@name='params']/str[not(@name='terms.regex')]">
                <input type="hidden" name="{@name}" value="{.}" />
              </xsl:for-each>

              <xsl:variable name="search_value">
                <xsl:choose>
                  <xsl:when test="xalan:nodeset($a2z)/*[@search=$query]">
                    <xsl:value-of select="''" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$query" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              
              <xsl:variable name="placeholder">
                <xsl:value-of select="i18n:translate('browse.person.searchplaceholder')" />
              </xsl:variable>

              <div class="form-group">
                <label class="sr-only" for="index_search">Gesuchte Zeichen</label>
                <input value="{$search_value}"
                       name="terms.regex"
                       class="search_text_gray focus_form_field form-control"
                       id="index_search"
                       type="text"
                       placeholder="{$placeholder}" />
              </div>
              <button type="submit"
                     class="btn btn-default search_button"
                     value="Suchen"
                     tabindex="1">
                <xsl:value-of select="i18n:translate('button.search')" />
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>

  </xsl:template>

</xsl:stylesheet>