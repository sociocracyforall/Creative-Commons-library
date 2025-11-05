<?xml version='1.0'?>
<!-- Customizations common to all language versions of this book -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lhd="tag:publishing.house.circle@sociocracyforall.org,2025:LaTeX_hints_in_DocBook"
    xmlns:dbf="tag:publishing.house.circle@sociocracyforall.org,2025:DocBook_forms"
    lhd:prefix="lhd"
    version='1.0'>
  <!-- Don't show any list of titled items: -->
  <xsl:param name="doc.lot.show"></xsl:param>

  <xsl:param name="latex.class.book">book</xsl:param>

  <!--xsl:param name="latex.class.options">openright,twoside,10pt</xsl:param-->
  <xsl:param name="latex.class.options">openany,12pt</xsl:param>

  <!--xsl:param name="page.width">8in</xsl:param-->
  <xsl:param name="geometry.options">paperheight=10in, height=8in,
  paperwidth=7in, textwidth=5in,
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

  <xsl:param name="toc.section.depth">1</xsl:param>
  <xsl:param name="doc.section.depth">0</xsl:param>

  <xsl:param name="figure.default.position">[htbp]</xsl:param>

  <!--xsl:param name="latex.hyperparam">hyperindex=false</xsl:param-->

  <!-- Use the font from the LaTeX style definition, instead -->
  <xsl:param name="xetex.font"/>

  <!-- Alternate header name for the table of contents -->
  <xsl:param name="toc.contentsname"/>

  <!-- This is working around a strange bug: -->
  <xsl:param name="show.comments">0</xsl:param>

  <xsl:template match="*[@dbf:role]">
    <xsl:text>\begin{tcolorbox}[enhanced,%
                                spread=-0.5in,%
                                height fill,text fill,%
                                colback=white,%
                                boxrule=1mm,%
                                arc=3mm,%
                                boxsep=0.5in,%
                               ]&#10;</xsl:text>
    <xsl:text>%\pagebreak&#10;\thispagestyle{empty}&#10;</xsl:text>
    <xsl:text>\textbf{</xsl:text>
    <xsl:apply-templates select="title/node()"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:apply-templates select="node()[not(self::title)]"/>
    <xsl:text>&#10;\vfill&#10;</xsl:text>
    <xsl:variable name="form-role">
      <xsl:choose>
        <xsl:when test="@dbf:role = 'continuation'">
          <xsl:value-of select="preceding-sibling::*[1]/@dbf:role"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@dbf:role"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$form-role = 'script'">
        <xsl:text>&#10;\hfill\includegraphics{illustrations/script.png}&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="$form-role = 'worksheet'">
        <xsl:text>&#10;\hfill\includegraphics{illustrations/worksheet.png}&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;\hfill\includegraphics{illustrations/info.png}&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>\end{tcolorbox}&#10;</xsl:text>
  </xsl:template>

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
      <!--xsl:text>\vspace*{\fill}&#10;\thispagestyle{empty}&#10;</xsl:text>
      <xsl:text>
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
      <xsl:text>&#10;&#10;\vspace{0.25em}&#10;&#10;</xsl:text-->
      <xsl:apply-templates select="$nodes/node()"/>
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

  <xsl:template match="acknowledgements[@role = 'testimonials']">
    <xsl:text>\newpage&#10;\markboth{}{}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\newpage&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="acknowledgements[@role = 'testimonials']/blockquote">
    <xsl:text>\color{teal}\textit{\small </xsl:text>
    <xsl:apply-templates select="*[not(self::attribution)]"/>
    <xsl:text>}&#10;&#10;</xsl:text>
    <xsl:apply-templates select="attribution"/>
    <xsl:text>\\&#10;&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="acknowledgements[@role = 'testimonials']
                       /blockquote/attribution">
    <xsl:text>\color{black}\small </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
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

  <xsl:template match="appendix">
    <xsl:if test="not (preceding-sibling::appendix)">
      <xsl:text>% ---------------------&#10;</xsl:text>
      <xsl:text>% Appendixes start here&#10;</xsl:text>
      <xsl:text>% ---------------------&#10;</xsl:text>
      <xsl:text>\begin{appendices}&#10;</xsl:text>
    </xsl:if>
    <!-- This is taken from the `section.unnumbered.begin` named template, which is available to many "component"-level templates and mediated by a "component".toclevel parameter, which for some reason is not available for appendix elements. I think that parameter and implementation should be added upstream, but until then, we add this behavior in this overridden template. -->
    <xsl:text>\setcounter{secnumdepth}{-1}&#10;</xsl:text>
    <xsl:call-template name="set-tocdepth">
      <xsl:with-param name="depth" select="-1"/>
    </xsl:call-template>
    <xsl:call-template name="makeheading">
      <!-- raise to the highest existing book section level (part or chapter) -->
      <xsl:with-param name="level">
        <xsl:choose>
        <xsl:when test="preceding-sibling::part or
                        following-sibling::part">-1</xsl:when>
        <xsl:when test="parent::book or parent::part">0</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates/>

    <!-- restore the initial counters -->
    <xsl:text>\setcounter{secnumdepth}{</xsl:text>
    <xsl:value-of select="$doc.section.depth"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:call-template name="set-tocdepth">
      <xsl:with-param name="depth" select="$toc.section.depth"/>
    </xsl:call-template>

    <xsl:if test="not (following-sibling::appendix)">
      <xsl:text>&#10;\end{appendices}&#10;</xsl:text>
    </xsl:if>
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
        \begin{titlepage}
        \thispagestyle{empty}


        \begin{huge}\begin{center}\textbf{\color{teal}\DBKtitle}\end{center}\end{huge}
          \vspace{1em}
        \begin{Large}\begin{center}\textbf{\DBKsubtitle}\end{center}\end{Large}

        \vspace{1em}
        \begin{large}\begin{center}\textsf{\DBKauthor}\end{center}\end{large}
        % TODO: translate "by"

        \vfill


        \noindent \begin{center}\large{\textsf{Sociocracy For All}}\\
        \noindent \large{\textsf{Amherst, MA USA}}\\
        \noindent  \textsf{sociocracyforall.org}\\
        \end{center}
        \begin{figure}[h!]
        \centering
        \includegraphics[width=4cm]{illustrations/SoFAlogo.jpg}
        \end{figure}
        \end{titlepage}

        \newpage

        \maketitle
      </xsl:text>
    </xsl:if>

    <xsl:apply-templates select="dedication"/>

    <!-- Print the TOC/LOTs -->
    <xsl:if test="contains($layout, 'toc ')">
      <xsl:if test="$toc.contentsname != ''">
        <xsl:text>\renewcommand{\contentsname}{</xsl:text>
        <xsl:value-of select="$toc.contentsname"/>
        <xsl:text>}&#10;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="." mode="toc_lots"/>
    </xsl:if>

    <!-- Print the abstract and front matter content -->
    <!-- @@TODO:@@ this does have the potential to bring these elements
    out of document order. How would we want to handle this robustly
    for the general case? -->
    <xsl:apply-templates select="(abstract|$info/abstract)[1]"/>
    <xsl:apply-templates select="preface|glossary|acknowledgements"/>

    <!-- This is all in the style file, as well, but doesn't seem to work there for
    some reason. (The symptom is that only odd-numbered pages are displayed.) -->
    <xsl:text>
      \renewcommand{\chaptermark}[1]{\markboth{#1}{}}
      \renewcommand{\sectionmark}[1]{\markright{#1}}
      \pagestyle{fancy}
      \fancyhf{}
      \fancyhead[RO]{\color{teal}\leftmark}
      \fancyhead[LE]{\color{teal}\scshape\nouppercase{\DBKtitle}}
      %\fancyhead[RE,CO]{\textbf\thepage}
      %\fancyfoot[CE,CO]{\textbf\thepage}
      \fancyfoot[LE,RO]{\thepage}
      %HIERHE
      \fancyhfoffset[]{2em}
    </xsl:text>

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

  <xsl:template match="glossentry/glossterm">
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
  `\paragraph` command, unless they have a `sectional` role. -->
  <xsl:template match="formalpara">
    <xsl:choose>
      <xsl:when test="@role = 'sectional'">
        <xsl:text>&#10;{\bf </xsl:text>
        <xsl:call-template name="normalize-scape">
          <xsl:with-param name="string" select="title"/>
        </xsl:call-template>
        <xsl:text>} </xsl:text>
        <xsl:call-template name="label.id"/>
        <xsl:text>\newline</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;\paragraph{</xsl:text>
        <xsl:call-template name="normalize-scape">
          <xsl:with-param name="string" select="title"/>
        </xsl:call-template>
        <xsl:text>}&#10;</xsl:text>
        <xsl:call-template name="label.id"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- For this book, we want informalexample elements to display as a teal paragraph with no indenting. -->
  <xsl:template match="informalexample">
    <xsl:call-template name="label.id"/>
    <xsl:text>&#10;\noindent\color{teal}</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\color{black}&#10;</xsl:text>
  </xsl:template>

  <!-- We override this template to add a border below the header. -->
  <xsl:template match="informaltable" mode="newtbl.endhead">
    <xsl:param name="tabletype"/>
    <xsl:param name="headrows"/>
    <!-- xsl:apply-imports doesn't allow passing parameters in this version of
    XSLT, sadly, so we reproduce the source template instructions here. -->
    <xsl:value-of select="$headrows"/>
    <xsl:if test="$tabletype='longtable' and $headrows!=''">
      <!-- longtable endhead to put only when there's an actual head -->
      <xsl:text>\endhead&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="$headrows!=''">
      <xsl:text>\hline&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- This seems like the least-invasive place to add additional whole-table
  formatting modifications. -->
  <xsl:template name="tbl.align.begin">
    <xsl:param name="tabletype"/>

    <xsl:if test="@lhd:arraystretch">
      <xsl:text>\renewcommand{\arraystretch}{</xsl:text>
      <xsl:value-of select="@lhd:arraystretch"/>
      <xsl:text>}&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="@lhd:tabcolsep">
      <xsl:text>\setlength{\tabcolsep}{</xsl:text>
      <xsl:value-of select="@lhd:tabcolsep"/>
      <xsl:text>}&#10;</xsl:text>
    </xsl:if>

    <!-- We also call the `label.id` template here to generate labels, which is also not done for `informaltable`s in the source. Upstream this as well? -->
    <xsl:call-template name="label.id"/>

    <!-- provision for user-specified alignment -->
    <xsl:variable name="align" select="'center'"/>

    <xsl:choose>
    <xsl:when test="$tabletype = 'longtable'">
      <xsl:choose>
      <xsl:when test="$align = 'left'">
        <xsl:text>\raggedright</xsl:text>
      </xsl:when>
      <xsl:when test="$align = 'right'">
        <xsl:text>\raggedleft</xsl:text>
      </xsl:when>
      <xsl:when test="$align = 'center'">
        <xsl:text>\centering</xsl:text>
      </xsl:when>
      <xsl:when test="$align = 'justify'"></xsl:when>
      <xsl:otherwise>
        <xsl:message>Word-wrapped alignment <xsl:value-of 
            select="$align"/> not supported</xsl:message>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="alignenv">
        <xsl:call-template name="align.environment">
          <xsl:with-param name="align" select="$align"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="concat('\begin{',$alignenv,'}')"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- We override this template in order to change the vertical justification of
  the minipage that holds the graphics.

  @@TODO@@: Would be great to upstream this... -->
  <xsl:template match="mediaobject">
    <xsl:variable name="figcount"
                  select="count(ancestor::figure/mediaobject[imageobject])"/>

    <xsl:variable name="mediaobject.alone">
      <xsl:if test="self::mediaobject and not(parent::figure)
                    and not(parent::informalfigure)">
        <xsl:value-of select="1"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="idx">
      <xsl:call-template name="mediaobject.select.idx"/>
    </xsl:variable>

    <xsl:variable name="img"
                  select="(imageobject|imageobjectco)[position()=$idx]"/>

    <!-- Is there an explicit viewport handled by the image data -->
    <xsl:variable name="viewport">
      <xsl:if test="$img">
        <xsl:apply-templates select="$img/descendant::imagedata"
                             mode="viewport"/>
      </xsl:if>
    </xsl:variable>

    <!-- The global alignment here applies only if there is no explicit viewport.
         In case of a viewport, it is processed by imagedata, so keep the default
         here -->
    <xsl:variable name="align">
      <xsl:choose>
      <xsl:when test="not($img) or
                      not($img/descendant::imagedata/@align) or
                      $viewport=1">
        <xsl:value-of select="'center'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="align.environment2">
          <xsl:with-param name="align"
                          select="$img/descendant::imagedata/@align"/>
        </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--
    within a figure don't put each mediaobject into a separate paragraph, 
    to let the subfigures correctly displayed.
    -->
    <xsl:if test="$mediaobject.alone = 1">
      <xsl:text>&#10;\noindent</xsl:text>
      <xsl:variable name="valign-attvalue" select="ancestor-or-self::*/@valign"/>
      <xsl:variable name="chosen-vertical-alignment">
        <xsl:choose>
          <xsl:when test="$valign-attvalue = 'top'">t</xsl:when>
          <xsl:when test="$valign-attvalue = 'bottom'">b</xsl:when>
          <xsl:otherwise>c</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:text>\begin{minipage}[</xsl:text>
      <xsl:value-of select="$chosen-vertical-alignment"/>
      <xsl:text>]{\linewidth}&#10;</xsl:text>
      <xsl:value-of select="concat('\begin{',$align,'}&#10;')"/>
      <xsl:text>\begin{adjustbox}{valign=</xsl:text>
      <xsl:value-of select="$chosen-vertical-alignment"/>
      <xsl:text>}&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="self::inlinemediaobject">
      <xsl:text>\noindent</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$img">
        <xsl:if test="$imagedata.file.check='1'">
          <xsl:text>\imgexists{</xsl:text>
          <xsl:apply-templates
              select="$img/descendant::imagedata"
              mode="filename.get"/>
          <xsl:text>}{</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="$img"/>
        <xsl:if test="$imagedata.file.check='1'">
          <xsl:text>}{</xsl:text>
          <xsl:apply-templates select="textobject[1]"/>
          <xsl:text>}</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="textobject[1]"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- print the caption if not in a float, or is single -->
    <xsl:if test="caption and ($figcount &lt;= 1)">
      <xsl:apply-templates select="caption" mode="environment">
        <xsl:with-param name="parent-align" select="$align"/>
      </xsl:apply-templates>
    </xsl:if> 
    <xsl:if test="$mediaobject.alone = 1">
      <xsl:text>\end{adjustbox}&#10;</xsl:text>
      <xsl:value-of select="concat('\end{',$align,'}&#10;')"/>
      <xsl:text>\end{minipage}&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="entry[ancestor-or-self::*/@role = 'template']/text()">
    <xsl:text>\sffamily{</xsl:text>
    <xsl:copy/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- For this book, we wrap contents of any entry containing a list in a
  minipage environment. Do we want to promote this behavior upstream? -->
  <xsl:template match="entry" mode="output">
    <xsl:call-template name="normalize-border">
      <xsl:with-param name="string">
        <xsl:choose>
          <xsl:when test=".//listitem">
            <xsl:variable name="valign-attvalue" select="ancestor-or-self::*/@valign"/>
            <xsl:variable name="chosen-vertical-alignment">
              <xsl:choose>
                <xsl:when test="$valign-attvalue = 'top'">t</xsl:when>
                <xsl:when test="$valign-attvalue = 'bottom'">b</xsl:when>
                <xsl:otherwise>c</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:text>\begin{minipage}[</xsl:text>
            <xsl:value-of select="$chosen-vertical-alignment"/>
            <xsl:text>]{\linewidth}&#10;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>\vspace{\arrayrulewidth}&#10;\end{minipage}&#10;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@numeration[. = 'loweralpha']" mode="enumitem">
    <xsl:text>(a)</xsl:text>
  </xsl:template>

  <!-- These are elements for which no link text exists, so an xref to one
       uses the xrefstyle attribute if specified, or if not it falls back
       to the container element's link text -->
  <!-- This template is in the dblatex source, but only applies to `para`, `phrase`, `simpara`, `anchor`, and `quote` elements. I think it should also apply to `informaltable` (and perhaps others). Consider for migrating upstream? -->
  <xsl:template match="informaltable" mode="xref-to">
    <xsl:param name="referrer"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="verbose"/>

    <xsl:variable name="context" select="(ancestor::simplesect
                                         |ancestor::section
                                         |ancestor::sect1
                                         |ancestor::sect2
                                         |ancestor::sect3
                                         |ancestor::sect4
                                         |ancestor::sect5
                                         |ancestor::topic
                                         |ancestor::refsection
                                         |ancestor::refsect1
                                         |ancestor::refsect2
                                         |ancestor::refsect3
                                         |ancestor::chapter
                                         |ancestor::appendix
                                         |ancestor::preface
                                         |ancestor::partintro
                                         |ancestor::dedication
                                         |ancestor::acknowledgements
                                         |ancestor::colophon
                                         |ancestor::bibliography
                                         |ancestor::index
                                         |ancestor::glossary
                                         |ancestor::glossentry
                                         |ancestor::listitem
                                         |ancestor::varlistentry)[last()]"/>

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
            <xsl:text>"&gt; has no generated text. Trying its ancestor elements.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="$context" mode="xref-to">
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
          <xsl:with-param name="verbose" select="$verbose"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- The source uses a `SaveVerbatim` environment to store these, but I have
  no idea where that is actually defined. What's going on here? -->
  <xsl:template match="address" mode="save.verbatim"/>

  <!-- ... so we use a different strategy, at least for `address` elements.

  I think we would definitely benefit from auditing the whole verbatim
  infrastructure upstream. It's lucky that we don't use it elsewhere. -->
  <xsl:template match="address">
    <xsl:variable name="initial-result">
      <xsl:apply-templates/>
    </xsl:variable>

    <xsl:call-template name="scape-replace">
      <xsl:with-param name="string" select="$initial-result"/>
      <xsl:with-param name="from" select="'&#10;'"/>
      <xsl:with-param name="to" select="'\newline&#10;'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="phrase[@revisionflag = 'deleted']">
    <xsl:text>\sout{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- For this book, we have a few special formatting steps for particular
  table classes: -->
  <xsl:template match="tr[@class]" mode="disabled">
    <xsl:text>\rowcolor{</xsl:text>
    <xsl:value-of select="@class"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:apply-imports/>
  </xsl:template>

  <xsl:template match="td" mode="disabled">
    <xsl:variable name="is_template"
    select="@class = 'template'
            or parent::tr/parent::tbody/parent::*/@class = 'template'"/>

    <xsl:choose>
      <xsl:when test="$is_template">
        <xsl:text>\sffamily{</xsl:text>
        <xsl:apply-imports/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
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
  value.

  For this book, we use the figure environment for informalfigures as well. -->
  <xsl:template match="figure|informalfigure">
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
    <xsl:apply-templates select="self::figure" mode="caption.and.label">
      <xsl:with-param name="position.top" select="1"/>
    </xsl:apply-templates>

    <!-- <xsl:text>&#10;\centering&#10;</xsl:text> -->
    <xsl:call-template name="figure.begin"/>
    <xsl:apply-templates select="node()[not(self::title|self::caption)]"/>
    <xsl:call-template name="figure.end"/>

    <!-- title caption after the image -->
    <xsl:apply-templates select="self::figure" mode="caption.and.label">
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
