#!/bin/bash

set -eux

touch /root/.bashrc

ln -s /usr/bin/batcat /usr/local/bin/bat
ln -s /usr/bin/fdfind /usr/local/bin/fd

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +'PlugInstall --sync' +qa
