<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" xmlns:ex="http://exslt.org/dates-and-times" exclude-result-prefixes="mods mcrxsl i18n ex"
>
  <xsl:include href="layout-utils.xsl" />
  
  <xsl:param name="MIR.oas" select="'hide'" />
  <xsl:param name="MIR.oas.graph" select="'hide'" />

  

  <xsl:template match="/site">
    <xsl:copy>
      <head>
        <xsl:apply-templates select="citation_meta" mode="copyContent" />
        <link href="{$WebApplicationBaseURL}assets/jquery/plugins/shariff/shariff.min.css" rel="stylesheet" />
        <script type="text/javascript" src="{$WebApplicationBaseURL}assets/jquery/plugins/dotdotdot/jquery.dotdotdot.min.js" />
      </head>

      <xsl:if test="div[@id='mir-breadcrumb']">
        <breadcrumb>
          <xsl:copy-of select="div[@id='mir-breadcrumb']/*" />
        </breadcrumb>
      </xsl:if>

      <xsl:if test="div[@id='search_browsing']">
        <div class="row detail_row" id="mir-search_browsing">
          <div class="col-md-8">
            <div class="detail_block text-center">
              <span id="pagination_label">gefundende Dokumente</span>
              <br />
              <!-- Start: PAGINATION -->
              <xsl:apply-templates select="div[@id='search_browsing']" mode="copyContent" />
              <!-- End: PAGINATION -->
            </div>
          </div>
        </div>
      </xsl:if>

      <!-- Start: MESSAGE -->
      <xsl:if test="div[@id='mir-message']">
        <div class="row detail_row">
          <div class="col-md-12">
            <xsl:copy-of select="div[@id='mir-message']/*" />
          </div>
        </div>
      </xsl:if>
      <!-- End: MESSAGE -->

      <div class="row detail_row" itemscope="itemscope" itemtype="http://schema.org/ScholarlyArticle">

        <div id="head_col" class="col-xs-12">
          <div class="row">
            <div id="aux_col_actions" class="col-xs-12 col-sm-4 col-sm-push-8 col-md-4 col-md-push-8">
              <div class="pull-right">
                <!-- Start: EDIT -->
                <xsl:apply-templates select="div[@id='mir-edit']" mode="copyContent" />
                <!-- End: EDIT -->
              </div>
            </div>
            <div class="col-xs-12 col-sm-8 col-sm-pull-4 col-md-8 col-md-pull-4">
              <xsl:apply-templates select="div[@id='mir-abstract-badges']" mode="copyContent" />
            </div>
          </div>
        </div>

        <div id="main_col" class="col-xs-12 col-sm-8">
          <div id="headline">
            <xsl:apply-templates select="div[@id='mir-abstract-title']" mode="copyContent" />
          </div>
          <div class="detail_block">
          <!-- Start: ABSTRACT -->
            <xsl:apply-templates select="div[@id='mir-abstract-plus']" mode="copyContent" />
          <!-- End: ABSTRACT -->
          </div>

          <!-- viewer -->
          <xsl:if test="div[@id = 'mir-viewer']">
            <xsl:apply-templates select="div[@id='mir-viewer']" mode="copyContent" />
          </xsl:if>
          <!-- player -->
          <xsl:if test="div[@id = 'mir-player']">
            <xsl:apply-templates select="div[@id='mir-player']" mode="copyContent" />
          </xsl:if>
          <!-- files -->
          <xsl:if test="div[contains(@id,'mir-collapse-')]">
            <div class="detail_block">
              <div class="" id="record_detail">
                <xsl:apply-templates select="div[@id='mir-collapse-files']" mode="copyContent" />
              </div>
            </div>
          </xsl:if>

<!-- metadata -->
          <xsl:if test="div[contains(@id,'mir-metadata')]/table[@class='mir-metadata']/tr">
            <div class="mir_metadata">
              <h3>
                <xsl:value-of select="i18n:translate('component.mods.metaData.dictionary.categorybox')" />
              </h3>
            <!-- Start: METADATA -->
              <xsl:apply-templates select="div[@id='mir-metadata']" mode="newMetadata" />
            <!-- End: METADATA -->
              <xsl:if test="contains(div[@id='mir-metadata'], '°, ')">
                <script type="text/javascript" src="//www.openstreetmap.org/openlayers/OpenLayers.js"></script>
                <script type="text/javascript" src="//www.openstreetmap.org/openlayers/OpenStreetMap.js"></script>
                <script type="text/javascript" src="{$WebApplicationBaseURL}js/mir/geo-coords.js"></script>
              </xsl:if>
            </div>
          </xsl:if>
