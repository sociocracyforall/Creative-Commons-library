# Authoring new SoFAN books

Books in this repository are written for publication by SoFAN under a Creative Commons license. This document provides an overview of the tools and processes for authoring a new book. Publishing House Circle holds the domain for maintaining this document and organizing this repository. Before you get started on writing a book, please see the Publishing House policy handbook and contact Publishing House Circle for support in organizing your project.

## Considerations while writing

There are a few things that you may want to consider before you get started with writing your text. In general, you should try to stay focused on the **content** of the book, without too much concern for how it will ultimately be formatted. (Formatting, and, ultimately, publishing the text is our side of the work.) Some of these suggestions do help to ensure that the formatting will go smoothly, however.

When you are working with an editor or with other authors, your whole team should discuss how you want to stay **consistent**, particularly with respect to how you want to present key words, phrases, and ideas. You may want to consider how you can use **punctuation** consistently across your text, and that in lines of text you identify spaces that should not allow the line to break, such as spaces that surround puntuation that should not start a line. Dashes are a good example: if you are writing something like "phrase⍽—␣second phrase", you don't want the dash to start the line, so the first space should be a non-breaking space, while the second is not. In addition, you and your team may need to decide how you want to use gendered nouns with a goal towards inclusivity.

As we discuss in the next section, you will be authoring text that is tagged using the DocBook markup language. Note that working with cross-references require some care. Cross-references use the `xref` tag with a `linkend` attribute that points to the identifier of the reference. You should treat the `xref` as the full proper noun grammatically in a sentence. This is a point where a bit of training may be useful; ask your collaborator in Publishing House Circle for more orientation around this.

(To mention: thinking about different types of publication targets.)

## Where and how to save your book

We use [DocBook](https://docbook.org/) as the source file format for the text of our books. DocBook (an XML dialect) is a text-oriented document language, so you can edit it with a text editor. For a more fluent editing experience, though, we recommend a graphical front-end called [XMLmind XML Editor](https://www.xmlmind.com/xmleditor/). We will store your source files in GitHub. You should store any pictures that you develop for your book in our shared Google Drive. Members of Publishing House Circle can help orient you to these tools.

## Version control and Git

If you want to use Git directly for version control, you might want to look over [chapter 2 of the "Pro Git" book](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) (and perhaps [chapter 1](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control) for more background). For more on interacting with GitHub specifically, you could refer to [chapter 6](https://git-scm.com/book/en/v2/GitHub-Account-Setup-and-Configuration). Otherwise, you can submit the DocBook files for your book directly to your collaborator in Publishing House Circle, and then that person can do the work integrating changes into the repository. In the medium and long term, we would gain benefits of power and clarity around editing from all using the version control tool, but it does require some learning.
