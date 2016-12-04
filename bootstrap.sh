#!/bin/sh
HERE=`pwd`
NVIM_PATH=`pwd`/nvim-inst

install_neovim() {
    if [ -d neovim ]; then return; fi
    git clone https://github.com/neovim/neovim.git || exit $?
    cd neovim || exit $?

    # For OpenBSD, define autotools versions
    export AUTOMAKE_VERSION=1.15
    export AUTOCONF_VERSION=2.69

    gmake CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${NVIM_PATH}" || exit $?
    gmake install || exit $?
}

cat <<EOD
This script will install Edd's vimkit in ${HOME}.

This will force link ~/.vim, ~/.vimrc and ~/.gvimrc.

Are you sure [Enter/^C]?
EOD

read x

install_neovim
ln -sf ${HERE}/.vimrc ~/.vimrc || exit $?
ln -sf ${HERE}/.gvimrc ~/.gvimrc || exit $?
ln -hsf ${HERE}/.vim ~/.vim || exit $?

mkdir -p ~/.config || exit $?
ln -hsf ${HERE}/.vim ~/.config/nvim
ln -sf ${HERE}/.vimrc ~/.config/nvim/init.vim

# Kicks off install
vim || exit $?

echo "Bootstrap success!"
echo "Don't forget to put ${NVIM_PATH} into your path and alias vim to nvim"
