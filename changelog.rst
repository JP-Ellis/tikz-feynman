=========
Changelog
=========

:status: published
:title: Changelog
:slug: changelog
:date: 2016-02-05
:sort: 9
:share: True
:template: page_article

.. |TikZ| replace:: Ti\ *k*\ Z

In order to make it easier for people to keep up to date with new releases of
|TikZ|-Feynman, |TikZ|-Feynman's versioning approximately follows semantic
versioning, and it is recommended that users load the package with
``\usepackage[compat=x.y.z]{tikz-feynman}``.  A log of the important changes is
kept here, and a complete log of every change is kept through the `commit
history`__ on Github.

__ https://github.com/JP-Ellis/tikz-feynman/commits/master

.. PELICAN_END_SUMMARY

`Semantic versioning`__ is a way of labelling changes to a program in such a way
that users know immediately how big this change is.  In the case of
|TikZ|-Feynman, I intend to approximately follow semantic versioning:

- Changes in the third number (``1.0.0`` to ``1.0.1``) will consist of bug fixes
  and very minor changes but they should not change the output otherwise;
- Changes in the second number (``1.0.0`` to ``1.1.0``) will consist of new
  features but everything should be backwards compatible, or the backward
  incompatible change should only be very minor.  The generated output should
  remain mostly unchanged.
- Finally, changes in the first number (``1.0.0`` to ``2.0.0``) indicates a
  major change in the package and code written for ``1.0.0`` is not guaranteed
  to work on 2.0.0.

__ http://semver.org

The changes for each version are listed below, along with explanation as the
possible repercussions.


v1.1.0
======

*5th February 2016*

- Edge styles now all stack.  Originally, specifying multiple styles (such as
  ``[fermion, gluon]``) would sometimes result in the both styles being used, or
  the latter replacing the first.  Now, all edge styles are applied and stack
  thus allowing for many styles used in supersymmetry models.

- A new edge style, ``plain``, is introduced.  This allows the having with a
  straight line going through another style.  For example, ``[plain, gluon]``
  will result in a gluino.

- Simplified the use of ``every <key>``.  Originally, modifying these keys
  required one to use ``every <key>/.style={...}``, which is not necessarily the
  most intuitive.  This has been replaced with ``every <key>={...}``.


v1.0.1
======

*5th February 2016*

- Allow for ``compat=x.y.z`` as an argument when loading the package.
  |TikZ|-Feynman used to require:

  .. code-block:: latex

     \usepackage{tikz-feynman}
     \tikzfeynmanset{compat=1.0.0}

  but the new version now works with

  .. code-block:: latex

    \usepackage[compat=1.0.1]{tikz-feynman}

- Using pdfLaTeX fails gracefully.  It was always intended that |TikZ|-Feynman
  fail gracefully if LuaLaTeX isn't used and I introduced a warning to that
  effect; however, all the keys that require LuaLaTeX still caused compilations
  to fail.  Instead, every use of a key which requires LuaLaTeX produces another
  warning.

- Fix compatibility with |TikZ| ``v3.0.0``.  Although the ways versions
  ``3.0.0``, ``3.0.1`` and ``3.0.1a`` is fixed is the same, the patch file
  included had minor differences with ``3.0.0`` which caused errors.

- Allow for new lines in arguments.  For some reason, LaTeX treats new lines
  within ``#1`` in the definition of macros slightly differently to newline
  outside.  As a result, it caused the following correct code the fail

  .. code-block:: latex

     \feynmandiagram [
       large,
       vertical=a to b
     ] {
       a -- b
     };


v1.0.0
======

*19th January 2016*

- First release.

.. |---| unicode:: U+2014
