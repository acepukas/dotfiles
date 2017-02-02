#!/usr/bin/env bash

whotest[0]='test' || (echo 'Failure: arrays not supported in this version of bash.' && exit 2)

# create any directories that may not exist yet
mkdir -p $HOME/bin
mkdir -p $HOME/.tmux
mkdir -p $HOME/.oh-my-zsh/custom/themes

DOTFILES=$HOME/dotfiles

typeset -A PATHS

PATHS=(
  ["$DOTFILES/bin/git_diff_wrapper"]="$HOME/bin/git_diff_wrapper"
  ["$DOTFILES/bin/todo.sh"]="$HOME/bin/todo.sh"
  ["$DOTFILES/dircolors/gruvbox"]="$HOME/.dir_colors"
  ["$DOTFILES/gdb/gdbinit"]="$HOME/.gdbinit"
  ["$DOTFILES/git/gitconfig"]="$HOME/.gitconfig"
  ["$DOTFILES/git/gitignore_global"]="$HOME/.gitignore_global"
  ["$DOTFILES/silver_searcher/agignore"]="$HOME/.agignore"
  ["$DOTFILES/tmux/tmux.conf"]="$HOME/.tmux.conf"
  ["$DOTFILES/tmux/themes"]="$HOME/.tmux/themes"
  ["$DOTFILES/tmux/terminal"]="$HOME/.tmux/terminal"
  ["$DOTFILES/todo.txt/todo"]="$HOME/.todo"
  ["$DOTFILES/todo.txt/todo.actions.d"]="$HOME/.todo.actions.d"
  ["$DOTFILES/vim/vimrc"]="$HOME/.vimrc"
  ["$DOTFILES/vim"]="$HOME/.vim"
  ["$DOTFILES/zsh/zshrc"]="$HOME/.zshrc"
  ["$DOTFILES/zsh/oh-my-zsh/themes/agnosterc.zsh-theme"]="$HOME/.oh-my-zsh/custom/themes/agnosterc.zsh-theme"
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
