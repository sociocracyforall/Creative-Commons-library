<?xml version='1.0'?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:re="http://exslt.org/regular-expressions"
    extension-element-prefixes="exsl re"
    exclude-result-prefixes="exsl re"
    version='1.0'>
  <xsl:include href="../epub-docbook-config.xsl"/>

  <!-- These are both intentionally empty, as we start our page formatting
  with a comma, so we don't want any space before it. (The default is a
  single space for each.) -->
  <xsl:param name="xref.title-page.separator"></xsl:param>
  <xsl:param name="xref.label-page.separator"></xsl:param>

  <xsl:param name="local.l10n.xml" select="document('')"/>
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="fr">
      <l:context name="title">
        <l:template name="mediaobject" text="%n – %t"/>
        <l:template name="figure" text="%n – %t"/>
      </l:context>
      <l:context name="xref-number">
        <l:template name="chapter" text="chapitre&#160;%n"/>
        <l:template name="figure" text="figure&#160;%n"/>
        <l:template name="mediaobject" text="figure&#160;%n"/>
        <l:template name="section" text="la section&#160;%n"/>
      </l:context>
      <l:context name="xref">
        <l:template name="mediaobject" text="%n"/>
        <l:template name="page" text=", page %p"/>
      </l:context>
    </l:l10n>
  </l:i18n>

  <!-- Add a space before the name in an attribution. -->
  <xsl:template match="attribution" mode="latex">
    <xsl:text>\hspace*\fill--- </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Add quotation marks and non-breaking spaces around the quote text. -->
  <xsl:template match="epigraph/para|epigraph/simpara
                      |blockquote/para|blockquote/simpara">
    <xsl:if test="position() = 1">
      <xsl:text>« </xsl:text>
    </xsl:if>
    <xsl:call-template name="label.id"/>
    <xsl:apply-templates/>
    <xsl:if test="position() = last()">
      <xsl:text> »</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
