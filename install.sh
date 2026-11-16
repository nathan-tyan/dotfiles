#!/bin/bash

set -x

cp .bashrc ~/.bashrc
cp .tmux.conf ~/.tmux.conf
cp .vimrc ~/.vimrc

cp .config/starship.toml ~/.config/starship.toml

rsync --archive .config/nvim/ ~/.config/nvim
rsync --archive .config/fish/ ~/.config/fish
