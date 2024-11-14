<?xml version='1.0'?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:re="http://exslt.org/regular-expressions"
    extension-element-prefixes="exsl re"
    exclude-result-prefixes="exsl re"
    version='1.0'>
  <xsl:include href="../dblatex-config.xsl"/>

  <!-- These are both intentionally empty, as we start our page formatting
  with a comma, so we don't want any space before it. (The default is a
  single space for each.) -->
  <xsl:param name="xref.title-page.separator"></xsl:param>
  <xsl:param name="xref.label-page.separator"></xsl:param>

  <xsl:param name="local.l10n.xml" select="document('')"/>
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="fr">
      <l:context name="xref-number">
        <l:template name="chapter" text="chapitre&#160;%n"/>
        <l:template name="figure" text="figure&#160;%n"/>
        <l:template name="section" text="la section&#160;%n"/>
      </l:context>
      <l:context name="xref">
        <l:template name="page" text=", page %p"/>
      </l:context>
    </l:l10n>
  </l:i18n>

  <!-- Override the built-in template to add a short table of contents -->
  <xsl:template match="book|article" mode="toc_lots">
    <xsl:if test="$doc.toc.show != '0'">
      <xsl:text>\shorttoc{Table des matières abrégée}{1}&#10;</xsl:text>
      <xsl:text>\renewcommand\contentsname{Table des matières détaillée}&#10;</xsl:text>
      <xsl:text>\setcounter{tocdepth}{3}&#10;</xsl:text>
      <xsl:text>\tableofcontents&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="." mode="lots"/>
  </xsl:template>

  <!-- Add a space before the name in an attribution. -->
  <xsl:template match="attribution">
    <xsl:text>\hspace*\fill--- </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Add quotation marks and non-breaking spaces around the quote text. -->
  <xsl:template match="epigraph/para|epigraph/simpara
                      |blockquote/para|blockquote/simpara">
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="position() = 1">
      <xsl:text>« </xsl:text>
    </xsl:if>
    <xsl:call-template name="label.id"/>
    <xsl:apply-templates/>
    <xsl:if test="position() = last()">
      <xsl:text> »</xsl:text>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="copy-route">
    <xsl:param name="route" select="/.."/>
    <xsl:variable name="target" select="$route[1]"/>

    <xsl:choose>
      <xsl:when test="$target/self::*">
        <xsl:element name="{local-name($target)}"
                     namespace="{namespace-uri($target)}">
          <xsl:apply-templates select="$target/@xml:*" mode="copy-route"/>
          <xsl:call-template name="copy-route">
            <xsl:with-param name="route" select="$route[position() &gt; 1]"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <xsl:when test="not($target/..)">
        <xsl:call-template name="copy-route">
          <xsl:with-param name="route" select="$route[position() &gt; 1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="not(namespace-uri($target)
                          = 'http://www.w3.org/XML/1998/namespace')">
        <xsl:copy-of select="$target"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*" mode="copy-route">
    <xsl:copy/>
  </xsl:template>

  <xsl:template name="copy-route-to">
    <xsl:call-template name="copy-route">
      <xsl:with-param name="route"
                      select="ancestor-or-self::node()"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Modify file extensions -->
  <xsl:template match="node()|@*" mode="pdf-extension">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="pdf-extension"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="imagedata/@fileref" mode="pdf-extension">
    <!-- We need a whitelist of specific filenames not to modify: these didn't work out as PDFs, so we're leaving them as JPGs. -->
    <xsl:variable name="whitelist">
      <list>
        <i>onlinecontent</i>
        <i>feedback</i>
        <i>circleaimsTable</i>
        <i>alldecisionsaboutpastry</i>
        <i>broadfocusspecificfocusJH</i>
        <i>functionalroles</i>
        <i>selectionleader</i>
        <i>selectiondelegate</i>
        <i>facilitatorleaderskills</i>
        <i>operationalroles</i>
        <i>logbookexample</i>
        <i>leaderdelegate</i>
        <i>filtersystem</i>
        <i>basicstructure</i>
        <i>generalcircle</i>
        <i>MCandGCdifference</i>
        <i>influencetopbottom</i>
        <i>upcyclingdelegate</i>
        <i>topcircleowners</i>
        <i>topcircleforprofit</i>
        <i>topcirclenonprofit</i>
        <i>topcirclecommunity</i>
        <i>foldingacircleintooperationalrole</i>
        <i>branchexample1</i>
        <i>networkinternal</i>
        <i>orgvsnetwork</i>
        <i>topcircleslinked</i>
        <i>handoffhandover</i>
        <i>networkvscircle</i>
        <i>2-collectiveimpact</i>
        <i>operationalmeeting</i>
        <i>operationalpolicy</i>
        <i>5-consentobjectionaimJH</i>
        <i>4-backpackLDM</i>
        <i>4-understandexploredecidewithstepsCA</i>
        <i>MDFJHdecisionmakinginbetweenabstract</i>
        <i>MDFJHdecisionmakinginbetween</i>
        <i>3-votingvsconsentJH</i>
        <i>3-votingvsconsenttie</i>
        <i>3-votingvsconsenttie2</i>
        <i>LDMexamplesJH</i>
        <i>performancereview</i>
        <i>effectivefeedbackJH</i>
        <i>meetingtemplate</i>
        <i>foreverloop</i>
        <i>5-reviewpolicy</i>
        <i>5-buildingblocks</i>
        <i>5-meetingevaluation</i>
        <i>5-meetingagendamaking</i>
        <i>agendaexample</i>
        <i>5-whatgoesintotheminutes</i>
        <i>tablerounds</i>
        <i>5-strategieswhenstuck</i>
        <i>aimstocircle</i>
        <i>ExpertboxJuttaJohn1</i>
        <i>6-flowchart</i>
        <i>6-toolittletoomuch</i>
        <i>6-TCGCpatterns4</i>
        <i>2-metamorphosisTopDown1</i>
        <i>6-tinyorg</i>
        <i>implementationpolicy</i>
      </list>
    </xsl:variable>
    <xsl:variable name="slug-length"
      select="string-length(.) - string-length('../illustrations/') - 4"/>
    <xsl:attribute name="fileref">
      <xsl:choose>
        <xsl:when test="starts-with(., '../illustrations/')
            and substring(.,
                  string-length(.) - string-length('.ext') + 1) = '.jpg'
            and not(substring(., string-length('../illustrations/') + 1
                              , $slug-length)
                    = exsl:node-set($whitelist)/list/i)">
          <xsl:value-of select="concat(
              substring(., 1, string-length(.) - string-length('.jpg'))
              , '.pdf')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="imagedata/@fileref">
    <xsl:choose>
      <xsl:when test="contains(., ':') or starts-with(.,'/')">
        <!-- it has a uri scheme or starts with '/', so it is an absolute uri -->
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:when test="$keep.relative.image.uris != 0">
        <!-- leave it alone -->
        <xsl:value-of select="."/>
      </xsl:when>
      <!-- it's a relative uri -->
      <xsl:when test="false() and starts-with(., '../illustrations/') and
          substring(., string-length(.) - string-length('.ext') + 1) = '.jpg'">
        <xsl:call-template name="relative-uri">
          <xsl:with-param name="filename"
            select="concat(
              substring(., 1, string-length(.) - string-length('.jpg'))
              , '.pdf')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="fileref-route">
          <xsl:call-template name="copy-route-to"/>
        </xsl:variable>
        <xsl:variable name="fileref-pdf">
          <xsl:apply-templates select="exsl:node-set($fileref-route)"
                               mode="pdf-extension"/>
        </xsl:variable>

        <xsl:call-template name="relative-uri">
          <xsl:with-param name="filename"
            select="exsl:node-set($fileref-pdf)//@fileref"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
