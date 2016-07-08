<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:ex="http://exslt.org/dates-and-times" exclude-result-prefixes="i18n ex">

  <xsl:import href="xslImport:modsmeta:metadata/mir-oastatistics.xsl" />  
  
  <xsl:template match="/">
    <xsl:variable name="ID" select="/mycoreobject/@ID" />
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
    <xsl:variable name="from" select="$now-1year" />
    <xsl:variable name="until" select="ex:format-date($now,'yyyy-MM')" />
    <xsl:variable name="objID" select="mycoreobject/@ID" />
    <div id="mir-oastatistics">
      <div class="row">
        <h3 class="col-md-12">Gesamt</h3>
      </div>
      <div class="row">
        <div class="col-md-7 col-sm-9 col-xs-6 text-right"><xsl:value-of select="i18n:translate('mir.oas.counter.fulltext')" /></div>
        <div  data-oaselementtype="OASInline" 
            data-oasproviderurl="{$MIR.OAS.GraphProviderURL}" 
            data-oasidentifier="oai:ub-deposit.fernuni-hagen.de:{$objID}" 
            data-oascounttype="counter"
        />
      </div>
      <div class="row">
        <div class="col-md-7 col-sm-9 col-xs-6 text-right"><xsl:value-of select="i18n:translate('mir.oas.counter.abstract')" /></div>
        <div  data-oaselementtype="OASInline" 
            data-oasproviderurl="{$MIR.OAS.GraphProviderURL}" 
            data-oasidentifier="oai:ub-deposit.fernuni-hagen.de:{$objID}" 
            data-oascounttype="counter_abstract" 
        />
      </div>
      <div class="row">
        <h3 class="col-md-12">12 Monate</h3>
      </div>
      <div class="row">
        <div class="col-md-7 col-sm-9 col-xs-6 text-right"><xsl:value-of select="i18n:translate('mir.oas.counter.fulltext')" /></div>
        <div  data-oaselementtype="OASInline" 
            data-oasproviderurl="{$MIR.OAS.GraphProviderURL}" 
            data-oasidentifier="oai:ub-deposit.fernuni-hagen.de:{$objID}" 
            data-oascounttype="counter"
            data-oasfrom="{$from}" data-oasuntil="{$until}"
        />
      </div>
      <div class="row">
        <div class="col-md-7 col-sm-9 col-xs-6 text-right"><xsl:value-of select="i18n:translate('mir.oas.counter.abstract')" /></div>
        <div data-oaselementtype="OASInline" 
            data-oasproviderurl="{$WebApplicationBaseURL}graphprovider/" 
            data-oasidentifier="oai:ub-deposit.fernuni-hagen.de:{$objID}" 
            data-oascounttype="counter_abstract"
            data-oasfrom="{$from}" data-oasuntil="{$until}"
        />
      </div>
      <div class="row">
        <div class="col-md-12">
          <a href="#" data-toggle="modal" data-target="#oasGraphModal">Grafik öffnen</a>
        </div>
      </div>
      <div class="modal fade" id="oasGraphModal" tabindex="-1" role="dialog" aria-labelledby="oasGraphTitel" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <i class="fa fa-times" aria-hidden="true"></i>
              </button>
              <h4 class="modal-title" id="oasGraphTitel">Zugriffstatistik</h4>
            </div>
            <div class="modal-body">
              <div id="oasGraph" style="width:100%;height:200px;" 
                  data-oaselementtype="OASGraph" 
                  data-oasproviderurl="{$MIR.OAS.GraphProviderURL}" 
                  data-oasidentifier="oai:ub-deposit.fernuni-hagen.de:{$objID}" 
                  data-oasfrom="{$from}" data-oasuntil="{$until}"
              />
            </div>
            <div class="modal-footer">
              <img src="{$WebApplicationBaseURL}content/images/oaslogo.png" style="float:right" />
              Datenquelle: <a href="https://www.gbv.de/Verbundzentrale/04Projekte/open-access-statistik-oa-s"> Open Access Statistik</a>
            </div>
          </div>
        </div>
      </div>
      <script src="{$MIR.OAS.GraphProviderURL}includes/raphael-2.1.2/raphael-min.js"></script>
      <script src="{$MIR.OAS.GraphProviderURL}includes/morris.js-0.5.1/morris.js"></script>
      <script src="{$WebApplicationBaseURL}js/oa-statistic.js" ></script>
      <style type="text/css"> @import url("<xsl:value-of select="$MIR.OAS.GraphProviderURL" />includes/morris.js-0.5.1/morris.css"); </style> 
    </div>
    <xsl:apply-imports />
  </xsl:template>

</xsl:stylesheet>