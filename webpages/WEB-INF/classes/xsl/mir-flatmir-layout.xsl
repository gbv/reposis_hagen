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
  <xsl:param name="MIR.CustomLayout.JS" select="''" />
  <xsl:param name="MIR.Layout.Theme" select="'flatmir'" />

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
        <link href="{$WebApplicationBaseURL}assets/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
        <script type="text/javascript" src="{$WebApplicationBaseURL}mir-layout/assets/jquery/jquery.min.js"></script>
        <script type="text/javascript" src="{$WebApplicationBaseURL}mir-layout/assets/jquery/plugins/jquery-migrate/jquery-migrate.min.js"></script>
        <xsl:copy-of select="head/*" />
        <link href="{$WebApplicationBaseURL}mir-layout/css/{$MIR.Layout.Theme}/{$MIR.DefaultLayout.CSS}.css" rel="stylesheet" />
        <xsl:if test="string-length($MIR.CustomLayout.CSS) &gt; 0">
          <link href="{$WebApplicationBaseURL}css/{$MIR.CustomLayout.CSS}" rel="stylesheet" />
        </xsl:if>
        <xsl:if test="string-length($MIR.CustomLayout.JS) &gt; 0">
          <script type="text/javascript" src="{$WebApplicationBaseURL}js/{$MIR.CustomLayout.JS}"></script>
        </xsl:if>
        <xsl:call-template name="mir.prop4js" />
        <link href="{$WebApplicationBaseURL}/editor/bootstrap-datetimepicker.min.css" rel="stylesheet" />
      </head>

      <body>

        <header>
            <xsl:call-template name="mir.navigation" />
        </header>

        <!-- show only on startpage -->
        <!-- 
        <xsl:if test="//div/@class='jumbotwo'">
          <div class="jumboHome">
              <div class="container">
                  <div class="hidden-xs col-sm-offset-1 col-sm-4 col-md-4 col-md-offset-1"> 
                      <h1><img alt="FU Hagen" class="img-responsive" title="FU Hagen- Logo" src="images/feulogo.png" /></h1>
                  </div>
                  <div class="col-xs-10 col-xs-offset-1 col-sm-offset-1 col-sm-4 col-md-4 col-md-offset-1"> 
                      <h1><img alt="deposit_hagen" class="img-responsive" title="desposit_hagen- Logo" src="images/deposit_hagen_logo_gross.png" /></h1>
                  </div>
              </div>
          </div>
          <div class="clearfix visible-xs-block visible-sm-block"></div> 
        </xsl:if> -->

        <div class="container" id="page">
          <div id="main_content">
            <xsl:call-template name="print.writeProtectionMessage" />
            <xsl:choose>
              <xsl:when test="$readAccess='true'">
                <xsl:copy-of select="*[not(name()='head')]" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="printNotLoggedIn" />
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </div>

        <footer class="panel-footer flatmir-footer" role="contentinfo">
          <div class="container">
            <div class="row">
              <div class="col-md-2 col-xs-6 col-sm-3">
                <h4>Über uns</h4>
                <ul class="internal_links">
                  <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='brand']/*" />
                </ul>
              </div>
              <div class="col-md-2 col-xs-6 col-sm-3">
                <h4>Rechtliches</h4>
                <ul class="internal_links">
                  <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='rights']/*" />
                </ul>
              </div>
              <div class="col-md-2 col-xs-6 col-sm-3">
                <h4>Kontakt</h4>
                <ul class="social_links">
                    <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='contact']/*" />
                </ul>
              </div>
              <div class="col-md-2 col-xs-6 col-sm-3">
                <h4>Technisches</h4>
                <ul class="internal_links">
                  <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='technical']/*" />
                </ul>
              </div>
              <div class="col-md-4 col-xs-12 col-sm-12">
                <img id="fuhagenlogo" alt="FU Hagen" class="img-responsive center-block" title="FU Hagen- Logo" src="{$WebApplicationBaseURL}content/images/FeULogoWT.png" />
              </div>
            </div>
          </div>
        </footer>
        
        <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
        <div id="powered_by">
          <a href="http://www.mycore.de">
            <img src="{$WebApplicationBaseURL}content/images/mycore_logo.png" title="{$mcr_version}" alt="powered by MyCoRe" />
          </a>
          <a href="http://www.gbv.de">
            <img src="{$WebApplicationBaseURL}content/images/vzgLogo.png" alt="hosted by VZG" />
          </a>
        </div>

        <script type="text/javascript">
          <!-- Bootstrap & Query-Ui button conflict workaround  -->
          if (jQuery.fn.button){jQuery.fn.btn = jQuery.fn.button.noConflict();}
        </script>
        <script type="text/javascript" src="{$WebApplicationBaseURL}webjars/bootstrap/{$bootstrap.version}/js/bootstrap.min.js"></script>
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
        <!-- alco add placeholder for older browser -->
        <script src="{$WebApplicationBaseURL}js/jquery.placeholder.min.js"></script>
        <script>
          jQuery("input[placeholder]").placeholder();
          jQuery("textarea[placeholder]").placeholder();
        </script>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="/*[not(local-name()='site')]">
    <xsl:message terminate="yes">This is not a site document, fix your properties.</xsl:message>
  </xsl:template>
</xsl:stylesheet>