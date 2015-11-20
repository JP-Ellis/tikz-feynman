#!/bin/sh

echo "START: pre-push hook"

commit_hash=$(git rev-parse --short HEAD)
echo "Cleaning LaTeX output."
latexmk -c
echo "Regenerating LaTeX output."
latexmk tikz-feynman
if [[ $? -ne 0 ]]; then
    echo "LatexMk exited with code $?" >&2
    exit $?
fi
echo "Copying new pdf."
cp tikz-feynman.pdf pages/tikz-feynman.pdf
cd pages
echo "Committing pages."
git add --all
git commit -m "Update to ${commit_hash}."
git push
