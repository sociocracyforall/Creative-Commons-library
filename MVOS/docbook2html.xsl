<?xml version='1.0'?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    exclude-result-prefixes="d"
    version="1.0">
  <xsl:import href="http://cdn.docbook.org/release/xsl/current/html/chunkfast.xsl"/>

  <xsl:param name="discourse-URL"/>

  <xsl:param name="chunker.output.indent">yes</xsl:param>

  <xsl:param name="section.autolabel" select="true()"/>
  <xsl:param name="section.label.includes.component.label" select="true()"/>
  <xsl:param name="img.src.path">images/</xsl:param>
  <xsl:param name="base.dir">html/</xsl:param>
  <xsl:param name="use.id.as.filename" select="true()"/>
  <xsl:param name="generate.id.attributes" select="true()"/>
  <!-- TODO: figure out how to make each section header include a link to itself -->
  <xsl:param name="html.stylesheet">style.css</xsl:param>

  <xsl:param name="local.l10n.xml" select="document('')"/>
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="en">
      <l:gentext key="nav-prev" text="&#x21A2;"/>
      <l:gentext key="nav-next" text="&#x21A3;"/>
      <l:gentext key="nav-home" text="About this book"/>
    </l:l10n>
  </l:i18n>

  <xsl:param name="header.rule" select="false()"/>
  <xsl:param name="footer.rule" select="false()"/>

  <xsl:template name="user.footer.navigation">
    <xsl:if test="$discourse-URL">
<div id='discourse-comments'></div>

<script type="text/javascript">
  window.DiscourseEmbed = {
    discourseUrl: '<xsl:value-of select="$discourse-URL"/>',
    discourseEmbedUrl: window.location.href,
    // topicId: number,
  };

  (function() {
    var d = document.createElement('script'); d.type = 'text/javascript'; d.async = true;
    d.src = window.DiscourseEmbed.discourseUrl + 'javascripts/embed.js';
    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(d);
  })();
