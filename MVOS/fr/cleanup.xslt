<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns="http://docbook.org/ns/docbook"
    exclude-result-prefixes="db"
    db:prefix="db"
    version="1.0">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="db:para[not(node())]"/>

  <xsl:template match="db:para[not(*) and not(normalize-space(text()))]"/>

  <xsl:template match="db:blockquote[not(*) and not(normalize-space(text()))]"/>

  <xsl:template match="db:blockquote[db:para[not(*) and not(normalize-space(text()))]]"/>

  <xsl:template match="db:imagedata/@depth"/>
  <xsl:template match="db:imagedata/@width"/>

  <xsl:template match="db:listitem/db:blockquote[
      count(../*) = 1 and not(normalize-space(../text()))
      and count(*) = 1 and db:para and not(normalize-space(text()))]">
    <xsl:apply-templates select="db:para"/>
  </xsl:template>
</xsl:stylesheet>
