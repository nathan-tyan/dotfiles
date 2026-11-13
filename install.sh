#!/bin/bash

set -x

cp .bashrc ~/.bashrc
cp .tmux.conf ~/.tmux.conf
cp .vimrc ~/.vimrc

cp .config/starship.toml ~/.config/starship.toml

rsync --archive --delete --exclude='local.fish' .config/fish/ ~/.config/fish
