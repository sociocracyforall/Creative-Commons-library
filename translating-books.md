# The workflow for translating SoFAN books

What do you need to do in order to translate one of the books that SoFAN authors have released under a Creative Commons license? (For any of these topics, please contact Publishing House Circle or submit an issue report on GitHub if you have questions or requests.)

## Considerations while translating

There are a few things that you may want to consider before you get started with the translation work. In general, you should try to stay focused on the **content** of the book, without too much concern for how it will ultimately be formatted. (Formatting, and, ultimately, publishing your translation is our side of the work.) Some of these suggestions do help to ensure that the formatting will go smoothly, however.

If you are working with a team, your whole team should discuss how you want to stay **consistent**, particularly with respect to how you want to translate important words, phrases, and idioms from the source text. One strategy that has been successful for other teams is to create a **translation glossary** before starting your translation that can serve as a reference as you do that work. You may want to discuss how you can use **punctuation** consistently across your team, and that in lines of text you identify spaces that should not allow the line to break, such as spaces that surround puntuation that should not start a line. Dashes are a good example: if you are writing something like "phrase⍽—␣second phrase", you don't want the dash to start the line, so the first space should be a non-breaking space, while the second is not. In addition, you and your team may need to decide how you want to use gendered nouns with a goal towards inclusivity.

You may need to make decisions around the **locale** that accompanies the language of your translation. For example, when translating into French, there are differences in word choice, punctuation, and idiom that accompany the use of French in France in contrast to the use of French in Canada (and there are certainly more nuanced differences within both areas).

We suggest that you have at least one or two additional people review the translation, particularly if the first pass at the translation is done by an automated system (such as DeepL). Some of the goals of this review process include ensuring the overall quality of the text and trying to stay true to the author's intent and tone.

As part of the publishing process, there are a few things that need to be translated in addition to the text of the book. You will need to translate the text from the book cover as well as the description and keywords that accompany the book in an Internet database or store. You should also add a section providing acknowledgments to your translation team, circle, or organization. You may also want to include a section that describes any decisions that you made during your translation process; this could be part of the same section that provides acknowledgments to your team.

Many of our books have links (URLs) to webpages on our website that are in English. You should decide early on if you want to alert the reader to the fact that the links are in English, or if you want to do something like develop a translated or localized page (with a new URL). Similarly, many of our books have references to other books or articles that are in English; you will need to decide if you want to try to find translations to reference, leave the English citations, or remove the citations.

As we discuss in the next section, you will be editing text that is tagged using the DocBook markup language. In many cases you can use the markup that is present in the source text, but cross-references require some care. Cross-references use the `xref` tag with a `linkend` attribute that points to the identifier of the reference. You should treat the `xref` as the full proper noun grammatically in a sentence. This is a point where a bit of training may be useful; ask your collaborator in Publishing House Circle for more orientation around this.

(To mention: thinking about different types of publication targets.)

## Accessing the files you need

You will need to locate and obtain the file or files for the book that you want to translate. We currently have source files for the books titled (in English) ["Many Voices One Song"](MVOS), ["Who Decides Who Decides"](WDWD), and ["Let's Decide Together"](LDT). (I am interested in making "From Here To There" available soon as well.) Each of these folders contains other folders corresponding to the language of the book.

We encourage you to translate the [DocBook](https://docbook.org/) sources of the book, which have a `.dbk` file extension. DocBook (an XML dialect) is a text-oriented document language, so you can edit it with a text editor. For a more fluent editing experience, though, I like using, and recommend, a graphical front-end called [XMLmind XML Editor](https://www.xmlmind.com/xmleditor/).

Each of these books has a collection of graphics that you will need to reference in your translated text, and many of them include text that you will need to translate. These graphics are not stored in GitHub, so you will need to contact your collaborator in Publishing House Circle to obtain these pictures.

## Version control and Git

If you want to use Git directly for version control, you might want to look over [chapter 2 of the "Pro Git" book](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) (and perhaps [chapter 1](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control) for more background). For more on interacting with GitHub specifically, you could refer to [chapter 6](https://git-scm.com/book/en/v2/GitHub-Account-Setup-and-Configuration). Otherwise, you can choose the "Download raw file" button on GitHub, edit that file directly, and send changes to your collaborator in Publishing House Circle, and then that person can do the work of integrating those changes. In the medium and long term, we would gain benefits of power and clarity around editing from all using the version control tool, but it does require some learning.