</script>
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:book/d:info/d:title" mode="titlepage.mode">
    <xsl:variable name="id">
      <xsl:choose>
        <!-- if title is in an *info wrapper, get the grandparent -->
        <xsl:when test="contains(local-name(..), 'info')">
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select="../.."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select=".."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:apply-templates select="../d:cover/*"/>

    <h1>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:choose>
        <xsl:when test="$generate.id.attributes = 0">
          <a name="{$id}"/>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="$show.revisionflag != 0 and @revisionflag">
          <span class="{@revisionflag}">
            <xsl:apply-templates mode="titlepage.mode"/>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="titlepage.mode"/>
        </xsl:otherwise>
      </xsl:choose>
    </h1>
  </xsl:template>

  <xsl:template name="header.navigation">
    <xsl:param name="prev" select="/d:foo"/>
    <xsl:param name="next" select="/d:foo"/>
    <xsl:param name="nav.context"/>

    <xsl:variable name="home" select="/*[1]"/>
    <xsl:variable name="up" select="parent::*"/>

    <xsl:variable name="row1" select="$navig.showtitles != 0"/>
    <xsl:variable name="row2" select="count($prev) &gt; 0
                                      or (count($up) &gt; 0 
                                          and generate-id($up) != generate-id($home)
                                          and $navig.showtitles != 0)
                                      or count($next) &gt; 0"/>

    <xsl:if test="$suppress.navigation = '0' and $suppress.header.navigation = '0'">
      <div class="nav navheader">
        <xsl:if test="$row1 or $row2">
          <table width="100%" summary="Navigation header">
            <xsl:if test="$row1">
              <tr>
                <td class="orglogo">
                  <a href="https://www.sociocracyforall.org/"
                    ><img src="images/logo-Sofa_with-name_long_white.png"
                          alt="Sociocracy For All"/>
                  </a>
                </td>
                <th align="center">
                  <!-- If I want to try to pursue the thread of eliding the title prefix (e.g. "Chapter N: ") in contexts like these, this is a place to start, following the thread in `common/gentext.xsl`, with templates for this mode. -->
                  <xsl:apply-templates select="." mode="object.title.markup"/>
                </th>
                <td> </td>
              </tr>
            </xsl:if>

            <xsl:if test="$row2">
              <tr>
                <td class="navbutton" width="20%" align="{$direction.align.start}">
                  <xsl:if test="count($prev)>0">
                    <a accesskey="p">
                      <xsl:attribute name="href">
                        <xsl:call-template name="href.target">
                          <xsl:with-param name="object" select="$prev"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:call-template name="navig.content">
                        <xsl:with-param name="direction" select="'prev'"/>
                      </xsl:call-template>
                    </a>
                  </xsl:if>
                  <xsl:text>&#160;</xsl:text>
                </td>
                <th width="60%" align="center">
                  <xsl:choose>
                    <xsl:when test="count($up) > 0
                                    and generate-id($up) != generate-id($home)
                                    and $navig.showtitles != 0">
                      <xsl:apply-templates select="$up" mode="object.title.markup"/>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>
                </th>
                <td class="navbutton" width="20%" align="{$direction.align.end}">
                  <xsl:text>&#160;</xsl:text>
                  <xsl:if test="count($next)>0">
                    <a accesskey="n">
                      <xsl:attribute name="href">
                        <xsl:call-template name="href.target">
                          <xsl:with-param name="object" select="$next"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:call-template name="navig.content">
                        <xsl:with-param name="direction" select="'next'"/>
                      </xsl:call-template>
                    </a>
                  </xsl:if>
                </td>
              </tr>
            </xsl:if>
          </table>
        </xsl:if>
        <xsl:if test="$header.rule != 0">
          <hr/>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template name="footer.navigation">
    <xsl:param name="prev" select="/d:foo"/>
    <xsl:param name="next" select="/d:foo"/>
    <xsl:param name="nav.context"/>

    <xsl:variable name="home" select="/*[1]"/>
    <xsl:variable name="up" select="parent::*"/>

    <xsl:variable name="row1" select="count($prev) &gt; 0
                                      or count($up) &gt; 0
                                      or count($next) &gt; 0"/>

    <xsl:variable name="row2" select="($prev and $navig.showtitles != 0)
                                      or (generate-id($home) != generate-id(.)
                                          or $nav.context = 'toc')
                                      or ($chunk.tocs.and.lots != 0
                                          and $nav.context != 'toc')
                                      or ($next and $navig.showtitles != 0)"/>

    <xsl:if test="$suppress.navigation = '0' and $suppress.footer.navigation = '0'">
      <div class="nav navfooter">
        <xsl:if test="$footer.rule != 0">
          <hr/>
        </xsl:if>

        <xsl:if test="$row1 or $row2">
          <table width="100%" summary="Navigation footer">
            <xsl:if test="$row1">
              <tr>
                <td class="navbutton" width="40%" align="{$direction.align.start}">
                  <xsl:if test="count($prev)>0">
                    <a accesskey="p">
                      <xsl:attribute name="href">
                        <xsl:call-template name="href.target">
                          <xsl:with-param name="object" select="$prev"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:call-template name="navig.content">
                        <xsl:with-param name="direction" select="'prev'"/>
                      </xsl:call-template>
                    </a>
                  </xsl:if>
                  <xsl:text>&#160;</xsl:text>
                </td>
                <td width="20%" align="center">
                  <xsl:choose>
                    <xsl:when test="count($up)&gt;0
                                    and generate-id($up) != generate-id($home)">
                      <a accesskey="u">
                        <xsl:attribute name="href">
                          <xsl:call-template name="href.target">
                            <xsl:with-param name="object" select="$up"/>
                          </xsl:call-template>
                        </xsl:attribute>
                        <xsl:call-template name="navig.content">
                          <xsl:with-param name="direction" select="'up'"/>
                        </xsl:call-template>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="navbutton" width="40%" align="{$direction.align.end}">
                  <xsl:text>&#160;</xsl:text>
                  <xsl:if test="count($next)>0">
                    <a accesskey="n">
                      <xsl:attribute name="href">
                        <xsl:call-template name="href.target">
                          <xsl:with-param name="object" select="$next"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:call-template name="navig.content">
                        <xsl:with-param name="direction" select="'next'"/>
                      </xsl:call-template>
                    </a>
                  </xsl:if>
                </td>
              </tr>
            </xsl:if>

            <xsl:if test="$row2">
              <tr>
                <td width="40%" align="{$direction.align.start}" valign="top">
                  <xsl:if test="$navig.showtitles != 0">
                    <xsl:if test="count($prev)>0">
                      <a accesskey="p">
                        <xsl:attribute name="href">
                          <xsl:call-template name="href.target">
                            <xsl:with-param name="object" select="$prev"/>
                          </xsl:call-template>
                        </xsl:attribute>
                        <xsl:apply-templates select="$prev" mode="object.title.markup"/>
                      </a>
                    </xsl:if>
                  </xsl:if>
                  <xsl:text>&#160;</xsl:text>
                </td>
                <td width="20%" align="center">
                  <xsl:choose>
                    <xsl:when test="$home != . or $nav.context = 'toc'">
                      <a accesskey="h">
                        <xsl:attribute name="href">
                          <xsl:call-template name="href.target">
                            <xsl:with-param name="object" select="$home"/>
                          </xsl:call-template>
                        </xsl:attribute>
                        <xsl:call-template name="navig.content">
                          <xsl:with-param name="direction" select="'home'"/>
                        </xsl:call-template>
                      </a>
                      <xsl:if test="$chunk.tocs.and.lots != 0 and $nav.context != 'toc'">
                        <xsl:text>&#160;|&#160;</xsl:text>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>

                  <xsl:if test="$chunk.tocs.and.lots != 0 and $nav.context != 'toc'">
                    <a accesskey="t">
                      <xsl:attribute name="href">
                        <xsl:value-of select="$chunked.filename.prefix"/>
                        <xsl:apply-templates select="/*[1]"
                                             mode="recursive-chunk-filename">
                          <xsl:with-param name="recursive" select="true()"/>
                        </xsl:apply-templates>
                        <xsl:text>-toc</xsl:text>
                        <xsl:value-of select="$html.ext"/>
                      </xsl:attribute>
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key" select="'nav-toc'"/>
                      </xsl:call-template>
                    </a>
                  </xsl:if>
                </td>
                <td width="40%" align="{$direction.align.end}" valign="top">
                  <xsl:text>&#160;</xsl:text>
                  <xsl:if test="$navig.showtitles != 0">
                    <xsl:if test="count($next)>0">
                      <a accesskey="n">
                        <xsl:attribute name="href">
                          <xsl:call-template name="href.target">
                            <xsl:with-param name="object" select="$next"/>
                          </xsl:call-template>
                        </xsl:attribute>
                        <xsl:apply-templates select="$next" mode="object.title.markup"/>
                      </a>
                    </xsl:if>
                  </xsl:if>
                </td>
              </tr>
            </xsl:if>
          </table>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
