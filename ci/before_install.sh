#!/usr/bash

set -e

install_fonts() {
    wget https://bitbucket.org/georgd/eb-garamond/downloads/EBGaramond-0.016.zip
    unzip -q EBGaramond-0.016.zip -d $HOME/.fonts
    wget http://www.fantascienza.net/leonardo/ar/inconsolatag/inconsolata-g_font.zip
    unzip -q inconsolata-g_font.zip -d $HOME/.fonts
    fc-cache
}

install_texlive() {
    if [[ ! -e ./texlive/bin/x86_64-linux/tlmgr ]]; then
        wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz -O - | tar -x --gzip
        mv $(ls | grep install) install-tl
        ./install-tl/install-tl -profile ci/texlive.profile
    fi
    tlmgr install $(cat ci/texlive-dependencies)
    tlmgr update --self
    tlmgr update --all
}

install_pygments() {
    pip install -U --user pygments
}

main() {
    install_fonts
    install_texlive
    install_pygments
}

main
