<?xml version="1.0" encoding="utf-8"?>
  <!-- ============================================== -->
  <!-- $Revision$ $Date$ -->
  <!-- ============================================== -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:basket="xalan://org.mycore.frontend.basket.MCRBasketManager" xmlns:mcr="http://www.mycore.org/" xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:actionmapping="xalan://org.mycore.wfc.actionmapping.MCRURLRetriever" xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
  xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions" exclude-result-prefixes="xlink basket actionmapping mcr mcrver mcrxsl i18n">
  <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" omit-xml-declaration="yes" media-type="text/html"
    version="5" />
  <xsl:strip-space elements="*" />
  <xsl:include href="resource:xsl/mir-flatmir-layout-utils.xsl"/>
  <xsl:param name="MIR.DefaultLayout.CSS" select="'flatly.min'" />
  <xsl:param name="MIR.CustomLayout.CSS" select="''" />
  <!-- Various versions -->
  <xsl:variable name="bootstrap.version" select="'3.2.0'" />
  <xsl:variable name="bootswatch.version" select="$bootstrap.version" />
  <xsl:variable name="fontawesome.version" select="'4.0.3'" />
  <xsl:variable name="jquery.version" select="'1.11.0'" />
  <xsl:variable name="jquery.migrate.version" select="'1.2.1'" />
  <!-- End of various versions -->
  <xsl:variable name="PageTitle" select="/*/@title" />
  <xsl:template match="/site">
    <html lang="{$CurrentLang}" class="no-js">
      <head>
        <meta charset="utf-8" />
        <title>
          <xsl:value-of select="$PageTitle" />
        </title>
        <xsl:comment>
          Mobile viewport optimisation
        </xsl:comment>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="//netdna.bootstrapcdn.com/font-awesome/{$fontawesome.version}/css/font-awesome.min.css" rel="stylesheet" />
        <link href="{$WebApplicationBaseURL}mir-flatmir-layout/css/{$MIR.DefaultLayout.CSS}.css" rel="stylesheet" />
        <xsl:if test="string-length($MIR.CustomLayout.CSS) &gt; 0">
          <link href="{$WebApplicationBaseURL}css/{$MIR.CustomLayout.CSS}" rel="stylesheet" />
        </xsl:if>
        <script type="text/javascript" src="//code.jquery.com/jquery-{$jquery.version}.min.js"></script>
        <script type="text/javascript" src="//code.jquery.com/jquery-migrate-{$jquery.migrate.version}.min.js"></script>
      </head>

      <body>

        <header>
            <xsl:call-template name="mir.navigation" />
        </header>

        <!-- show only on startpage -->
        <xsl:if test="//div/@class='jumbotwo'">
          <div class="jumboHome">
              <div class="container">
                  <div class="col-md-6">
                      <h1><img alt="&lt;intR>²Dok [§]" class="intR2Dok_logo" title="IntR2Dok - Logo" src="images/logo_intR2Dok.png" /></h1>
                  </div>
                  <div class="col-md-6">
                      <h2>Fachinformationsdienst für <br />internationale und interdisziplinäre<br /> Rechtsforschung</h2>
                  </div>
              </div>
          </div>
        </xsl:if>

        <div class="container" id="page">
          <div class="row">
            <div class="col-md-12" id="main_content">
              <xsl:call-template name="print.writeProtectionMessage" />
              <xsl:choose>
                <xsl:when test="$readAccess='true'">
                  <xsl:copy-of select="*" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="printNotLoggedIn" />
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
        </div>

        <footer class="panel-footer flatmir-footer" role="contentinfo">
          <div class="container">
            <div class="row">
              <div class="col-md-2">
                <h4>Über uns</h4>
                <ul class="internal_links">
                  <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='brand']/*" />
                </ul>
              </div>
              <div class="col-md-2">
                <h4>Rechtliches</h4>
                <ul class="internal_links">
                  <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='rights']/*" />
                </ul>
              </div>
              <div class="col-md-2">
                <h4>Technisches</h4>
                <ul class="internal_links">
                  <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='technical']/*" />
                </ul>
              </div>
              <div class="col-md-2">
                <h4>Soziales</h4>
                <ul class="social_links">
                    <li><a href="http://twitter.com/vifarecht"><img src="{$WebApplicationBaseURL}/content/images/logo_twitter.png" style="margin-right:5px;float:left;" />#vifarecht</a></li>
                    <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='social']/*" />
                </ul>
              </div>
              <div class="col-md-4">
                <h4>Institutionelles</h4>
                <ul class="internal_links">
                  <li><a href="http://www.staatsbibliothek-berlin.de/"><img style="margin:0 0 10px 27px;" src="{$WebApplicationBaseURL}/content/images/logo_sbb.png" /></a></li>
                  <li><a href="http://dfg.de/"><img style="margin:0 0 10px 0px;" src="{$WebApplicationBaseURL}/content/images/logo_dfg.png" /></a></li>
                  <li><a href="http://www.open-access.net/"><img style="margin:0 0 0px 10px;" src="{$WebApplicationBaseURL}/content/images/logo_oa.png" /></a></li>
                </ul>
              </div>
            </div>
            <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
            <div class="row">
              <div id="powered_by"  class="pull-right"><a href="http://www.mycore.de"><img title="{$mcr_version}" src="{$WebApplicationBaseURL}mir-flatmir-layout/images/mycore_logo_small_invert.png" /></a></div>
              <!-- div id="mcr_version"><xsl:value-of select="$mcr_version" /></div -->
            </div>
          </div>
        </footer>

        <script type="text/javascript">
          <!-- Bootstrap & Query-Ui button conflict workaround  -->
          if (jQuery.fn.button){jQuery.fn.btn = jQuery.fn.button.noConflict();}
        </script>
        <script type="text/javascript" src="//netdna.bootstrapcdn.com/bootstrap/{$bootstrap.version}/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="{$WebApplicationBaseURL}js/jquery.confirm.min.js"></script>
        <script type="text/javascript" src="{$WebApplicationBaseURL}js/mir/base.js"></script>
        <script>
          $( document ).ready(function() {
            $('.overtext').tooltip();
            $.confirm.options = {
              text: "<xsl:value-of select="i18n:translate('mir.confirm.text')" />",
              title: "<xsl:value-of select="i18n:translate('mir.confirm.title')" />",
              confirmButton: "<xsl:value-of select="i18n:translate('mir.confirm.confirmButton')" />",
              cancelButton: "<xsl:value-of select="i18n:translate('mir.confirm.cancelButton')" />",
              post: false
            }
          });
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
