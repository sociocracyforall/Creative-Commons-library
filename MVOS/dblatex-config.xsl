<?xml version='1.0'?>
<!-- Customizations common to all language versions of this book -->
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

  <xsl:param name="toc.section.depth">3</xsl:param>
  <xsl:param name="doc.section.depth">2</xsl:param>

  <xsl:param name="figure.default.position">[htb]</xsl:param>

  <xsl:param name="latex.hyperparam">hyperindex=false</xsl:param>

  <!-- Use the font from the LaTeX style definition, instead -->
  <xsl:param name="xetex.font"/>

  <!-- Modified front-matter templates (for acknowledgements, colophon, and dedication)
  to use the `maketitle` template. I'm not sure why the source templates use a different
  approach. -->
  <xsl:template match="acknowledgements">
    <xsl:call-template name="maketitle">
      <xsl:with-param name="title">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Acknowledgements'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="colophon">
    <xsl:call-template name="maketitle">
      <xsl:with-param name="title">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Colophon'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dedication">
    <xsl:call-template name="maketitle">
      <xsl:with-param name="title">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Dedication'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="preface">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>% ------- &#10;</xsl:text>
    <xsl:text>% Preface &#10;</xsl:text>
    <xsl:text>% ------- &#10;</xsl:text>
    <!--xsl:apply-templates select="." mode="endnotes"/-->
    <xsl:call-template name="mapheading"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="book/glossary">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>% ------- &#10;</xsl:text>
    <xsl:text>% Glossary &#10;</xsl:text>
    <xsl:text>% ------- &#10;</xsl:text>
    <!--xsl:apply-templates select="." mode="endnotes"/-->
    <xsl:call-template name="maketitle">
      <xsl:with-param name="title">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Glossary'"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="command">
        <xsl:call-template name="sec-map">
          <xsl:with-param name="keyword" select="'preface'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format a glosslist as a table. This involves the templates through the
  `glossdef` template. -->
  <xsl:template match="glosslist">
    <xsl:text>\bgroup \def\arraystretch{1.4}&#10;</xsl:text>
    <xsl:text>\begin{longtable}{p{0.18\linewidth}p{0.78\linewidth}}&#10;</xsl:text>
    <xsl:text>&amp; \\\hline\hline&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\hline&#10;\end{longtable}&#10;\egroup&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="glossentry">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="glossterm">
    <xsl:apply-templates/>
    <xsl:text>&amp;</xsl:text>
  </xsl:template>

  <xsl:template match="glossdef">
    <xsl:apply-templates/>
    <xsl:text>\\\hline&#10;</xsl:text>
  </xsl:template>

  <!-- Display preferred index terms in bold -->
  <xsl:template match="indexterm/@significance">
    <xsl:choose>
      <xsl:when test=". = 'preferred'">
        <xsl:text>|textbf</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- For this book, we want informalexample elements to display using the quote
  environment. -->
  <xsl:template match="informalexample">
    <xsl:call-template name="label.id"/>
    <xsl:text>&#10;\begin{quote}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;\end{quote}&#10;</xsl:text>
  </xsl:template>

  <!-- This special role of informalfigure uses a custom environment that is defined
  in the LaTeX custom style file. -->
  <xsl:template match="informalfigure[@role = 'guide']">
    <xsl:text>\begin{quotationb}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{quotationb}&#10;</xsl:text>
  </xsl:template>

  <!-- DocBook 5 doesn't have a @float attribute on figures any longer, but the dblatex
  XSLT stylesheets don't know about that yet, so we use a customization layer to fall
  through to the $figure.default.position value. -->
  <xsl:template match="figure">
    <xsl:text>\begin{figure}</xsl:text>
    <!-- figure placement preference -->
    <xsl:choose>
      <xsl:when test="@floatstyle != ''">
        <xsl:value-of select="@floatstyle"/>
      </xsl:when>
      <!-- Skip this @float test, as DocBook 5 doesn't have this attribute
      any longer. I think this would be best implemented using
      $figure.default.position, in any case. -->
      <!--xsl:when test="not(@float) or (@float and @float='0')">
        <xsl:text>[H]</xsl:text>
      </xsl:when-->
      <xsl:otherwise>
        <xsl:value-of select="$figure.default.position"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>

    <!-- title caption before the image -->
    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="1"/>
    </xsl:apply-templates>

    <!-- <xsl:text>&#10;\centering&#10;</xsl:text> -->
    <xsl:call-template name="figure.begin"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
    <xsl:call-template name="figure.end"/>

    <!-- title caption after the image -->
    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="0"/>
    </xsl:apply-templates>
    <xsl:text>\end{figure}&#10;</xsl:text>
  </xsl:template>

  <!-- Only one sideways figure in the book, so we just match it by its
  xml:id attribute. A bit of a hack; we could generalize this easily with
  an attribute value, but for a singleton, this seemed easier. -->
  <xsl:template match="figure[@xml:id = 'decision-makingtoolsmeasures']">
    <xsl:text>\begin{sidewaysfigure}</xsl:text>

    <!-- title caption before the image -->
    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="1"/>
    </xsl:apply-templates>

    <!-- <xsl:text>&#10;\centering&#10;</xsl:text> -->
    <xsl:call-template name="figure.begin"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
    <xsl:call-template name="figure.end"/>

    <!-- title caption after the image -->
    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="0"/>
    </xsl:apply-templates>
    <xsl:text>\end{sidewaysfigure}&#10;</xsl:text>
  </xsl:template>

  <!-- Treat figure elements with figure parent elements as sub-figures. -->
  <xsl:template match="figure/figure">
      <!-- space before subfigure to prevent from strange behaviour with other
           subfigures unless forced by @role -->
    <xsl:if test="not(ancestor::figure/@role='flow.inline')">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:text>\subfigure[</xsl:text>
    <xsl:apply-templates select="title" mode="subfigure"/>
    <xsl:text>][</xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:text>]{</xsl:text>
    <xsl:if test="$imagedata.boxed = '1'">
      <xsl:text>\fbox{</xsl:text>
    </xsl:if>
    <xsl:call-template name="label.id"/>
    <xsl:apply-templates select="*[not(self::title)]"/>
    <xsl:if test="$imagedata.boxed = '1'">
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="figure/figure/title">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$mediaobject.caption.style"/>
    <xsl:text> </xsl:text>
    <!-- Apply templates to render captions elements -->
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="figure/figure/title" mode="subfigure">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$mediaobject.caption.style"/>
    <xsl:text> </xsl:text>
    <!-- In subfigures, cannot have several paragraphs, so just take
         the text and normalize it (no \par in it)
         -->
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="."/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Generate cross-reference text for mediaobject children of figure
  elements as (sub-)figures. -->
  <xsl:template match="figure/mediaobject" mode="xref-to-DISABLED">
    <xsl:param name="referrer"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="verbose"/>

    <xsl:choose>
      <xsl:when test="$xrefstyle != ''">
        <xsl:apply-templates select="." mode="object.xref.markup2">
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
          <xsl:with-param name="verbose" select="$verbose"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$verbose != 0">
          <xsl:message>
            <xsl:text>WARNING: xref to &lt;</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text> id="</xsl:text>
            <xsl:value-of select="@id|@xml:id"/>
            <xsl:text>"&gt; has no generated text. Trying its parent element.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select=".." mode="xref-to">
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
          <xsl:with-param name="verbose" select="$verbose"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