<!-- OAS statistics -->
          <xsl:if test="$MIR.oas.graph = 'show'">  
            <div class="mir_metadata">
              <h3>Zugriffsstatistik</h3>
              <div>
                <!-- Start: OAS -->
                <iframe style="width: 100%;border-width: 0px;height: 220px;" src="https://ub-deposit.fernuni-hagen.de/graphprovider/index.php?identifier=oai%3Aub-deposit.fernuni-hagen.de%3Amir_mods_00000008&amp;from=2016-01-01&amp;until=2016-12-31" />
                <!-- End: OAS -->
              </div>
              
              <script src="/graphprovider/includes/morris.js-0.5.1/morris.min.js"></script>
              <script src="/graphprovider/includes/raphael-2.1.2/raphael-min.js"></script>
              <script src="/graphprovider/includes/jquery-ui-1.11.2/jquery-ui.js"></script>
              <script src="/graphprovider/includes/oawidget.js"></script>
              <div id="oas__statistics"/>
              <script>
                 $(document).ready(function() { $( "#oas__statistics ").barchart({
                                                                 from: "2014-10-12",
                                                                 jsonloader: "/graphprovider/jsonloader.php",
                                                                 identifier: "oai:ub-deposit.fernuni-hagen.de:mir_mods_00000008",
                                                                 statisticsToggleable: true,
                                                                 showCounterAbst: false,
                                                                 showRobots: true,
                                                                 showRobotsAbst: true,
                                                                 granularityEditable: false,
                                                                 timespanEditable: false,
                                                                 granularityStandard: "week"
                                                                });

                                                                //alert(JSON.stringify($._data( $("#content")[0], "events" )));

                                     } );
                
              </script> 
            </div>
          </xsl:if>         

<!-- end: left column -->
        </div>

<!-- right column -->
        <div id="aux_col" class="col-xs-12 col-sm-4">

<!-- cites -->
          <xsl:if test="div[@id='mir-citation']">
            <div class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">Zitieren</h3>
              </div>
              <div class="panel-body">
                <!-- Start: CITATION -->
                <xsl:apply-templates select="div[@id='mir-citation']" mode="copyContent" />
                <!-- End: CITATION -->
              </div>
            </div>
          </xsl:if>
<!-- OAS statistics -->
          <xsl:if test="$MIR.oas = 'show'">  
            <div class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">Zugriffsstatistik</h3>
              </div>
              <div class="panel-body">
                <!-- Start: OAS -->
                <xsl:variable name="now" select="ex:date-time()"/>
                <xsl:variable name="now-1year">
                  <xsl:choose>
                    <xsl:when test="ex:monthInYear($now)=12">
                      <xsl:value-of select="ex:year($now)" />-01
                    </xsl:when>
                    <xsl:when test="ex:monthInYear($now)=11 or ex:monthInYear($now)=10">
                      <xsl:value-of select="ex:year($now)-1" />-<xsl:value-of select="ex:monthInYear($now)+1" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="ex:year($now)-1" />-0<xsl:value-of select="ex:monthInYear($now)+1" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>  
                <xsl:value-of select="ex:format-date($now,'yyyy-MM')" />
                <xsl:value-of select="$now-1year" /> 
                <xsl:variable name="statistics" select="document('https://ub-deposit.fernuni-hagen.de/graphprovider/jsonloader.php?identifier=oai:ub-deposit.fernuni-hagen.de:mir_mods_00000008&amp;from=2016-01-01&amp;until=2016-03-31&amp;formatExtension=xml&amp;granularity=total')"/>
                <xsl:value-of select="$statistics/report/entries/entry/access/type" />
                <!-- <xsl:value-of select="$statistics/report/entries/entry/access/type[text()='counter']/../count"/> -->
                <!-- End: OAS -->
              </div>
            </div>
          </xsl:if>
