<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
  <!-- Don't show any list of titled items: -->
  <xsl:param name="doc.lot.show"></xsl:param>

  <xsl:param name="latex.class.book">book</xsl:param>

  <xsl:param name="latex.class.options">openany,twoside,10pt</xsl:param>

  <xsl:param name="page.width">8in</xsl:param>
  <xsl:param name="geometry.options">paperheight=10in, height=8.75in,
	paperwidth=8in, textwidth=6.25in,
	marginratio={2:3,1:1},
	bindingoffset=0.3in,
	includeheadfoot,
	dvips=false,pdftex=false,vtex=false</xsl:param>

  <xsl:param name="latex.encoding">utf8</xsl:param>

  <xsl:param name="doc.collab.show">0</xsl:param>

  <xsl:param name="latex.output.revhistory">0</xsl:param>

  <xsl:param name="preface.tocdepth">0</xsl:param>

  <xsl:param name="glossary.tocdepth">0</xsl:param>

  <xsl:param name="glossary.numbered">0</xsl:param>

  <xsl:param name="index.numbered">0</xsl:param>

  <xsl:param name="toc.section.depth">2</xsl:param>

  <xsl:param name="latex.hyperparam">hyperindex=false</xsl:param>

  <xsl:template match="indexterm/@significance">
    <xsl:choose>
      <xsl:when test=". = 'preferred'">
        <xsl:text>|textbf</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="informalfigure[@role = 'guide']">
    <xsl:text>\begin{quotationb}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{quotationb}&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="informalexample">
    <xsl:call-template name="label.id"/>
    <xsl:text>&#10;\begin{quote}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;\end{quote}&#10;</xsl:text>
  </xsl:template>

  <!-- Target Database set by the command line

  <xsl:param name="target.database.document">olinkdb.xml</xsl:param>
  -->

  <!-- Use the Bob Stayton's Tip related to olinking -->
  <!--xsl:param name="current.docid" select="/*/@id"/-->

  <!-- Use the literal scaling feature -->
  <!--xsl:param name="literal.extensions">scale.by.width</xsl:param-->

  <!-- We want the TOC links in the titles, and in blue. -->
  <!--xsl:param name="latex.hyperparam">colorlinks,linkcolor=blue,pdfstartview=FitH</xsl:param-->

  <!-- Put the dblatex logo -->
  <!--xsl:param name="doc.publisher.show">1</xsl:param-->

  <!-- Show the list of examples too -->
  <!--xsl:param name="doc.lot.show">figure,table,example</xsl:param-->

  <!-- DocBook like description -->
  <!--xsl:param name="term.breakline">1</xsl:param-->

  <!-- Manpage titles not numbered -->
  <!--xsl:param name="refentry.numbered">0</xsl:param-->
</xsl:stylesheet>
