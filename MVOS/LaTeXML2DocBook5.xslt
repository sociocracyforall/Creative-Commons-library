<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns:l5l="http://dlmf.nist.gov/LaTeXML"
    xmlns="http://docbook.org/ns/docbook"
    exclude-result-prefixes="db l5l"
    db:prefix="db"
    version="1.0">

  <xsl:template match="*">
    <xsl:message terminate="yes"
      >Unknown element: <xsl:value-of select="name()"/></xsl:message>
  </xsl:template>

  <xsl:template match="/l5l:document">
    <book version="5.1">
      <info>
        <legalnotice>
          <title>temporary lo-fi frontmatter dumping ground</title>
          <xsl:apply-templates select="*" mode="lo-fi-frontmatter"/>
        </legalnotice>
      </info>
      <xsl:apply-templates/>
    </book>
  </xsl:template>

  <xsl:template match="*" mode="lo-fi-frontmatter">
    <xsl:message
      >Unprocessed lo-fi-frontmatter: <xsl:value-of select="name()"/></xsl:message>
  </xsl:template>

  <xsl:template match="l5l:para" mode="lo-fi-frontmatter">
    <xsl:call-template name="para"/>
  </xsl:template>

  <xsl:template match="l5l:figure[l5l:caption]" mode="lo-fi-frontmatter">
    <xsl:call-template name="figure"/>
  </xsl:template>

  <xsl:template match="l5l:figure[not(l5l:caption)]" mode="lo-fi-frontmatter">
    <xsl:call-template name="informalfigure"/>
  </xsl:template>

  <xsl:template match="/l5l:document/l5l:*" priority="-0.25">
    <xsl:message
      >Unprocessed document child: <xsl:value-of select="name()"/></xsl:message>
  </xsl:template>

  <xsl:template match="l5l:para[not(parent::l5l:document)]" name="para">
    <para>
      <xsl:apply-templates select="@labels|*"/>
    </para>
  </xsl:template>

  <xsl:template match="l5l:chapter|l5l:section|l5l:quote
                       |l5l:table|l5l:thead|l5l:tfoot|l5l:tbody">
    <xsl:element name="{local-name()}"
                 namespace="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="@labels|*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="l5l:title|l5l:tr|l5l:td">
    <xsl:element name="{local-name()}"
                 namespace="http://docbook.org/ns/docbook">
      <xsl:apply-templates select="@labels|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@labels">
    <xsl:attribute name="xml:id">
      <xsl:choose>
        <xsl:when test="contains(., ' ') and contains(., ':')">
          <xsl:message>Warning: eliding all but the first label</xsl:message>
          <xsl:value-of
            select="substring-after(substring-before(., ' '), ':')"/>
        </xsl:when>
        <xsl:when test="contains(., ':')">
          <xsl:value-of select="substring-after(., ':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="l5l:subsection|l5l:subsubsection">
    <section><xsl:apply-templates select="@labels|*"/></section>
  </xsl:template>

  <xsl:template match="l5l:paragraph">
    <xsl:message>Warning: uncertain, lossy mapping of `paragraph`</xsl:message>
    <section><xsl:apply-templates select="@labels|*"/></section>
  </xsl:template>

  <xsl:template match="l5l:table">
    <xsl:choose>
      <xsl:when test="l5l:caption">
        <table>
          <xsl:apply-templates select="@labels"/>
          <title><xsl:apply-templates select="l5l:caption"/></title>
          <xsl:apply-templates select="*[not(self::l5l:caption)]"/>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <informaltable>
          <xsl:apply-templates select="@labels|*[not(self::l5l:caption)]"/>
        </informaltable>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="l5l:p">
    <xsl:choose>
      <xsl:when test="parent::l5l:para">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:text>Warning: passing through `</xsl:text>
          <xsl:value-of select="name()"/>
          <xsl:text>` element: </xsl:text>
        </xsl:comment>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="l5l:tabular">
    <xsl:comment>
      <xsl:text>Warning: passing through `</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>` element: </xsl:text>
    </xsl:comment>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="l5l:text">
    <xsl:choose>
      <xsl:when test="@font = 'italic'">
        <emphasis role="from-text"><xsl:apply-templates/></emphasis>
      </xsl:when>
      <xsl:when test="@font = 'bold'">
        <emphasis role="bold"><xsl:apply-templates/></emphasis>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:text
            >Warning: text element with unused attributes: </xsl:text>
          <xsl:apply-templates select="@*"/>
        </xsl:comment>

        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="l5l:text/@*">
    <xsl:value-of select="name()"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>" </xsl:text>
  </xsl:template>

  <xsl:template match="l5l:break">
    <xsl:text>&#x0A;</xsl:text>
  </xsl:template>

  <xsl:template match="l5l:indexmark">
    <indexterm>
      <xsl:apply-templates select="@labels|*"/>
    </indexterm>
  </xsl:template>

  <xsl:template match="l5l:indexphrase[1]">
    <primary>
      <xsl:apply-templates/>
    </primary>
  </xsl:template>

  <xsl:template match="l5l:indexphrase[2]">
    <secondary>
      <xsl:apply-templates/>
    </secondary>
  </xsl:template>

  <xsl:template match="l5l:indexphrase[3]">
    <tertiary>
      <xsl:apply-templates/>
    </tertiary>
  </xsl:template>

  <xsl:template match="l5l:indexsee">
    <xsl:choose>
      <xsl:when test="@name = 'see also'">
        <seealso>
          <xsl:apply-templates/>
        </seealso>
      </xsl:when>
      <xsl:otherwise>
        <see>
          <xsl:apply-templates/>
        </see>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="l5l:itemize">
    <itemizedlist>
      <xsl:apply-templates select="@labels|*"/>
    </itemizedlist>
  </xsl:template>

  <xsl:template match="l5l:enumerate">
    <orderedlist>
      <xsl:apply-templates select="@labels|*"/>
    </orderedlist>
  </xsl:template>

  <xsl:template match="l5l:itemize/l5l:item|l5l:enumerate/l5l:item">
    <listitem>
      <xsl:apply-templates select="@labels|*"/>
    </listitem>
  </xsl:template>

  <xsl:template match="l5l:description">
    <variablelist>
      <xsl:apply-templates select="@labels|*"/>
    </variablelist>
  </xsl:template>

  <xsl:template match="l5l:description/l5l:item">
    <varlistentry>
      <term>
        <xsl:apply-templates select="l5l:tags/l5l:tag[not(@role)][1]/node()"/>
      </term>
      <listitem><xsl:apply-templates select="@labels|*"/></listitem>
    </varlistentry>
  </xsl:template>

  <xsl:template match="l5l:block|l5l:inline-block">
    <!-- This is currently quite brittle; we would do well to better understand
    the LaTexML document model in order to provide a more robust transformation. -->

    <!-- Is this correct? I admit that I don't really understand the LaTeXML
    schema around "blocks" (including the `block`, `inline-block`, and
    `logical-block` elements). I'm moving towards mostly just walking into
    them, as here. -->
    <xsl:choose>
      <xsl:when test="l5l:quote and count(*) = 1">
        <blockquote><para>
          <xsl:apply-templates select="@labels|l5l:quote/*"/>
        </para></blockquote>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
      <!--xsl:when test="l5l:p">
        <xsl:apply-templates select="l5l:p"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          <xsl:text>Unhandled </xsl:text>
          <xsl:value-of select="local-name()"/>
        </xsl:message>
      </xsl:otherwise-->
    </xsl:choose>
  </xsl:template>

  <xsl:template match="l5l:logical-block|l5l:sectional-block">
    <!-- Is this correct? I admit that I don't really understand the LaTeXML
    schema around "blocks" (including the `block`, `inline-block`, and
    `logical-block` elements). I'm moving towards mostly just walking into
    them, as here. -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="l5l:ref">
    <xref><xsl:apply-templates select="@labelref|node()"/></xref>
  </xsl:template>

  <xsl:template match="@labelref">
    <xsl:attribute name="linkend">
      <xsl:value-of select="substring-after(., ':')"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="l5l:emph">
    <emphasis><xsl:apply-templates select="@labels|node()"/></emphasis>
  </xsl:template>

  <xsl:template match="l5l:figure[l5l:caption and not(parent::l5l:document)]"
                name="figure">
    <figure>
      <xsl:apply-templates select="@labels|l5l:caption"/>
      <xsl:apply-templates select="l5l:graphics"/>
      <xsl:apply-templates select="*[not(self::l5l:caption|self::l5l:graphics)]"/>
    </figure>
  </xsl:template>

  <xsl:template match="l5l:figure[not(l5l:caption)
                                  and not(parent::l5l:document)]"
                name="informalfigure">
    <informalfigure>
      <xsl:apply-templates select="@labels|l5l:graphics"/>
      <xsl:apply-templates select="*[not(self::l5l:caption|self::l5l:graphics)]"/>
    </informalfigure>
  </xsl:template>

  <xsl:template match="l5l:figure/l5l:caption">
    <title><xsl:apply-templates/></title>
  </xsl:template>

  <xsl:template match="l5l:graphics">
    <mediaobject>
      <imageobject>
        <imagedata fileref="{@graphic}" width="100%"/>
      </imageobject>
    </mediaobject>
  </xsl:template>

  <xsl:template match="l5l:Math|l5l:Math//*|l5l:Math//@*">
    <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
  </xsl:template>

  <!-- Elements that we currently ignore -->
  <xsl:template match="l5l:resource|l5l:pagination|l5l:tags|l5l:tag
                       |l5l:toccaption|l5l:toctitle|l5l:index">
    <xsl:message
      >Ignored element: <xsl:value-of select="name()"/></xsl:message>
  </xsl:template>

  <!-- Display but otherwise skip ERROR elements: -->
  <xsl:template match="l5l:ERROR">
    <xsl:message
      >ERROR element, class "<xsl:value-of select="@class"/>": <xsl:value-of select="."/></xsl:message>
  </xsl:template>
</xsl:stylesheet>
