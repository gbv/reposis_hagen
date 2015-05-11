<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" xmlns:mcrmods="xalan://org.mycore.mods.MCRMODSClassificationSupport"
  xmlns:basket="xalan://org.mycore.frontend.basket.MCRBasketManager" xmlns:acl="xalan://org.mycore.access.MCRAccessManager" xmlns:mcr="http://www.mycore.org/"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:mcrurn="xalan://org.mycore.urn.MCRXMLFunctions" xmlns:str="http://exslt.org/strings" exclude-result-prefixes="basket xalan xlink mcr i18n acl mods mcrmods mcrxsl mcrurn str"
  version="1.0" xmlns:ex="http://exslt.org/dates-and-times" extension-element-prefixes="ex">

  <xsl:param name="MIR.registerDOI" select="''" />
  <xsl:param name="template" select="'fixme'" />

  <!-- do nothing for display parent -->
  <xsl:template match="/mycoreobject" mode="parent" priority="1">
  </xsl:template>

  <xsl:template mode="printDerivatesThumb" match="/mycoreobject[contains(@ID,'_mods_')]" priority="1">
    <xsl:param name="staticURL" />
    <xsl:param name="layout" />
    <xsl:param name="xmltempl" />
    <xsl:param name="modsType" select="'report'" />
    <xsl:variable name="suffix">
      <xsl:if test="string-length($layout)&gt;0">
        <xsl:value-of select="concat('&amp;layout=',$layout)" />
      </xsl:if>
    </xsl:variable>
    <xsl:if test="./structure/derobjects">

      <div class="hit_symbol">
        <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/big/icon_{$modsType}.png" alt="{$modsType}"
          title="{$modsType}" />
        <xsl:variable name="embargo" select="metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='embargo']" />
        <xsl:choose>
          <xsl:when test="mcrxsl:isCurrentUserGuestUser() and count($embargo) &gt; 0 and mcrxsl:compare(string($embargo),ex:date-time()) &gt; 0">
            <!-- embargo is active for guest user -->
            <xsl:value-of select="i18n:translate('component.mods.metaData.dictionary.accessCondition.embargo.available',$embargo)" />
          </xsl:when>
          <xsl:when test="$objectHost != 'local'">
            <a href="{$staticURL}">nur auf original Server</a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="./structure/derobjects/derobject">
              <xsl:variable name="deriv" select="@xlink:href" />
              <xsl:variable name="derivlink" select="concat('mcrobject:',$deriv)" />
              <xsl:variable name="derivate" select="document($derivlink)" />
              <xsl:variable name="contentTypes" select="document('resource:FileContentTypes.xml')/FileContentTypes" />
              <xsl:variable name="fileType" select="document(concat('ifs:/',@xlink:href,'/'))/mcr_directory/children/child/contentType" />

              <xsl:variable name="derivid" select="$derivate/mycorederivate/@ID" />
              <xsl:variable name="derivlabel" select="$derivate/mycorederivate/@label" />
              <xsl:variable name="derivmain" select="$derivate/mycorederivate/derivate/internals/internal/@maindoc" />
              <xsl:variable name="derivbase" select="concat($ServletsBaseURL,'MCRFileNodeServlet/',$derivid,'/')" />
              <xsl:variable name="derivifs" select="concat($derivbase,$derivmain,$HttpSession)" />
              <xsl:variable name="derivdir" select="concat($derivbase,$HttpSession)" />

              <div class="hit_links">
                <a href="{$derivifs}">
                  <xsl:choose>
                    <xsl:when test="$fileType='pdf' or $fileType='msexcel' or $fileType='xlsx' or $fileType='msword97' or $fileType='docx'">
                      <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/download_{$fileType}.png" alt="{$derivmain}"
                        title="{$derivmain}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/download_default.png" alt="{$derivmain}"
                        title="{$derivmain}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
                <a href="{$derivdir}">
                <!-- xsl:value-of select="i18n:translate('buttons.details')" / -->
                  <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/download_details.png" alt="Details"
                    title="Details" style="padding-bottom:2px;" />
                </a>
              </div>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:accessCondition" mode="rights_reserved" priority="1">
    <img>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($WebApplicationBaseURL, 'templates/master/', $template , '/IMAGES/copyright.png')" />
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:value-of select="i18n:translate('component.mods.metaData.dictionary.rightsReserved')" />
      </xsl:attribute>
    </img>
  </xsl:template>

  <xsl:template match="children" mode="printChildren" priority="1">
    <xsl:param name="label" select="'enthält'" />

    <!-- the for-each would iterate over <id> with root not beeing /mycoreobject so we save the current node in variable context to access
      needed nodes -->
    <xsl:variable name="context" select="/mycoreobject" />

    <xsl:variable name="children" select="$context/structure/children/child[mcrxsl:isInCategory(@xlink:href,'state:published')]" />
    <xsl:variable name="maxElements" select="20" />
    <xsl:variable name="positionMin">
      <xsl:choose>
        <xsl:when test="count($children) &gt; $maxElements">
          <xsl:value-of select="count($children) - $maxElements + 1" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <tr>
      <td valign="top" class="metaname">
        <xsl:value-of select="concat($label,':')" />
      </td>
      <td class="metavalue">
        <xsl:if test="$positionMin != 0">
          <p>
            <a href="{$ServletsBaseURL}MCRSearchServlet?parent={$context/@ID}">
              <xsl:value-of select="i18n:translate('component.mods.metaData.displayAll')" />
            </a>
          </p>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="count($children) &gt; 1">
            <!-- display recent $maxElements only -->
            <ul class="document_children">
              <xsl:for-each select="$children[position() &gt;= $positionMin]">
                <li>
                  <xsl:call-template name="objectLink">
                    <xsl:with-param name="obj_id" select="@xlink:href" />
                  </xsl:call-template>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="objectLink">
              <xsl:with-param name="obj_id" select="$children/@xlink:href" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>


  <xsl:template match="/mycoreobject" mode="breadCrumb" priority="1">

    <ul class="breadcrumb">
      <li class="first">
        <a href="{$WebApplicationBaseURL}content/main/classifications/mir_genres.xml">
          <xsl:value-of select="i18n:translate('editor.search.mir.genre')" />
        </a>
      </li>
      <xsl:variable name="obj_host">
        <xsl:value-of select="$objectHost" />
      </xsl:variable>
      <xsl:if test="./structure/parents">
        <xsl:variable name="parent_genre">
          <xsl:apply-templates mode="mods-type" select="document(concat('mcrobject:',./structure/parents/parent/@xlink:href))/mycoreobject" />
        </xsl:variable>
        <li>
          <xsl:value-of select="i18n:translate(concat('component.mods.metaData.dictionary.', $parent_genre))" />
          <xsl:text>: </xsl:text>
          <xsl:apply-templates select="./structure/parents">
            <xsl:with-param name="obj_host" select="$obj_host" />
            <xsl:with-param name="obj_type" select="'this'" />
          </xsl:apply-templates>
          <xsl:apply-templates select="./structure/parents">
            <xsl:with-param name="obj_host" select="$obj_host" />
            <xsl:with-param name="obj_type" select="'before'" />
          </xsl:apply-templates>
          <xsl:apply-templates select="./structure/parents">
            <xsl:with-param name="obj_host" select="$obj_host" />
            <xsl:with-param name="obj_type" select="'after'" />
          </xsl:apply-templates>
        </li>
      </xsl:if>

      <xsl:variable name="internal_genre">
        <xsl:apply-templates mode="mods-type" select="." />
      </xsl:variable>
      <li>
        <xsl:value-of select="i18n:translate(concat('component.mods.metaData.dictionary.', $internal_genre))" />
      </li>
      <xsl:if test="./metadata/def.modsContainer/modsContainer/mods:mods/mods:genre[@type='kindof']">
        <li>
          <xsl:apply-templates select="./metadata/def.modsContainer/modsContainer/mods:mods/mods:genre[@type='kindof']"
            mode="printModsClassInfo" />
        </li>
      </xsl:if>
    </ul>

  </xsl:template>

  <xsl:template priority="2" mode="present" match="/mycoreobject[contains(@ID,'_mods_')]">
    <xsl:variable name="objectBaseURL">
      <xsl:if test="$objectHost != 'local'">
        <xsl:value-of select="document('webapp:hosts.xml')/mcr:hosts/mcr:host[@alias=$objectHost]/mcr:url[@type='object']/@href" />
      </xsl:if>
      <xsl:if test="$objectHost = 'local'">
        <xsl:value-of select="concat($WebApplicationBaseURL,'receive/')" />
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="staticURL">
      <xsl:value-of select="concat($objectBaseURL,@ID)" />
    </xsl:variable>

      <!--1***modsContainer************************************* -->
    <xsl:variable name="mods-type">
      <xsl:apply-templates mode="mods-type" select="." />
    </xsl:variable>

    <div id="detail_view" class="well">
      <h3>
        <xsl:apply-templates select="." mode="resulttitle" /><!-- shorten plain text title (without html) -->
      </h3>
      <xsl:choose>
        <xsl:when test="$mods-type='series'">
          <xsl:apply-templates select="." mode="objectActions">
            <xsl:with-param select="'journal'" name="layout" />
            <xsl:with-param select="$mods-type" name="mods-type" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="objectActions">
            <xsl:with-param select="$mods-type" name="layout" />
            <xsl:with-param select="$mods-type" name="mods-type" />
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <!-- xsl:when cases are handled in modsmetadata.xsl -->
        <xsl:when test="$mods-type = 'report'">
          <xsl:apply-templates select="." mode="present.report" />
        </xsl:when>
        <xsl:when test="$mods-type = 'thesis'">
          <xsl:apply-templates select="." mode="present.thesis" />
        </xsl:when>
        <xsl:when test="$mods-type = 'confpro'">
          <xsl:apply-templates select="." mode="present.confpro" />
        </xsl:when>
        <xsl:when test="$mods-type = 'confpub'">
          <xsl:apply-templates select="." mode="present.confpub" />
        </xsl:when>
        <xsl:when test="$mods-type = 'book'">
          <xsl:apply-templates select="." mode="present.book" />
        </xsl:when>
        <xsl:when test="$mods-type = 'chapter'">
          <xsl:apply-templates select="." mode="present.chapter" />
        </xsl:when>
        <xsl:when test="$mods-type = 'journal'">
          <xsl:apply-templates select="." mode="present.journal" />
        </xsl:when>
        <xsl:when test="$mods-type = 'series'">
          <xsl:apply-templates select="." mode="present.series" />
        </xsl:when>
        <xsl:when test="$mods-type = 'article'">
          <xsl:apply-templates select="." mode="present.article" />
        </xsl:when>
        <xsl:when test="$mods-type = 'av'">
          <xsl:apply-templates select="." mode="present.av" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="present.modsDefaultType">
            <xsl:with-param name="mods-type" select="$mods-type" />
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
      <!--*** Editor Buttons ************************************* -->
      <xsl:if
        test="((./structure/children/child) and not($mods-type='series' or $mods-type='journal' or $mods-type='confpro' or $mods-type='book')) or (./structure/derobjects/derobject)">
        <div id="derivate_box" class="accordion-group">
          <h4 id="derivate_switch" data-target="#derivate_content" data-toggle="collapse" class="accordion-heading">
            <a name="derivate_box"></a>
            <xsl:value-of select="i18n:translate('component.mods.metaData.dictionary.derivatebox')" />
          </h4>
          <div id="derivate_content" class="accordion-body collapse">
            <table class="metaData">
              <!--*** List children per object type ************************************* -->
              <!-- 1.) get a list of objectTypes of all child elements 2.) remove duplicates from this list 3.) for-each objectTyp id list child elements -->
              <xsl:variable name="objectTypes">
                <xsl:for-each select="./structure/children/child/@xlink:href">
                  <id>
                    <xsl:copy-of select="substring-before(substring-after(.,'_'),'_')" />
                  </id>
                </xsl:for-each>
              </xsl:variable>
              <xsl:variable select="xalan:nodeset($objectTypes)/id[not(.=following::id)]" name="unique-ids" />
              <!-- the for-each would iterate over <id> with root not beeing /mycoreobject so we save the current node in variable context to access
                needed nodes -->
              <xsl:variable select="." name="context" />
              <xsl:for-each select="$unique-ids">
                <xsl:variable select="." name="thisObjectType" />
                <xsl:variable name="label">
                  <xsl:choose>
                    <xsl:when test="count($context/structure/children/child[contains(@xlink:href,$thisObjectType)])=1">
                      <xsl:value-of select="i18n:translate(concat('component.',$thisObjectType,'.metaData.[singular]'))" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="i18n:translate(concat('component.',$thisObjectType,'.metaData.[plural]'))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="printMetaDate">
                  <xsl:with-param select="$context/structure/children/child[contains(@xlink:href, concat('_',$thisObjectType,'_'))]"
                    name="nodes" />
                  <xsl:with-param select="$label" name="label" />
                </xsl:call-template>
              </xsl:for-each>
              <xsl:apply-templates mode="printDerivates" select=".">
                <xsl:with-param select="$staticURL" name="staticURL" />
              </xsl:apply-templates>
            </table>
          </div>
        </div>
      </xsl:if>
      <!--*** Created ************************************* -->
      <div id="system_box" class="accordion-group">
        <div class="accordion-heading">
          <h4 data-target="#system_content" data-toggle="collapse" class="accordion-toggle">
            <xsl:value-of select="i18n:translate('component.mods.metaData.dictionary.systembox')" />
          </h4>
        </div>
        <div id="system_content" class="accordion-body collapse">
          <table class="accordion-inner metaData">
            <xsl:call-template name="printMetaDate">
              <xsl:with-param select="./service/servdates/servdate[@type='createdate']" name="nodes" />
              <xsl:with-param select="i18n:translate('metaData.createdAt')" name="label" />
            </xsl:call-template>
            <!--*** Last Modified ************************************* -->
            <xsl:call-template name="printMetaDate">
              <xsl:with-param select="./service/servdates/servdate[@type='modifydate']" name="nodes" />
              <xsl:with-param select="i18n:translate('metaData.lastChanged')" name="label" />
            </xsl:call-template>
            <!--*** MyCoRe-ID ************************************* -->
            <tr>
              <td class="metaname">
                <xsl:value-of select="concat(i18n:translate('metaData.ID'),':')" />
              </td>
              <td class="metavalue">
                <xsl:value-of select="./@ID" />
              </td>
            </tr>
            <tr>
              <td class="metaname">
                <xsl:value-of select="concat(i18n:translate('metaData.versions'),' :')" />
              </td>
              <td class="metavalue">
                <xsl:apply-templates select="." mode="versioninfo" />
              </td>
            </tr>
          </table>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="/mycoreobject[contains(@ID,'_mods_')]" mode="objectActions" priority="2">
    <xsl:param name="id" select="./@ID" />
    <xsl:param name="accessedit" select="acl:checkPermission($id,'writedb')" />
    <xsl:param name="accessdelete" select="acl:checkPermission($id,'deletedb')" />
    <xsl:param name="hasURN" select="'false'" />
    <xsl:param name="displayAddDerivate" select="'true'" />
    <xsl:param name="layout" select="'$'" />
    <xsl:param name="mods-type" select="'report'" />
    <xsl:variable name="layoutparam">
      <xsl:if test="$layout != '$'">
        <xsl:value-of select="concat('&amp;layout=',$layout)" />
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="editURL">
      <xsl:call-template name="mods.getObjectEditURL">
        <xsl:with-param name="id" select="$id" />
        <xsl:with-param name="layout" select="$layout" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="admineditURL">
      <xsl:call-template name="mods.getObjectEditURL">
        <xsl:with-param name="id" select="$id" />
        <xsl:with-param name="layout" select="'admin'" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="editURL_allMods">
      <xsl:call-template name="mods.getObjectEditURL">
        <xsl:with-param name="id" select="$id" />
        <xsl:with-param name="layout" select="'all'" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="basketType" select="'objects'" />
    <xsl:if test="$accessedit or $accessdelete or not(basket:contains($basketType, /mycoreobject/@ID))">
      <div class="btn-group">
        <xsl:if test="not(basket:contains($basketType, /mycoreobject/@ID))">
          <a class="btn btn-primary btn-sm"
            href="{$ServletsBaseURL}MCRBasketServlet{$HttpSession}?type={$basketType}&amp;action=add&amp;redirect=referer&amp;id={/mycoreobject/@ID}&amp;uri=mcrobject:{/mycoreobject/@ID}">
            <i class="fa fa-plus">
              <xsl:value-of select="' '" />
            </i>
            <xsl:value-of select="concat(' ',i18n:translate('basket.add'))" />
          </a>
        </xsl:if>
        <xsl:if test="$accessedit or $accessdelete">
          <div class="btn-group pull-right">
            <a href="#" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-cog">
                <xsl:value-of select="' '" />
              </i>
              <xsl:value-of select="' Aktionen'" />
              <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
              <xsl:variable name="type" select="substring-before(substring-after($id,'_'),'_')" />
              <xsl:if test="$accessedit">
                <xsl:choose>
                  <xsl:when test="string-length($editURL) &gt; 0 or string-length($admineditURL) &gt; 0">
                    <xsl:if test="string-length($editURL) &gt; 0">
                      <li>
                        <a href="{$editURL}">
                          <xsl:value-of select="i18n:translate('object.editObject')" />
                        </a>
                      </li>
                    </xsl:if>
                    <xsl:if test="string-length($admineditURL) &gt; 0">
                      <li>
                        <a href="{$admineditURL}">
                          <xsl:value-of select="'Admineditor'" />
                        </a>
                      </li>
                    </xsl:if>  
                    <!-- li> does not work atm
                      <a href="{$WebApplicationBaseURL}editor/change_genre.xed?id={$id}">
                        <xsl:value-of select="i18n:translate('object.editGenre')" />
                      </a>
                    </li -->
                    <xsl:if test="not(//mods:mods/mods:identifier[@type='doi']) and $MIR.registerDOI='true'">
                      <li>
                        <a href="{$WebApplicationBaseURL}receive/{/mycoreobject/@ID}?XSL.Transformer=datacite">
                          <xsl:value-of select="i18n:translate('mir.registerDOI')" />
                        </a>
                      </li>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <li>
                      <xsl:value-of select="i18n:translate('object.locked')" />
                    </li>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$displayAddDerivate='true' and not(mcrurn:hasURNDefined($id))">
                  <li>
                    <a href="{$ServletsBaseURL}derivate/create{$HttpSession}?id={$id}">
                      <xsl:value-of select="i18n:translate('derivate.addDerivate')" />
                    </a>
                  </li>
                </xsl:if>

                <!-- ToDo: Fix URN/Handle Generator, xpath is not mods valid -->
                <!-- xsl:if test="mcrxsl:isAllowedObjectForURNAssignment($id) and not(mcrurn:hasURNDefined($id))">
                <a
                  href="{$ServletsBaseURL}MCRAddURNToObjectServlet{$HttpSession}?object={$id}&amp;xpath=.mycoreobject/metadata/def.modsContainer[@class='MCRMetaXML' and @heritable='false' and @notinherit='true']/modsContainer/mods:mods/mods:identifier[@type='hdl']">
                  <img src="{$WebApplicationBaseURL}images/workflow_addnbn.gif" title="{i18n:translate('derivate.urn.addURN')}" />
                </a>
               </xsl:if -->

              </xsl:if>
              <xsl:if
                test="$accessdelete and (not(mcrurn:hasURNDefined($id)) or (mcrurn:hasURNDefined($id) and $CurrentUser=$MCR.Users.Superuser.UserName))">
                <li>
                  <xsl:choose>
                    <xsl:when test="/mycoreobject/structure/children/child">
                      <xsl:attribute name="class">
                      <xsl:value-of select="'disabled'" />
                    </xsl:attribute>
                      <a href="#" title="{i18n:translate('object.hasChildren')}">
                        <xsl:value-of select="i18n:translate('object.delObject')" />
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="{$ServletsBaseURL}object/delete{$HttpSession}?id={$id}" id="confirm_deletion">
                        <xsl:value-of select="i18n:translate('object.delObject')" />
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </li>
              </xsl:if>
              <xsl:if test="$CurrentUser=$MCR.Users.Superuser.UserName">
                <li>
                  <a href="{$editURL_allMods}">
                    <xsl:value-of select="i18n:translate('component.mods.object.editAllModsXML')" />
                  </a>
                </li>
              </xsl:if>
              <xsl:variable name="genreHosts" select="document('classification:metadata:-1:children:mir_genres')" />
              <xsl:variable name="child-layout">
                <xsl:for-each select="$genreHosts//category[contains(label[@xml:lang='x-hosts']/@text, $mods-type)]">
                  <xsl:value-of select="@ID" />
                  <xsl:text>|</xsl:text>
                </xsl:for-each>
              </xsl:variable>
              <xsl:message>
                mods-type: <xsl:value-of select="$mods-type"/>
                child-layout: <xsl:value-of select="$child-layout"/>
                accessedit: <xsl:value-of select="$accessedit"/>
              </xsl:message>
              <!-- actionmapping.xml must be available for this functionality -->
              <xsl:if test="string-length($child-layout) &gt; 0 and $accessedit and mcrxsl:resourceAvailable('actionmappings.xml')">

              <xsl:variable name="url">
                <xsl:value-of select="actionmapping:getURLforID('create-child',$id,true())" xmlns:actionmapping="xalan://org.mycore.wfc.actionmapping.MCRURLRetriever" />
              </xsl:variable>

                <xsl:choose>
                  <xsl:when test="not(contains($url, 'editor-dynamic.xed'))">
                    <xsl:for-each select="str:tokenize($child-layout,'|')" >
                      <li>
                        <a href="{$url}{$HttpSession}?parentId={$id}">
                          <xsl:value-of select="i18n:translate(concat('component.mods.genre.',.))" />
                        </a>
                      </li>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="$mods-type = 'series'">
                    <xsl:for-each select="str:tokenize($child-layout,'|')" >
                      <li>
                        <a href="{$url}{$HttpSession}?genre={.}&amp;host=series&amp;seriesId={$id}">
                          <xsl:value-of select="i18n:translate(concat('component.mods.genre.',.))" />
                        </a>
                      </li>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="str:tokenize($child-layout,'|')" >
                      <li>
                        <a href="{$url}{$HttpSession}?genre={.}&amp;parentId={$id}">
                          <xsl:value-of select="i18n:translate(concat('component.mods.genre.',.))" />
                        </a>
                      </li>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </ul>
          </div>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="derobject" mode="derivateActions">
    <xsl:param name="deriv" />
    <xsl:param name="parentObjID" />
    <xsl:param name="suffix" select="''" />
    <xsl:if test="acl:checkPermission($deriv,'writedb')">

      <xsl:variable select="concat('mcrobject:',$deriv)" name="derivlink" />
      <xsl:variable select="document($derivlink)" name="derivate" />
      <xsl:variable name="derivateWithURN" select="mcrurn:hasURNDefined($deriv)" />


      <div class="options pull-right">
        <div class="btn-group">
          <a href="#" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            <i class="fa fa-cog"></i>
            <xsl:value-of select="' Aktionen'" />
            <span class="caret"></span>
          </a>
          <ul class="dropdown-menu dropdown-menu-right">
            <li>
              <a href="{$ServletsBaseURL}derivate/update{$HttpSession}?id={$deriv}">
                <!-- xsl:value-of select="i18n:translate('component.swf.derivate.updateFile')" / -->
                Beschriftung bearbeiten
              </a>
            </li>
             <xsl:choose>
               <xsl:when test="$derivateWithURN=false()">
                 <li>
                   <a href="{$ServletsBaseURL}derivate/update{$HttpSession}?objectid={../../../@ID}&amp;id={$deriv}{$suffix}"
                      class="option">
                     <xsl:value-of select="i18n:translate('component.swf.derivate.addFile')" />
                   </a>
                 </li>
               </xsl:when>
               <xsl:otherwise>
                 <li><!-- xsl:value-of select="i18n:translate('component.swf.derivate.addFile')" /--> Bearbeitung wg. URN gesperrt</li>
               </xsl:otherwise>
             </xsl:choose>
             <xsl:if test="$derivateWithURN=false() and mcrxsl:isAllowedObjectForURNAssignment($parentObjID)">
               <xsl:variable name="apos">
                 <xsl:text>'</xsl:text>
               </xsl:variable>
               <li>
                 <xsl:if test="not(acl:checkPermission($deriv,'deletedb'))">
                   <xsl:attribute name="class">last</xsl:attribute>
                 </xsl:if>
                 <a href="{$ServletsBaseURL}MCRAddURNToObjectServlet{$HttpSession}?object={$deriv}&amp;target=derivate" onclick="{concat('return confirm(',$apos, i18n:translate('component.mods.metaData.options.urn.confirm'), $apos, ');')}"
                    class="option">
                   <xsl:value-of select="i18n:translate('component.mods.metaData.options.urn')" />
                 </a>
               </li>
             </xsl:if>
             <xsl:if test="acl:checkPermission($deriv,'deletedb') and $derivateWithURN=false()">
               <li class="last">
                 <a href="{$ServletsBaseURL}derivate/delete{$HttpSession}?id={$deriv}"
                    class="confirm_derivate_deletion option">
                   <xsl:value-of select="i18n:translate('component.swf.derivate.delDerivate')" />
                 </a>
               </li>
             </xsl:if>
          </ul>
        </div>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/mycoreobject[contains(@ID,'_mods_')]" mode="basketContent" priority="1">
    <xsl:variable name="objID" select="@ID" />
    <xsl:variable name="mods-type">
      <xsl:apply-templates select="." mode="mods-type" />
    </xsl:variable>

    <xsl:for-each select="./metadata/def.modsContainer/modsContainer/mods:mods">

