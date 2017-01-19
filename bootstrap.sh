#!/bin/sh
HERE=`pwd`
NVIM_INST=`pwd`/nvim-inst
NVIM_SRC=`pwd`/neovim

case `uname` in
    OpenBSD)
        MAKE=gmake
        LNFILE="ln -sfh"
        ;;
    *)
        MAKE=make
        LNFILE="ln -sfT"
        ;;
esac

install_neovim() {
    if [ -d ${NVIM_INST} ]; then
        echo "${NVIM_INST} already exists"
        exit 1
    fi
    if [ -d ${NVIM_SRC} ]; then
        echo "${NVIM_SRC} already exists"
        exit 1
    fi

    git clone --depth 1 https://github.com/neovim/neovim.git || exit $?
    cd ${NVIM_SRC} || exit $?

    # For OpenBSD, define autotools versions
    export AUTOMAKE_VERSION=1.15
    export AUTOCONF_VERSION=2.69

    ${MAKE} CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${NVIM_INST}" || exit $?
    ${MAKE} install || exit $?
}

cat <<EOD
This script will install Edd's vimkit in ${HOME}.

This will force link ~/.vim, ~/.vimrc and ~/.gvimrc.

Are you sure [Enter/^C]?
EOD

read x

install_neovim
${LNFILE} ${HERE}/.vimrc ~/.vimrc || exit $?
${LNFILE} ${HERE}/.gvimrc ~/.gvimrc || exit $?
${LNFILE} ${HERE}/.vim ~/.vim || exit $?

mkdir -p ~/.config || exit $?
${LNFILE} ${HERE}/.vim ~/.config/nvim
${LNFILE} ${HERE}/.vimrc ~/.config/nvim/init.vim

# Kicks off install
${NVIM_INST}/bin/nvim || exit $?

echo "Bootstrap success!"
echo "Don't forget to put ${NVIM_INST}/bin into your path and alias vim to nvim"
