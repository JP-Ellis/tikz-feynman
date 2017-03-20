status: published
title: Submitting with TikZ-Feynman
date: 2015-01-26
sort: 5
share: True
template: page_article

One of Ti*k*Z-Feynman's strengths is its simple syntax which is only possible by
having vertex positioned automatically
by [graph drawing](https://en.wikipedia.org/wiki/Graph_drawing) algorithms which
are implement in the [Lua](http://www.lua.org/) scripting language.  As a
result, LuaTeX is required to compile documents that use Ti*k*Z-Feynman.
Although LuaTeX is intended to supplant pdfTeX, the latter remains the standard
when it comes to submitting to journals and the arXiv.  Fortunately, there is a
way to both use TikZ-Feynman and still submit to journals as long as they use a
version of Ti*k*Z released after 2013.

<!-- PELICAN_END_SUMMARY -->

**Note:** *Since TikZ-Feynman was released recently, it will not yet be
installed on most TeX distributions and I provide instructions at the bottom of
this post detailing how it can be bundled easily.  Regarding arXiv in
particular, they have not updated their LaTeX packages in the past five years.
As a result, they are using a version of TikZ that is incompatible with
TikZ-Feynman.  Hopefully this will be fixed in the next few months.*

There exists a large class of graph drawing algorithms which automatically
determine the placement of vertices in a graph.  Simple graph drawing algorithms
can be implemented in pure TeX but they are not powerful enough to be produce
Feynman diagrams; on the other hand, more
complex
[force-based](https://en.wikipedia.org/wiki/Force-directed_graph_drawing)
algorithms quickly become too complex to be practical to implement purely in
TeX.  In order to implement these more complex graph drawing algorithms into
PGF/Ti*k*Z, Jannis Pohlmann used the Lua_ scripting language[^pohlmann] which
has native support provided through the LuaTeX engine.

Although LuaTeX is now considered stable and has been shipped with every TeXLive
distribution [since 2009](http://www.luatex.org/roadmap.html), they have not
reached version 1.0 yet.  As a result, most journals are reluctant to use LuaTeX
and the
arXiv
[does not](https://arxiv.org/help/submit_tex) [support LuaTeX](https://arxiv.org/help/faq/mistakes) either.
Hopefully this will all change when LuaTeX reaches version 1.0 but until then,
submitting to these journals or the arXiv can still be achieved by externalizing
the diagrams.

If you just want to know what you need to add to the preamble to make it work,
here is the code (for Linux and probably OS X).  You will need to initially
compile with `-shell-escape` and when submitting to the arXiv or a journal,
make sure to include every `.pdf` and `.md5` file inside the `pgf-img`
directory on submission.  For more details as to how this works, read on.

```latex
%% After having loaded `tikz` or `tikz-feynman`
\usetikzlibrary{external}
\immediate\write18{mkdir -p pgf-img}
\tikzexternalize[
  prefix=pgf-img/,
  system call={
    lualatex \tikzexternalcheckshellescape -halt-on-error -interaction=batchmode -jobname="\image" "\texsource" || rm "\image.pdf"
  },
]
```

Note that errors relating to a particular image will be stored inside that
images' `.log` file inside the `pgf-img` subdirectory (usually, just look
for any `.log` file which doesn't have an accompanying `.pdf`).

The Basics
==========

Ti*k*Z diagrams can become very complex which can result in very long
compilation times.  To alleviate this, Feuersänger developed the externalization
library (<a
href="http://ctan.unsw.edu.au/graphics/pgf/base/doc/pgfmanual.pdf#nameddest=Externalization
Library">§50, PGF/Ti<i>k</i>Z manual</a>) which compiles the diagrams
separately.  In particular, this library can used to to ensure that the LuaTeX
engine is used regardless of what is generating the initial document.  The most
minimal way to load the externalization library is as follows:

```latex
\usetikzlibrary{external}             %% Load the `external` library
\tikzexternalize                      %% Activate externalization
```

By default, the externalization library uses the same TeX engine to generate
diagrams as the one used to generate the main document.  We can override this by
specifying the system call to use:

```latex
\usetikzlibrary{external}             %% Load the `external` library
\tikzexternalize[                     %% Activate externalization
  system call={                       %% Use lualatex in system call
    lualatex \tikzexternalcheckshellescape -halt-on-error -interaction=batchmode -jobname="\image" "\texsource"
  },
]
```

This is the minimal configuration that will ensure Ti*k*Z-Feynman works, even if
you don't compile with the LuaTeX engine.  The disadvantage now is that the
directory will be cluttered with four new file *for each diagram*.  Combined
with all the other temporary files TeX generates, it can become quite
cumbersome.  (For example, the documentation for Ti*k*Z-Feynman contains over 60
diagrams which will result in over 240 additional files!)

To make the clutter more manageable, we can make sure that the externalization
library places all these extra files in a subdirectory.  Let's call that
`pgf-img` since it will contain all images powered by PGF.  To ensure that the
externalization library places files inside `pgf-img`, we need to prefix each
filename with `pgf-img/`.

In addition to prefixing the filenames, we also need to make sure that the
`pgf-img` directory exists beforehand, and ideally this should also be
automated.  Fortunately, TeX actually allows system calls directly from the file
through the `\write18` command.  This will require `-shell-escape` to be
used with `pdflatex` or whatever program you are compiling the master TeX file
with.

```latex
\usetikzlibrary{external}             %% Load the `external` library
\immediate\write18{mkdir -p pgf-img}  %% Create `pgf-img` directory
\tikzexternalize[                     %% Activate externalization
  prefix=pgf-img/,                    %% Avoid cluttering the directory
  system call={                       %% Use lualatex in system call
    lualatex \tikzexternalcheckshellescape -halt-on-error -interaction=batchmode -jobname="\image" "\texsource"
  },
]
```

At this stage, the above snippet of code will work most of the time but
occasionally you'll find that it fails to compile---usually after the
previous build was aborted.  This is due to the PDF from the previous run being
left in a corrupt state and then subsequent runs trying and failing to read the
corrupt PDF.  The fix for this is the delete the corrupt PDF file whenever
something goes wrong.  In `sh`, it is possible to run a program if the
previous one failed by using the *OR* operator `||` (you may have to scroll to
view the change):

```latex
\usetikzlibrary{external}             %% Load the `external` library
\immediate\write18{mkdir -p pgf-img}  %% Create `pgf-img` directory
\tikzexternalize[                     %% Activate externalization
  prefix=pgf-img/,                    %% Avoid cluttering the directory
  system call={                       %% Use lualatex in system call
    lualatex \tikzexternalcheckshellescape -halt-on-error -interaction=batchmode -jobname="\image" "\texsource"  || rm "\image.pdf"
  },
]
```

When you call you TeX engine of preference, you should see that LuaLaTeX is
invoked whenever it encounters a Ti*k*Z picture.  The `pgf-img` directory will
be populated with a `.dpth`, `.log`, `.md5` and `.pdf` file for each
picture.  The `.pdf` contains the generated picture and the `.md5` contains
a hash that is used to check whether the PDF needs to be regenerated (and if it
is missing, the PDF is always regenerated); the other two extensions are only
temporary files.

When submitting the source file, you will have to include the `.md5` and
`.pdf` files so when they compile your document, their system will simply
import the pre-generated `.pdf` instead of trying to generate them again.

Speeding It Up
==============

Each time a Ti*k*Z picture is encountered, LuaLaTeX is dispatched to generate
the PDF.  To do this, LuaLaTeX load all the packages in your preamble, the fonts
your document uses and various other system files which significantly lengthen
how much time it takes to compile the master document if it has to generate new
pictures.  Fortunately, subsequent runs will be faster and in many cases this is
not an issue.

There is no getting around the load time of LuaLaTeX (which only becomes an
issue when it needs to be loaded many times), so the only way to speed up
compilation is to run LuaLaTeX in parallel.  The externalization library has, as
one of its options, the possibility of creating a makefile which needs to be
executed separately and parallelizing a makefile is really easy.  First we need
to instruct the externalization library to generate this makefile:

```latex
\usetikzlibrary{external}             %% Load the `external` library
\immediate\write18{mkdir -p pgf-img}  %% Create `pgf-img` directory
\tikzexternalize[                     %% Activate externalization
  prefix=pgf-img/,                    %% Avoid cluttering the directory
  mode=list and make,                 %% Generate a makefile to run later
  system call={                       %% Use lualatex in system call
    lualatex \tikzexternalcheckshellescape -halt-on-error -interaction=batchmode -jobname="\image" "\texsource"  || rm "\image.pdf"
  },
]
```

After processing the master TeX file, a new `<name>.makefile` is generated and
can be executed with:

```sh
make -j 4 -f <name>.makefile
```

The `-j 4` option instructs `make` to run at most four tasks in parallel and
`-f` tells `make` which file to read (by default, it searches for
`./makefile` or `./Makefile`).

Finally, I use LatexMk in order to compile TeX files because it will
automatically run all the extra steps for bibliographies, indices, and for
changed references.  By default, it isn't configured to handle Ti*k*Z's
makefiles by this can be fixed by adding the following to `~/.latexmkrc`:

```perl
# Adapted from http://tex.stackexchange.com/a/145878/26980
# Add a few files to cleanup
push @generated_exts, 'figlist', 'ist', 'makefile', 'unq';
# On the initial run, %tikzexternalflag is set to an empty list (when
# it reads this .latexmkrc).
#
# %tikzexternalflag is then set after successfully running make.

our %tikzexternalflag = ();

$pdflatex = 'internal tikzpdflatex -shell-escape -synctex=1 %O %S %B';

sub tikzpdflatex {
    our %externalflag;
    my $n = scalar(@_);
    my @args = @_[0 .. $n - 2];
    my $base = $_[$n - 1];

    system 'lualatex', @args;
    # Exit with error on failure
    if ($? != 0) {
        return $?
    }
    if ( !defined $externalflag->{$base} ) {
        $externalflag->{$base} = 1;
        if ( -e "$base.makefile" ) {
            system ("$make -j5 -f $base.makefile");
        }
    }
    return $?;
}
```

Depending on your computer and your preferences, you may wish to replace
`'lualatex'` with whatever engine you prefer on line 18; and you may wish to
replace `-j5` on line 27 with a smaller number if you computer has fewer cores
(I have it set to be one more than the number of cores I have).

To compile the document, you now need to run `latexmk <name>.tex` once and
everything should work fine.[^latexmk]_

Bundling TikZ-Feynman
=====================

If the journal your are submitting to is using a version of Ti*k*Z released
after 2013 and they are only missing Ti*k*Z-Feynman, then you can quite easily
bundle Ti*k*Z-Feynman along with your submission.  Firstly, you will need to
obtain the appropriate version
from [Github](https://github.com/JP-Ellis/tikz-feynman/releases) and copy the
needed files to the same directory as your TeX master file.  This can be all
achieved with:

```sh
wget https://github.com/JP-Ellis/tikz-feynman/archive/v1.0.0.tar.gz -O - | tar -xz
mv tikz-feynman-1.0.0/*.code.tex tikz-feynman-1.0.0/*.sty tikz-feynman-1.0.0/*.lua .
rm -rvf tikz-feynman-1.0.0
```

Next, you need to prepare your submission to journal as usual and make sure that
all images in `pgf-img/` are up to date.  Assuming that your master file
consists of only TeX files, then you can create a tarball with everything in it
with:

```sh
tar -cavf submission.tar *.tex *.sty pgf-img/
```

Of course if you have extra dependencies, you will need to adapt the above
command to suit your needs.

The arXiv, unfortunately, has not updated their LaTeX packages in the past five
years and they are using a version of Ti*k*Z that is incompatible with
Ti*k*Z-Feynman.  They
have [announced an upgrade](https://arxiv.org/help/faq/mistakes), but until that
is complete, submission to the arXiv with Ti*k*Z-Feynman will require you to ask
permission to submit the PDF only.

[^pohlmann]:
    J. Pohlmann,
    [Configurable graph drawing algorithms for the TikZ graphics description language](http://www.tcs.uni-luebeck.de/downloads/papers/2011/2011-configurable-graph-drawing-algorithms-jannis-pohlmann.pdf),
    Masters thesis (Institute of Theoretical Computer Science, Universität zu
    Lübeck, Lübeck, Germany, 2011).

[^latexmk]: Note that on the very first run, LatexMk won't actually recompile
    the master TeX file after having generated the pictures.  This occurs only
    on the very first run.
