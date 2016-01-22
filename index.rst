============
TikZ-Feynman
============

:status: published
:title: TikZ-Feynman
:slug: tikz-feynman
:date: 2015-01-19
:sort: 1
:template: page_index
:share: True
:github: https://github.com/JP-Ellis/tikz-feynman/
:release: True

|TikZ|-Feynman is a LaTeX package allowing Feynman diagrams to be easily
generated within LaTeX with minimal user instructions and without the need of
external programs.  It builds upon the |TikZ|__ package and leverages the graph
placement algorithms from |TikZ| in order to automate the placement of many
vertices.  |TikZ|-Feynman still allows fine-tuned placement of vertices so that
even complex diagrams can still be generated with ease.

.. PELICAN_END_SUMMARY

__ https://ctan.org/pkg/pgf

|TikZ|-Feynman is made available through the `Comprehensive TeX Archive Network
(CTAN) <https://ctan.org/pkg/tikz-feynman>`_ and comes with some thorough
`documentation <{attach}/pages/projects/tikz-feynman/tikz-feynman.pdf>`_
containing a tutorial and many examples.  I have also submitted the
documentation for ``v1.0.0`` on `the arXiv`__ so if you find this package
useful, please consider adding a citation.

__ http://arxiv.org/abs/1601.05437

|TikZ|-Feynman is open source and contribution are welcome.  If you have any
suggestions, feature requests, or have found any bugs, feel free to create a new
issue or pull request on `Github <https://github.com/JP-Ellis/tikz-feynman>`_.

Below are a few example to demonstrate how easy diagram can be, and how
extensible it can be.  Many more are given in the
`documentation <{attach}/pages/projects/tikz-feynman/tikz-feynman.pdf>`_:

.. image:: {attach}/pages/projects/tikz-feynman/images/qed.png
           :width: 300px
           :alt: QED Example
           :align: center

.. code-block:: LaTeX

   \feynmandiagram [horizontal=a to b] {
     i1 -- [fermion] a -- [fermion] i2,
     a -- [photon] b,
     f1 -- [fermion] b -- [fermion] f2,
   };

.. image:: {attach}/pages/projects/tikz-feynman/images/penguin.png
           :width: 300px
           :alt: Penguin Example
           :align: center

.. code-block:: LaTeX

   \feynmandiagram [large, vertical=e to f] {
     a -- [fermion] b -- [photon, momentum=\(k\)] c -- [fermion] d,
     b -- [fermion, momentum'=\(p_{1}\)] e -- [fermion, momentum'=\(p_{2}\)] c,
     e -- [gluon]  f,
     h -- [fermion] f -- [fermion] i;
   };

.. image:: {attach}/pages/projects/tikz-feynman/images/mixing.png
           :width: 490px
           :alt: Mixing Example
           :align: center

.. code-block:: LaTeX

   \begin{tikzpicture}
     \begin{feynman}
       \vertex (a1) {\(\overline b\)};
       \vertex[right=1cm of a1] (a2);
       \vertex[right=1cm of a2] (a3);
       \vertex[right=1cm of a3] (a4) {\(b\)};
       \vertex[right=1cm of a4] (a5);
       \vertex[right=2cm of a5] (a6) {\(u\)};

       \vertex[below=2em of a1] (b1) {\(d\)};
       \vertex[right=1cm of b1] (b2);
       \vertex[right=1cm of b2] (b3);
       \vertex[right=1cm of b3] (b4) {\(\overline d\)};
       \vertex[below=2em of a6] (b5) {\(\overline d\)};

       \vertex[above=of a6] (c1) {\(\overline u\)};
       \vertex[above=2em of c1] (c3) {\(d\)};
       \vertex at ($(c1)!0.5!(c3) - (1cm, 0)$) (c2);

       \diagram* {
         {[edges=fermion]
           (b1) -- (b2) -- (a2) -- (a1),
           (b5) -- (b4) -- (b3) -- (a3) -- (a4) -- (a5) -- (a6),
         },
         (a2) -- [boson, edge label=\(W\)] (a3),
         (b2) -- [boson, edge label'=\(W\)] (b3),

         (c1) -- [fermion, out=180, in=-45] (c2) -- [fermion, out=45, in=180] (c3),
         (a5) -- [boson, bend left, edge label=\(W^{-}\)] (c2),
       };

       \draw [decoration={brace}, decorate] (b1.south west) -- (a1.north west)
             node [pos=0.5, left] {\(B^{0}\)};
       \draw [decoration={brace}, decorate] (c3.north east) -- (c1.south east)
             node [pos=0.5, right] {\(\pi^{-}\)};
       \draw [decoration={brace}, decorate] (a6.north east) -- (b5.south east)
             node [pos=0.5, right] {\(\pi^{+}\)};
     \end{feynman}
   \end{tikzpicture}

.. |TikZ| replace:: Ti\ *k*\ Z
