<?xml version='1.0'?>
<!-- Customizations common to all language versions of this book -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
  <!-- Don't show any list of titled items: -->
  <xsl:param name="doc.lot.show"></xsl:param>

  <xsl:param name="latex.class.book">book</xsl:param>

  <xsl:param name="latex.class.options">openright,twoside,10pt</xsl:param>

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

  <xsl:param name="figure.default.position">[htbp]</xsl:param>

  <xsl:param name="latex.hyperparam">hyperindex=false</xsl:param>

  <!-- Use the font from the LaTeX style definition, instead -->
  <xsl:param name="xetex.font"/>

  <xsl:template name="lang.setup">
    <!-- first find the language actually set -->
    <xsl:variable name="lang">
      <xsl:call-template name="l10n.language">
        <xsl:with-param name="target" select="(/set|/book|/article)[1]"/>
        <xsl:with-param name="xref-context" select="true()"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- locale setup for docbook -->
    <xsl:if test="$lang!='' and $lang!='en'">
      <xsl:text>\setuplocale{</xsl:text>
      <xsl:value-of select="substring($lang, 1, 2)"/>
      <xsl:text>}&#10;</xsl:text>
    </xsl:if>

    <!-- some extra babel setup -->
    <!-- Actually, I suspect the `\setupbabel` macro may be recently broken
    (and unnecessary), so I'm turning it off. -->
    <xsl:if test="$latex.babel.use='1' and false()">
      <xsl:variable name="babel">
        <xsl:call-template name="babel.language">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="$babel!=''">
        <xsl:text>\setupbabel{</xsl:text>
        <xsl:value-of select="$lang"/>
        <xsl:text>}&#10;</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- We override this because we want to handle the whole copyright page
  ourselves. -->
  <xsl:template match="bookinfo|articleinfo|info" mode="docinfo">
    <!-- special case for copyrights, managed as a group -->
    <xsl:if test="copyright and false()">
      <xsl:text>\def\DBKcopyright{</xsl:text>
      <xsl:apply-templates select="copyright" mode="titlepage.mode"/>
      <xsl:text>}&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="docinfo"/>
  </xsl:template>

  <!-- And we override this to do the work of typesetting the copyright
  page in the custom way that we want. -->
  <xsl:template name="print.legalnotice">
    <!-- Note that `$nodes`, here, will contain `legalnotice` element(s). -->
    <xsl:param name="nodes" select="."/>
    <xsl:if test="$nodes">
      <xsl:text>&#10;%% Legalnotices&#10;</xsl:text>
      <!-- beware, save verbatim since we use a command -->
      <xsl:apply-templates select="$nodes" mode="save.verbatim"/>
      <xsl:text>\def\DBKlegalblock{&#10;</xsl:text>
      <xsl:text>\vspace*{\fill}&#10;\thispagestyle{empty}&#10;</xsl:text>
      <xsl:text>\noindent </xsl:text>
      <xsl:apply-templates select="$nodes/../org/orgname"/>
      <xsl:text>&#10;&#10;\vspace{0.3em}&#10;&#10;</xsl:text>
      <xsl:text>\noindent </xsl:text>
      <xsl:apply-templates select="$nodes/../org/address/street"/>
      <xsl:text>&#10;&#10;</xsl:text>
      <xsl:text>\noindent </xsl:text>
      <xsl:apply-templates select="$nodes/../org/address/city"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$nodes/../org/address/state"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="$nodes/../org/address/postcode"/>
      <xsl:text>&#10;&#10;</xsl:text>
      <xsl:text>\noindent </xsl:text>
      <xsl:apply-templates select="$nodes/../org/address/country"/>
      <xsl:text>&#10;&#10;</xsl:text>
      <xsl:text>\noindent </xsl:text>
      <xsl:apply-templates select="$nodes/../org/address/email"/>
      <xsl:text>&#10;&#10;\vspace{0.25em}&#10;&#10;</xsl:text>
      <xsl:apply-templates select="$nodes/*"/>
      <xsl:text>}&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Modified front-matter templates (for acknowledgements, colophon, and dedication)
  to use the `maketitle` template. I'm not sure why the source templates use a different
  approach. -->
  <xsl:template match="acknowledgements">
    <xsl:variable name="title" select="title|info/title"/>
    <xsl:choose>
      <xsl:when test="$title">
        <xsl:call-template name="makeheading">
          <xsl:with-param name="command">\chapter*</xsl:with-param>
        </xsl:call-template>
        <xsl:text>\markboth{</xsl:text>
        <xsl:apply-templates select="$title[1]" mode="format.title"/>
        <xsl:text>}{}&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\newpage&#10;\markboth{}{}&#10;</xsl:text>
        <xsl:text>\vspace*{20em}&#10;\begin{center}&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <!--xsl:text>\thispagestyle{empty}&#10;</xsl:text-->
    <xsl:apply-templates/>
    <xsl:if test="not($title)">
      <xsl:text>\end{center}&#10;\newpage&#10;</xsl:text>
    </xsl:if>
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
    <xsl:variable name="title" select="title|info/title"/>
    <xsl:choose>
      <xsl:when test="$title">
        <xsl:call-template name="makeheading">
          <xsl:with-param name="command">\chapter*</xsl:with-param>
        </xsl:call-template>
        <xsl:text>\markboth{</xsl:text>
        <xsl:apply-templates select="$title[1]" mode="format.title"/>
        <xsl:text>}{}&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\newpage&#10;\markboth{}{}&#10;</xsl:text>
        <xsl:text>\vspace*{20em}&#10;\begin{center}&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\thispagestyle{empty}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:if test="not($title)">
      <xsl:text>\end{center}&#10;\newpage&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="preface">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>% ------- &#10;</xsl:text>
    <xsl:text>% Preface &#10;</xsl:text>
    <xsl:text>% ------- &#10;</xsl:text>
    <!--xsl:apply-templates select="." mode="endnotes"/-->
    <xsl:call-template name="mapheading"/>
    <xsl:text>\markboth{</xsl:text>
    <xsl:apply-templates select="(title|info/title)[1]" mode="format.title"/>
    <xsl:text>}{}&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="book/glossary">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>% ------- &#10;</xsl:text>
    <xsl:text>% Glossary &#10;</xsl:text>
    <xsl:text>% ------- &#10;</xsl:text>
    <!--xsl:apply-templates select="." mode="endnotes"/-->
    <xsl:variable name="glossary-title">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Glossary'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="maketitle">
      <xsl:with-param name="title">
        <xsl:value-of select="$glossary-title"/>
      </xsl:with-param>
      <xsl:with-param name="command">
        <xsl:call-template name="sec-map">
          <xsl:with-param name="keyword" select="'preface'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>\markboth{</xsl:text>
    <xsl:value-of select="$glossary-title"/>
    <xsl:text>}{}&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- The original template misses several frontmatter elements,
  somehow, so we override and augment it, here. -->
  <xsl:template match="book|article">
    <xsl:param name="layout" select="concat($doc.layout, ' ')"/>

    <xsl:variable name="info" select="bookinfo|articleinfo|artheader|info"/>
    <xsl:variable name="lang">
      <xsl:call-template name="l10n.language">
        <xsl:with-param name="target" select="(/set|/book|/article)[1]"/>
        <xsl:with-param name="xref-context" select="true()"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- Latex preamble -->
    <xsl:apply-templates select="." mode="preamble">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:apply-templates>

    <xsl:value-of select="$latex.begindocument"/>
    <xsl:call-template name="lang.document.begin">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
    <xsl:call-template name="label.id"/>

    <!-- Setup that must be performed after the begin of document -->
    <xsl:call-template name="verbatim.setup2"/>

    <!-- Apply the legalnotices here, when language is active -->
    <xsl:call-template name="print.legalnotice">
      <xsl:with-param name="nodes" select="$info/legalnotice"/>
    </xsl:call-template>

    <xsl:call-template name="front.cover"/>

    <xsl:if test="contains($layout, 'frontmatter ')">
      <xsl:value-of select="$frontmatter"/>
    </xsl:if>

    <xsl:if test="contains($layout, 'coverpage ')">
      <xsl:text>
        \thispagestyle{empty}

        \begin{figure}[h!]
        \centering
        \includegraphics{illustrations/logoSoFAbw.png}
        \end{figure}

        \vspace{10em}

        \begin{center}\begin{Huge}\textsf{\expandafter\MakeUppercase
          \expandafter{\DBKtitle}}\\
          \vspace{1em}
        \textsf{\DBKsubtitle}\end{Huge}\\

        \vspace{2em}

        \begin{Large}\textsf{\DBKauthor}\end{Large}\end{center}

        \vfill

        \noindent \begin{center}\Large{\textsf{Sociocracy For All}}\\
        \noindent \Large{\textsf{Amherst, MA USA}}\\
        \noindent \textsf{sociocracyforall.org}\\
        \end{center}

        \newpage

        \maketitle
      </xsl:text>
    </xsl:if>

    <xsl:apply-templates select="dedication"/>

    <!-- Print the TOC/LOTs -->
    <xsl:if test="contains($layout, 'toc ')">
      <xsl:apply-templates select="." mode="toc_lots"/>
    </xsl:if>

    <!-- Print the abstract and front matter content -->
    <!-- @@TODO:@@ this does have the potential to bring these elements
    out of document order. How would we want to handle this robustly
    for the general case? -->
    <xsl:apply-templates select="(abstract|$info/abstract)[1]"/>
    <xsl:apply-templates select="preface|glossary|acknowledgements"/>

    <!-- Body content -->
    <xsl:if test="contains($layout, 'mainmatter ')">
      <xsl:value-of select="$mainmatter"/>
    </xsl:if>
    <xsl:apply-templates select="*[not(self::abstract or
                                       self::dedication or
                                       self::acknowledgements or
                                       self::glossary or
                                       self::preface or
                                       self::colophon or
                                       self::appendix)]"/>

    <!-- Back matter -->
    <xsl:if test="contains($layout, 'backmatter ')">
      <xsl:value-of select="$backmatter"/>
    </xsl:if>

    <xsl:apply-templates select="appendix"/>
    <xsl:if test="contains($layout, 'index ')">
      <xsl:if test="*//indexterm|*//keyword">
        <xsl:call-template name="printindex"/>
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="colophon"/>
    <xsl:call-template name="lang.document.end">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>

    <xsl:call-template name="back.cover"/>

    <xsl:value-of select="$latex.enddocument"/>
  </xsl:template>

  <!-- Format a glosslist as a table. This involves the templates through the
  `glossdef` template. -->
  <xsl:template match="glosslist">
    <!--xsl:text>\bgroup \def\arraystretch{1.4}&#10;</xsl:text-->
    <xsl:text>\def\arraystretch{1.4}&#10;</xsl:text>
    <xsl:text>\begin{longtable}{p{0.18\linewidth}p{0.78\linewidth}}&#10;</xsl:text>
    <!--xsl:text>\begin{longtable}{lp{0.78\linewidth}}&#10;</xsl:text-->
    <xsl:text>&amp; \\\hline\hline&#10;</xsl:text>
    <xsl:apply-templates/>
    <!--xsl:text>\hline&#10;\end{longtable}&#10;\egroup&#10;</xsl:text-->
    <xsl:text>\hline&#10;\end{longtable}&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="glossentry">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="glossterm">
    <xsl:text>\raggedright </xsl:text>
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

  <!-- For this book, we want formalpara elements to use the LaTeX
  `\paragraph` command. -->
  <xsl:template match="formalpara">
    <xsl:text>&#10;\paragraph{</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="title"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
    <xsl:call-template name="label.id"/>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
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
    <xsl:apply-templates select="." mode="foottext"/>
  </xsl:template>

  <xsl:template match="footnote[ancestor::informalfigure[@role = 'guide']]">
    <xsl:text>\footnotemark{}</xsl:text>
  </xsl:template>

  <xsl:template match="informalfigure[@role = 'guide']/para">
    <xsl:text>&#10;\noindent </xsl:text>
    <xsl:call-template name="label.id"/>
    <xsl:apply-templates/>
    <xsl:if test="position() != last()">
      <xsl:text>\vspace{0.2em}</xsl:text>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- DocBook 5 doesn't have a @float attribute on figures any longer, but
  the dblatex XSLT stylesheets don't know about that yet, so we use a
  customization layer to fall through to the $figure.default.position
  value. -->
  <xsl:template match="figure">
    <!-- Also, the dblatex XSLT stylesheets don't start this with a
    newline. Why not? (We add it here.) -->
    <xsl:text>&#10;\begin{figure}</xsl:text>
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
    <xsl:apply-templates select="node()[not(self::title|self::caption)]"/>
    <xsl:call-template name="figure.end"/>

    <!-- title caption after the image -->
    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="0"/>
    </xsl:apply-templates>
    <xsl:text>\end{figure}&#10;</xsl:text>
    <xsl:apply-templates select="." mode="foottext"/>
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
    <xsl:apply-templates select="*[not(self::title|self::caption)]"/>
    <xsl:call-template name="figure.end"/>

    <!-- title caption after the image -->
    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="0"/>
    </xsl:apply-templates>
    <xsl:text>\end{sidewaysfigure}&#10;</xsl:text>
  </xsl:template>

  <!-- We override this case so that we can include both `title` and `caption`
  text within the LaTeX `\caption`. -->
  <xsl:template match="figure/title" mode="format.title">
    <xsl:param name="allnum" select="'0'"/>
    <xsl:apply-templates select="." mode="toc">
      <xsl:with-param name="allnum" select="$allnum"/>
    </xsl:apply-templates>
    <xsl:text>{</xsl:text>
    <!-- should be normalized, but it is done by post processing -->
    <xsl:apply-templates select="." mode="content"/>
    <xsl:if test="../caption">
      <xsl:apply-templates select="../caption" mode="extra-caption"/>
    </xsl:if>
    <xsl:text>}&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="figure/caption" mode="extra-caption">
    <xsl:text>&#10;\\ </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Treat figure elements with figure parent elements as sub-figures. -->
  <!-- TODO: just today I learned that by the specification, a `figure`
  element is not allowed to contain other `figure` elements (nor `example`,
  `table`, or `equation` elements), and I'm not sure why any of those
  restrictions exist. In any case, I may want to update this at some point. -->
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
