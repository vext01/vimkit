#!/bin/sh
HERE=`pwd`

case `uname` in
    OpenBSD)
        LNFILE="ln -sfh";;
    *)
        LNFILE="ln -sfT";;
esac

cat <<EOD
This script will install Edd's vimkit in ${HOME}.

This will force link ~/.vim, ~/.vimrc and ~/.gvimrc.

Are you sure [Enter/^C]?
EOD
read x

${LNFILE} ${HERE}/.vimrc ~/.vimrc || exit $?
${LNFILE} ${HERE}/.gvimrc ~/.gvimrc || exit $?
${LNFILE} ${HERE}/.vim ~/.vim || exit $?

mkdir -p ~/.config || exit $?
${LNFILE} ${HERE}/.vim ~/.config/nvim
${LNFILE} ${HERE}/.vimrc ~/.config/nvim/init.vim

touch ~/.vim/local.vim

echo "Don't forget to install your plugins"