<!-- document preview -->
          <div class="hit_download_box">
            <!-- TODO: replace placeholder -->
            <img class="hit_icon" src="{$WebApplicationBaseURL}images/icons/icon_common_disabled.png" />
            <!-- end: placeholder -->
          </div>

<!-- hit type -->
          <div class="hit_tnd_container">
            <div class="hit_tnd_content">
              <div class="hit_type">
                <span class="label label-info">
                  <xsl:value-of select="i18n:translate(concat('component.mods.genre.',$mods-type))" />
                </span>
              </div>
              <xsl:if test="mods:originInfo/mods:dateIssued">
                <div class="hit_date">
                  <span class="label label-primary">
                    <xsl:variable name="dateIssued">
                      <xsl:apply-templates mode="mods.datePublished" select="mods:originInfo/mods:dateIssued" />
                    </xsl:variable>
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
                </div>
              </xsl:if>
            </div>
          </div>

      <!-- Title, Link to presentation -->
          <h3 class="hit_title">
            <xsl:call-template name="objectLink">
              <xsl:with-param name="obj_id" select="$objID" />
            </xsl:call-template>
          </h3>

<!-- hit author -->
          <div class="hit_author">
            <xsl:for-each select="mods:name[mods:role/mods:roleTerm/text()='aut']">
              <xsl:if test="position()!=1">
                <xsl:value-of select="'/ '" />
              </xsl:if>
              <xsl:apply-templates select="." mode="authors_short" />
            </xsl:for-each>
          </div>

<!-- hit parent -->
          <xsl:if test="../../../../structure/parents/parent/@xlink:href">
            <div class="hit_source">
              <span class="label_parent">
                <xsl:value-of select="'aus: '" />
              </span>
              <xsl:call-template name="objectLink">
                <xsl:with-param name="obj_id" select="../../../../structure/parents/parent/@xlink:href" />
              </xsl:call-template>
            </div>
          </xsl:if>

<!-- hit abstract -->
          <div class="hit_abstract">
            <xsl:if test="mods:abstract">
              <xsl:value-of select="mcrxsl:shortenText(mods:abstract,300)" />
            </xsl:if>
          </div>

<!-- hit publisher -->
          <xsl:if test="//mods:originInfo/mods:publisher">
            <div class="hit_pub_name">
              <span class="label_publisher">
                <xsl:value-of select="concat(i18n:translate('component.mods.metaData.dictionary.published'),': ')" />
              </span>
              <xsl:value-of select="//mods:originInfo/mods:publisher" />
            </div>
          </xsl:if>
      </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>