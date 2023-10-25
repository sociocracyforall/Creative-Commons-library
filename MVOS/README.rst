.. default-role:: code

Many Voices One Song
====================

This directory contains materials related to the book "Many Voices One Song" by Ted J. Rau and Jerry Koch-Gonzales.  This book is part of the Sociocracy for All (SoFA) `Creative Commons library <https://github.com/sociocracyforall/Creative-Commons-library>`_, which aims to support others in accessing and contributing to SoFA open source texts.  This document describes the process we used to make the markup for this book available and provides information on how you can use these files.

First steps in this process
---------------------------

Ted and Jerry initially wrote the book in LaTeX.  When deciding to make the text and markup of the book available on GitHub, we chose to share it in `DocBook format (version 5.1) <https://docbook.org/>`_, in order to make it more generally accessible and usable.  The English version of the book (marked up in DocBook) is in the file `MVOS.en.dbk`.

We obtained DocBook markup from the original LaTeX using the following process:

#. We used `LaTeXML <https://dlmf.nist.gov/LaTeXML/>`_ to convert the LaTeX to XML.  (LaTeXML outputs `a custom XML dialect <https://dlmf.nist.gov/LaTeXML/manual/schema/>`_.)

   Using this might look like `latexml MVOS.en.tex > MVOS.en.latexml`.

#. We wrote an XSLT script, `LaTeXML2DocBook5.xslt`_, to make an initial pass at converting the LaTeXML format to DocBook 5.

   You could use `xsltproc` to run this script like this: `xsltproc LaTeXML2DocBook5.xslt MVOS.en.latexml > MVOS.en.dbk`.

#. We used `Jing <https://github.com/relaxng/jing-trang>`_ and `the DocBook 5.1 schema <https://docbook.org/schemas/5x.html>`_ to generate validation reports of the resulting DocBook file.

   .. code:: shell

      export JING=$JING_INSTALL_DIR/jing-trang/build/jing.jar
      java -jar $JING $DOCBOOK_SCHEMAS_DIR/schemas/rng/docbook.rng MVOS.en.dbk

#. From there, we used `XMLmind XML Editor`_ to manually edit the transformed file to address some validation issues and to improve the structure of several aspects of the markup that were difficult to convert automatically.

LaTeXML2DocBook5.xslt
---------------------

This XSLT script provides a *partial* conversion of the LaTeXML format to DocBook 5.1.  It only works (currently) on those parts of the markup language exercised by this book.  It **does** have features in place to prominently warn the user if it encounters an unknown tag.

XMLmind XML Editor
------------------

`XMLmind XML Editor (XXE) <https://www.xmlmind.com/xmleditor/>`_ is a powerful tool for visually editing XML documents (including DocBook files) in a way that can continuously maintain their validity.  We encourage editing the book using XXE.  If you use a text or source code editor, we ask that you validate the markup with your changes before submitting them, and that you format them in a way consistent with the way that XXE formats DocBook markup.

Converting to HTML
------------------

One easy thing you can do with the book in DocBook format is to convert it to HTML, particularly with the `DocBook XSL stylesheets project <https://github.com/docbook/xslt10-stylesheets>`_.  The XSLT script `docbook2html.xsl` contains the various parameters and customizations that we've been using for converting the book to HTML:

.. code:: shell

   XML_CATALOG_FILES=/path/to/docbook-xsl/catalog.xml xsltproc \
    docbook2html.xsl MVOS.en.dbk

Integration with Discourse
``````````````````````````

We've also begun work to integrate the book with Discourse, where each page displays comments from a Discourse topic corresponding to that page.  In order to `embed the comments on the various pages <https://meta.discourse.org/t/embedding-discourse-comments-via-javascript/31963>`_, you need to pass to the XSLT script the URL for the instance of Discourse that you'll be using.  Adding to the example above, this looks like:

.. code:: shell

   XML_CATALOG_FILES=/path/to/docbook-xsl/catalog.xml xsltproc \
     --stringparam discourse-URL https://discourse.example.org/ \
     docbook2html.xsl MVOS.en.dbk

The approach we take involves pre-populating a Discourse category with placeholder entries for each page.  After you've installed any prerequisite JavaScript Node modules that you don't already have installed, you can stub out these topics in Discourse with the `discourse-stub.js` script:

.. code:: shell

   find html/ -maxdepth 1 -name "*.html" -print0 | xargs -0 -n 1 \
   node discourse-stub.js -b https://book-server.example.org/ \
     -e https://discourse.example.org/posts \
     -k your-Api-Key -u your-Api-Username -c Discourse-category-ID \
     --prefix "A prefix for the title of every topic: " \
     --description "A generic description for every topic: "

Okay, yeah, maybe the `discourse-stub.js` script could really just be a nice (if long) line of `curl`.  Perhaps I got carried away.  In any case, this is a strategy that you could apply to other books written in DocBook, if you wanted to publish them this way.

Returning to LaTeX
------------------

.. code:: shell

   ~/development/dblatex-hg/scripts/dblatex -P latex.encoding=utf8 -t tex chapitre-1.db5
   tectonic -Z search-path=$HOME/development/dblatex-hg/latex/style/ -Z search-path=$HOME/development/dblatex-hg/latex/misc/ *tex

Work still to be done
---------------------

* Figure out how to handle the `informalexample` tag when it is nested in a `para` tag (and probably other contexts) when generating HTML using the DocBook XSL stylesheets.

* Format interal cross-references better in HTML, including figuring out how to generate page references only in print.

* Explore generating an index for the HTML version of the book.

* Play around with print formatting options.
