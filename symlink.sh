#!/usr/bin/env bash

whotest[0]='test' || (echo 'Failure: arrays not supported in this version of bash.' && exit 2)

# create any directories that may not exist yet
mkdir -p $HOME/bin
mkdir -p $HOME/.tmux
mkdir -p $HOME/.config

DOTFILES=$HOME/dotfiles

typeset -A PATHS

PATHS=(
  ["$DOTFILES/dircolors/gruvbox"]="$HOME/.dir_colors"
  ["$DOTFILES/gdb/gdbinit"]="$HOME/.gdbinit"
  ["$DOTFILES/git/gitconfig"]="$HOME/.gitconfig"
  ["$DOTFILES/git/gitignore_global"]="$HOME/.gitignore_global"
  ["$DOTFILES/ripgrep/ignore"]="$HOME/.ignore"
  ["$DOTFILES/tmux/tmux.conf"]="$HOME/.tmux.conf"
  ["$DOTFILES/tmux/themes"]="$HOME/.tmux/themes"
  ["$DOTFILES/nvim"]="$HOME/.config/nvim"
  ["$DOTFILES/zsh/zshrc"]="$HOME/.zshrc"
  ["$DOTFILES/starship/starship.toml"]="$HOME/.config/starship.toml"
  ["$DOTFILES/bat"]="$HOME/.config/bat"
)

COMMAND=$1

case $COMMAND in
link)
  for FILE in "${!PATHS[@]}"; do
    LINK="${PATHS[$FILE]}"
    if [ ! -L "$LINK" ]; then
      echo "established symlink: $LINK -> $FILE"
      ln -s "$FILE" "$LINK"
    else
      echo "synlink already established: $LINK -> $FILE"
    fi
  done
  ;;
unlink)
  for FILE in "${!PATHS[@]}"; do
    LINK="${PATHS[$FILE]}"
    if [ -L "$LINK" ]; then
      echo "unlink $LINK"
      unlink "$LINK"
    else
      echo "not a symlink: $LINK "
    fi
  done
  ;;
*)
  echo "Usage: ./symlink.sh [link|unlink]"
  ;;
esac
