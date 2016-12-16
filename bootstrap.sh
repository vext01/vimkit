#!/bin/sh
HERE=`pwd`
NVIM_PATH=`pwd`/nvim-inst

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
    if [ -d nvim-inst.old ]; then
        rm -rf nvim-inst.old || exit $?
    fi
    if [ -d nvim-inst ]; then
        mv nvim-inst nvim-inst.old || exit $?
    fi

    if [ -d neovim ]; then
        echo "Update existing nvim source tree"
        cd neovim && git pull || exit $?;
        gmake clean || exit $?
    else
        echo "Clone new nvim source tree"
        git clone https://github.com/neovim/neovim.git || exit $?
        cd neovim || exit $?
    fi

    # For OpenBSD, define autotools versions
    export AUTOMAKE_VERSION=1.15
    export AUTOCONF_VERSION=2.69

    ${MAKE} CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${NVIM_PATH}" || exit $?
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
${NVIM_PATH}/bin/nvim || exit $?

echo "Bootstrap success!"
echo "Don't forget to put ${NVIM_PATH} into your path and alias vim to nvim"