<!-- rights -->
          <xsl:if test="div[@id='mir-access-rights']">
            <div id="mir_access_rights_panel" class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">Rechte</h3>
              </div>
              <div class="panel-body">
                <!-- Start: CITATION -->
                <xsl:apply-templates select="div[@id='mir-access-rights']" mode="copyContent" />
                <!-- End: CITATION -->
              </div>
            </div>
          </xsl:if>
<!-- export -->
          <xsl:if test="div[@id='mir-export']">
            <div id="mir_export_panel" class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">Export</h3>
              </div>
              <div class="panel-body">
                  <!-- Start: EXPORT -->
                <xsl:apply-templates select="div[@id='mir-export']" mode="copyContent" />
                  <!-- End: EXPORT -->
              </div>
            </div>
          </xsl:if>
<!-- system -->
          <xsl:if test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
            <div id="mir_admindata_panel" class="panel panel-default system">
              <div class="panel-heading">
                <h3 class="panel-title">
                  <xsl:value-of select="i18n:translate('component.mods.metaData.dictionary.systembox')" />
                </h3>
              </div>
              <div class="panel-body">
                <!-- Start: ADMINMETADATA -->
                <xsl:apply-templates select="div[@id='mir-admindata']" mode="newMetadata" />
                <!-- End: ADMINMETADATA -->
              </div>
              <div class="modal fade" id="historyModal" tabindex="-1" role="dialog" aria-labelledby="modal frame" aria-hidden="true">
                <div class="modal-dialog" style="width: 930px">
                  <div class="modal-content">
                    <div class="modal-header">
                      <button type="button" class="close modalFrame-cancel" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">x</span>
                      </button>
                      <h4 class="modal-title" id="modalFrame-title">
                        <xsl:value-of select="i18n:translate('metadata.versionInfo.label')" />
                      </h4>
                    </div>
                    <div id="modalFrame-body" class="modal-body" style="max-height: 560px; overflow: auto">
                      <xsl:apply-templates select="div[@id='mir-historydata']" mode="copyContent" />
                    </div>
                    <div class="modal-footer" style="clear: both">
                      <button id="modalFrame-cancel" type="button" class="btn btn-danger" data-dismiss="modal">
                        <xsl:value-of select="i18n:translate('button.cancel')" />
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </xsl:if>

<!-- end: right column -->
        </div>

<!--  end: detail row -->
      </div>
      <script src="{$WebApplicationBaseURL}assets/jquery/plugins/shariff/shariff.min.js"></script>
      <script src="{$WebApplicationBaseURL}assets/moment/moment.js"></script>
      <script src="{$WebApplicationBaseURL}assets/handlebars/handlebars.min.js"></script>
      <script src="{$WebApplicationBaseURL}js/mir/derivate-fileList.js"></script>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="citation_meta" mode="copyContent">
    <xsl:message>
      <xsl:value-of select="'Handling citation meta tags'" />
    </xsl:message>
    <xsl:copy-of select="./*" />
  </xsl:template>

  <xsl:template match="div" mode="copyContent">
    <xsl:message>
      <xsl:value-of select="concat('Handling div: ',@id)" />
    </xsl:message>
    <xsl:copy-of select="./*" />
  </xsl:template>

  <xsl:template match="div[@id='mir-metadata']" mode="newMetadata">
    <dl>
      <xsl:apply-templates select="table[@class='mir-metadata']/tr" mode="newMetadata" />
    </dl>
  </xsl:template>
  <xsl:template match="div[@id='mir-admindata']" mode="newMetadata">
    <dl>
      <xsl:apply-templates select=".//div[@id='system_box']/div[@id='system_content']/table/tr" mode="newMetadata" />
    </dl>
  </xsl:template>
  <xsl:template match="td[@class='metaname']" mode="newMetadata" priority="2">
    <dt>
      <xsl:copy-of select="node()|*" />
    </dt>
  </xsl:template>
  <xsl:template match="td[@class='metavalue']" mode="newMetadata" priority="2">
    <dd>
      <xsl:copy-of select="node()|*" />
    </dd>
  </xsl:template>

</xsl:stylesheet>