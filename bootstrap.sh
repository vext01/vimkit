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

This will force link ~/.config/nvim

Are you sure [Enter/^C]?
EOD
read x

mkdir -p ~/.config || exit $?
${LNFILE} ${HERE}/nvim ~/.config/nvim

touch ~/.config/nvim/local.lua

echo "Don't forget to install your plugins"
