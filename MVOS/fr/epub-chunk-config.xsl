<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                version="1.0"
                exclude-result-prefixes="d">
  <!-- Import the element customization module, shown below -->
  <xsl:import href="epub-docbook-config.xsl"/>

  <!-- import stock DocBook XSL file; use a catalog for local files -->
  <xsl:import href="http://cdn.docbook.org/release/xsl/current/xhtml/chunk-common.xsl"/>

  <xsl:include href="../epub-chunk-config.xsl"/>

  <!-- include (not import) stock DocBook XSL file;
  use a catalog for local files-->
  <xsl:include href="http://cdn.docbook.org/release/xsl/current/xhtml/chunk-code.xsl"/>

  <!-- include (not import) stock DocBook XSL file;
  use a catalog for local files-->
  <xsl:include href="http://cdn.docbook.org/release/xsl/current/epub3/epub3-chunk-mods.xsl"/>

  <!-- Add here any templates that change chunking behavior.
  That is, any templates copied from chunk-common.xsl or
  chunk-core.xsl and modified.  Any such customized templates
  with a @match attribute must also have a priority="1"
  attribute to override the original in chunk-code.xsl -->
</xsl:stylesheet>
