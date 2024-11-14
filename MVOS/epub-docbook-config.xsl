<?xml version='1.0'?>
<!-- Customizations common to all language versions of this book -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version='1.0'>
  <xsl:import href="http://cdn.docbook.org/release/xsl/current/xhtml5/docbook.xsl"/>
  <xsl:include href="http://cdn.docbook.org/release/xsl/current/epub3/epub3-element-mods.xsl"/>

  <xsl:param name="keep.relative.image.uris">0</xsl:param>

  <xsl:param name="base.dir">epub</xsl:param>

  <xsl:param name="formal.title.placement">
    figure after
    table after
    example after
  </xsl:param>

  <xsl:param name="section.autolabel">1</xsl:param>
  <xsl:param name="section.label.includes.component.label">1</xsl:param>
  <xsl:param name="section.autolabel.max.depth">2</xsl:param>

  <!-- Don't show any list of titled items: -->
  <xsl:param name="doc.lot.show"></xsl:param>

  <xsl:param name="doc.collab.show">0</xsl:param>

  <xsl:param name="preface.tocdepth">0</xsl:param>

  <xsl:param name="glossary.tocdepth">0</xsl:param>

  <xsl:param name="glossary.numbered">0</xsl:param>

  <xsl:param name="index.numbered">0</xsl:param>

  <xsl:param name="toc.section.depth">3</xsl:param>
  <xsl:param name="doc.section.depth">2</xsl:param>

  <!-- We're going to add some profiling on phrases based on the outputformat attribute -->
  <xsl:template match="d:phrase">
    <xsl:if test="not(@outputformat) or @outputformat = 'html'">
      <span>
        <xsl:call-template name="id.attribute"/>
        <xsl:call-template name="locale.html.attributes"/>
        <!-- We don't want empty @class values, so do not propagate empty @roles -->
        <xsl:choose>
          <xsl:when test="@role and
                         normalize-space(@role) != '' and
                         $phrase.propagates.style != 0">
            <xsl:apply-templates select="." mode="class.attribute">
              <xsl:with-param name="class" select="@role"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="class.attribute"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="dir"/>
        <xsl:call-template name="anchor"/>
        <xsl:call-template name="simple.xlink">
          <xsl:with-param name="content">
            <xsl:apply-templates/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="apply-annotations"/>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:othercredit[@class='graphicdesigner']" mode="titlepage.mode"/>
  <xsl:template match="d:biblioid[@outputformat='print']" mode="titlepage.mode"/>

  <!--
  Motivated by the LaTeX formatting, we use the parent element if the
  current element does not generate a label (for example, if it is too
  deeply nested).
  -->
  <xsl:template match="d:section|d:simplesect
                       |d:sect1|d:sect2|d:sect3|d:sect4|d:sect5
                       |d:refsect1|d:refsect2|d:refsect3|d:refsection"
                mode="xref-to">
    <xsl:param name="referrer"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="verbose" select="1"/>

    <xsl:variable name="result">
      <xsl:apply-templates select="." mode="object.xref.markup">
        <xsl:with-param name="purpose" select="'xref'"/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:variable>

    <!--xsl:message>
      <xsl:text>DEBUG (xref-to): «</xsl:text>
      <xsl:value-of select="$result"/>
      <xsl:text>»</xsl:text>
    </xsl:message-->

    <xsl:choose>
      <xsl:when test="string-length($result) &gt; 0">
        <xsl:value-of select="$result"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select=".." mode="xref-to">
          <xsl:with-param name="referrer" select="$referrer"/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="verbose" select="$verbose"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    <!-- FIXME: What about "in Chapter X"? -->
  </xsl:template>

  <xsl:template match="d:figure" mode="label.markup">
    <xsl:choose>
      <xsl:when test="@label">
        <xsl:value-of select="@label"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number format="1" from="d:book|d:article" level="any"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="d:figure/d:mediaobject" mode="label.markup">
    <xsl:choose>
      <xsl:when test="@label">
        <xsl:value-of select="@label"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number count="d:figure" format="1" from="d:book|d:article" level="any"/>
        <xsl:number count="d:mediaobject" format="(a)" from="d:figure" level="single"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="d:figure/d:mediaobject" mode="object.title.markup">
    <xsl:param name="allow-anchors" select="0"/>
    <xsl:variable name="template">
      <xsl:apply-templates select="." mode="object.title.template"/>
    </xsl:variable>

    <xsl:call-template name="substitute-markup">
      <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      <xsl:with-param name="template" select="$template"/>
      <xsl:with-param name="title" select="string(d:caption)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="d:figure/d:mediaobject/d:caption">
    <xsl:param name="caption">
      <xsl:apply-templates select=".." mode="object.title.markup">
        <xsl:with-param name="allow-anchors" select="1"/>
      </xsl:apply-templates>
    </xsl:param>
    <div>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:call-template name="id.attribute"/>
      <xsl:if test="@align = 'right' or @align = 'left' or @align='center'">
        <xsl:attribute name="align"><xsl:value-of
                           select="@align"/></xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$caption"/>
    </div>
  </xsl:template>

  <xsl:template match="d:figure/d:mediaobject"
                mode="xref-to">
    <xsl:param name="referrer"/>
    <xsl:param name="xrefstyle"/>
    <xsl:param name="verbose" select="1"/>

    <xsl:apply-templates select="." mode="object.xref.markup">
      <xsl:with-param name="purpose" select="'xref'"/>
      <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      <xsl:with-param name="referrer" select="$referrer"/>
      <xsl:with-param name="verbose" select="$verbose"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Format a glosslist as a table. This involves the templates through the
  `glossdef` template. -->
  <xsl:template match="d:glosslist">
    <xsl:variable name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:variable>
    <xsl:variable name="lowercase">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">normalize.sort.input</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="uppercase">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">normalize.sort.output</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <div>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:call-template name="id.attribute"/>
      <xsl:call-template name="anchor"/>
      <xsl:if test="d:blockinfo/d:title|d:info/d:title|d:title">
        <xsl:call-template name="formal.object.heading"/>
      </xsl:if>
      <table>
        <xsl:choose>
          <xsl:when test="$glossary.sort != 0">
            <xsl:apply-templates select="d:glossentry">
          <xsl:sort lang="{$language}" select="normalize-space(translate(concat(@sortas, d:glossterm[not(parent::d:glossentry/@sortas) or parent::d:glossentry/@sortas = '']), $lowercase, $uppercase))"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="d:glossentry"/>
          </xsl:otherwise>
        </xsl:choose>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="d:glossentry">
    <tr>
      <xsl:choose>
        <xsl:when test="$glossentry.show.acronym = 'primary'">
          <td>
            <xsl:call-template name="id.attribute">
              <xsl:with-param name="conditional">
                <xsl:choose>
                  <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="anchor">
              <xsl:with-param name="conditional">
                <xsl:choose>
                  <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>

            <xsl:choose>
              <xsl:when test="d:acronym|d:abbrev">
                <xsl:apply-templates select="d:acronym|d:abbrev"/>
                <xsl:text> (</xsl:text>
                <xsl:apply-templates select="d:glossterm"/>
                <xsl:text>)</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="d:glossterm"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:when>
        <xsl:when test="$glossentry.show.acronym = 'yes'">
          <td>
            <xsl:call-template name="id.attribute">
              <xsl:with-param name="conditional">
                <xsl:choose>
                  <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="anchor">
              <xsl:with-param name="conditional">
                <xsl:choose>
                  <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>

            <xsl:apply-templates select="d:glossterm"/>

            <xsl:if test="d:acronym|d:abbrev">
              <xsl:text> (</xsl:text>
              <xsl:apply-templates select="d:acronym|d:abbrev"/>
              <xsl:text>)</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="d:indexterm"/>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td>
            <xsl:call-template name="id.attribute">
              <xsl:with-param name="conditional">
                <xsl:choose>
                  <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="anchor">
              <xsl:with-param name="conditional">
                <xsl:choose>
                  <xsl:when test="$glossterm.auto.link != 0">0</xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>

            <xsl:apply-templates select="d:glossterm"/>
            <xsl:apply-templates select="d:indexterm"/>
          </td>
        </xsl:otherwise>
      </xsl:choose>

      <td>
        <xsl:apply-templates select="d:glosssee|d:glossdef"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="d:glossentry/d:glossdef">
    <div>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:call-template name="id.attribute"/>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates select="*[local-name(.) != 'glossseealso']"/>
      <xsl:if test="d:glossseealso">
        <p>
          <xsl:variable name="template">
            <xsl:call-template name="gentext.template">
              <xsl:with-param name="context" select="'glossary'"/>
              <xsl:with-param name="name" select="'seealso'"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="title">
            <xsl:apply-templates select="d:glossseealso"/>
          </xsl:variable>
          <xsl:call-template name="substitute-markup">
            <xsl:with-param name="template" select="$template"/>
            <xsl:with-param name="title" select="$title"/>
          </xsl:call-template>
        </p>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="d:informalfigure[@role='guide']">
    <xsl:param name="class">
      <xsl:apply-templates select="." mode="class.value"/>
      <xsl:text> guide</xsl:text>
    </xsl:param>

    <div class="{$class}">
      <xsl:call-template name="id.attribute"/>
      <xsl:if test="$spacing.paras != 0"><p/></xsl:if>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates/>
      <xsl:if test="$spacing.paras != 0"><p/></xsl:if>
    </div>
  </xsl:template>

  <!-- Display preferred index terms in bold -->
  <xsl:template match="indexterm/@significance" mode="TODO">
    <xsl:choose>
      <xsl:when test=". = 'preferred'">
        <xsl:text>|textbf</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- For this book, we want formalpara elements to use the LaTeX
  `\paragraph` command. -->
  <xsl:template match="formalpara" mode="TODO">
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
  <xsl:template match="informalexample" mode="TODO">
    <xsl:call-template name="label.id"/>
    <xsl:text>&#10;\begin{quote}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;\end{quote}&#10;</xsl:text>
  </xsl:template>

  <!-- This special role of informalfigure uses a custom environment that is defined
  in the LaTeX custom style file. -->
  <xsl:template match="informalfigure[@role = 'guide']" mode="TODO">
    <xsl:text>\begin{quotationb}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{quotationb}&#10;</xsl:text>
    <xsl:apply-templates select="." mode="foottext"/>
  </xsl:template>

  <xsl:template match="footnote[ancestor::informalfigure[@role = 'guide']]" mode="TODO">
    <xsl:text>\footnotemark{}</xsl:text>
  </xsl:template>

  <xsl:template match="informalfigure[@role = 'guide']/para" mode="TODO">
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
  <xsl:template match="figure" mode="TODO">
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
  <xsl:template match="figure[@xml:id = 'decision-makingtoolsmeasures']" mode="TODO">
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
  <xsl:template match="figure/title" mode="format.titleTODO">
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
  <xsl:template match="figure/figure" mode="TODO">
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

  <xsl:template match="figure/figure/title" mode="TODO">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$mediaobject.caption.style"/>
    <xsl:text> </xsl:text>
    <!-- Apply templates to render captions elements -->
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="figure/figure/title" mode="subfigureTODO">
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
