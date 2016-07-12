#!/bin/sh
HERE=`pwd`

cat <<EOD
This script will install Edd's vimkit in ${HOME}.

This will force link ~/.vim, ~/.vimrc and ~/.gvimrc.

Are you sure [Enter/^C]?
EOD

read x

ln -sf ${HERE}/.vimrc ~/.vimrc || exit $?
ln -sf ${HERE}/.gvimrc ~/.gvimrc || exit $?
ln -sf ${HERE}/.vim ~/.vim || exit $?

# Kicks off install
vim || exit $?

echo "Bootstrap success!"
