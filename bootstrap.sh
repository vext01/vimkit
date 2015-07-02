#!/bin/sh
HERE=`pwd`
VUNDLE_REPO=https://github.com/gmarik/Vundle.vim.git
VUNDLE_DIR=${HERE}/.vim/bundle/Vundle.vim

cat <<EOD
This script will install Edd's vimkit in ${HOME}.

This will force link ~/.vim, ~/.vimrc and ~/.gvimrc.

Are you sure [Enter/^C]?
EOD

read x

if [ ! -d "${VUNDLE_DIR}" ]; then
	cd .vim/bundle && git clone ${VUNDLE_REPO} || exit $?;
fi

ln -sf ${HERE}/.vimrc ~/.vimrc || exit $?
ln -sf ${HERE}/.gvimrc ~/.gvimrc || exit $?
ln -sf ${HERE}/.vim ~/.vim || exit $?

vim -c "PluginInstall" || exit $?

echo "Bootstrap success!"
