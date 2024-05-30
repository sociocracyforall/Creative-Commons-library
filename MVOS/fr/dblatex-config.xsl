<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
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
</xsl:stylesheet>
