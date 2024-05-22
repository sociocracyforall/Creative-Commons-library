<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
  <xsl:include href="../dblatex-config.xsl"/>

  <!-- Override the built-in template to add a short table of contents -->
  <xsl:template match="book|article" mode="toc_lots">
    <xsl:if test="$doc.toc.show != '0'">
      <xsl:text>\shorttoc{Short table of contents (needs translation)}{1}&#10;</xsl:text>
      <xsl:text>\renewcommand\contentsname{Detailed table of contents (needs translation)}&#10;</xsl:text>
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
