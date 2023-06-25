#!/usr/bash

set -e

test_pdflatex() {
    pdflatex --halt-on-error ci/test.tex
}

test_lualatex() {
    lualatex --halt-on-error ci/test.tex
    lualatex --halt-on-error tikz-feynman.tex
}

main() {
    test_pdflatex
    test_lualatex
}

main
