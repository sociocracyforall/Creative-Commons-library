# Configuration file for `latexmk`
#
# The naming convention for this file indicated in the latexmk(1) man page
# is `latexmkrc`, but the current name is different so that we have to be
# explicit about loading it, and so that we can clearly see that it is
# actually a Perl script.

$makeindex = 'texindy -L french %O -o %D %S';
