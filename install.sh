#!/bin/bash

set -x

cp .bashrc ~/.bashrc
cp .tmux.conf ~/.tmux.conf
cp .vimrc ~/.vimrc

rsync --archive --delete --exclude='local.fish' .config/fish/ ~/.config/fish
