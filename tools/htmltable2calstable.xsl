<?xml version='1.0'?>
<xsl:stylesheet
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:param name="remove-html-table-comments">no</xsl:param>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="db:table[db:tbody|db:tr]|db:informaltable[db:tbody|db:tr]">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="convert-to-cals"/>
      <xsl:apply-templates select="db:info|db:col|db:colgroup"
                           mode="convert-to-cals"/>
      <db:tgroup>
        <xsl:attribute name="cols">
          <xsl:choose>
            <xsl:when test="db:tbody">
              <xsl:value-of select="count(db:tbody/db:tr[1]/db:th
                                          |db:tbody/db:tr[1]/db:td)"/>
            </xsl:when>
            <xsl:when test="db:tr">
              <xsl:value-of select="count(db:tr[1]/db:th|db:tr[1]/db:td)"/>
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates selct="db:thead|db:tfoot|db:tbody"
                             mode="convert-to-cals"/>
        <xsl:if test="db:tr">
          <db:tbody>
            <xsl:apply-templates selct="db:tr" mode="convert-to-cals"/>
          </db:tbody>
        </xsl:if>
      </db:tgroup>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node()" mode="convert-to-cals">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="convert-to-cals"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*" mode="convert-to-cals">
    <xsl:attribute name="html:{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="comment()" mode="convert-to-cals">
    <xsl:if test="$remove-html-table-comments != 'yes'">
      <xsl:copy/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="db:tr//comment()">
    <xsl:if test="$remove-html-table-comments != 'yes'">
      <xsl:copy/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="db:tr" mode="convert-to-cals">
    <db:row>
      <xsl:apply-templates select="node()|@*" mode="convert-to-cals"/>
    </db:row>
  </xsl:template>

  <xsl:template match="db:td" mode="convert-to-cals">
    <db:entry>
      <xsl:apply-templates select="@*" mode="convert-to-cals"/>
      <xsl:apply-templates select="node()"/>
    </db:entry>
  </xsl:template>

  <xsl:template match="db:th" mode="convert-to-cals">
    <db:entry role="th">
      <xsl:apply-templates select="@*" mode="convert-to-cals"/>
      <xsl:apply-templates select="node()"/>
    </db:entry>
  </xsl:template>
</xsl:stylesheet>
