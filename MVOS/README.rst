.. default-role:: code

Many Voices One Song
====================

This directory contains materials related to the book "Many Voices One Song" by Ted J. Rau and Jerry Koch-Gonzales.

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

One easy thing you can do with the book in DocBook format is to convert it to HTML, particularly with the `DocBook XSL stylesheets project <https://github.com/docbook/xslt10-stylesheets>`_.  Here's one command line with these scripts that we've been playing with:

.. code:: shell

   xsltproc \
     --stringparam section.autolabel 1 \
     --stringparam section.label.includes.component.label 1 \
     --stringparam img.src.path images/ \
     --stringparam base.dir html/ \
     $DOCBOOK_XSL_DIR/html/chunkfast.xsl MVOS.en.dbk

Work still to be done
---------------------

* Figure out how to handle the `informalexample` tag when it is nested in a `para` tag (and probably other contexts) when generating HTML using the DocBook XSL stylesheets.

* Format interal cross-references better in HTML, including figuring out how to generate page references only in print.

* Play around with options for adding attractive style to the HTML version of the book.

* Explore generating an index for the HTML version of the book.

* Play around with print formatting options.
