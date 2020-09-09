# dotfiles

## Symlinking

To create symlinks to dot files run the following script *from your home directory*:

```sh
./dofiles/symlink.sh link
```

To unlink, run the following *from your home directory*:

```sh
./dofiles/symlink.sh unlink
```

To add a new link, add an entry to the `PATHS` associative array in `symlink.sh`. Running `symlink.sh` won't attempt to relink established links.

*NOTE:* On OS X the version of bash shipped with Darwin may be too out of date for the `symlink.sh` script. If so, a more up to date version of bash can be installed with `brew install bash`

## Utility Installation

### ZSH

Ubuntu: sudo apt-get install zsh

OS X: Use homebrew

```sh
brew install zsh zsh-completions
```

Once zsh is installed, make sure that the default shell is set to zsh:

```sh
chsh -s $(which zsh)
```

### Oh My Zsh

via curl:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

via wget:


```sh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

### NeoVim

Arch: `pacman -S neovim`

### NVM

via curl:

```sh
curl -o- https://raw.githubusercontent.com/creationix/nvm/v{LATEST_TAG}/install.sh | bash
```

via wget:

```sh
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v{LATEST_TAG}/install.sh | bash
```

Be sure to change the `{LATEST_TAG}` string to whatever the latest version tag is for nvm.

On OS X it's probably fine to install node.js via homebrew unless you want to easily switch node versions.

### TMUX

Ubuntu: run the `dotfiles/tmux/tmux-setup.sh` script. It will install the latest version TMUX.

#### TMUX plugin manager

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Ripgrep (rg)

Arch: `pacman -S ripgrep`

OS X: `brew install ripgrep`

### fd

Arch: `pacman -S fd`
