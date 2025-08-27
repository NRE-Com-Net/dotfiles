# NRE.Com.Net Dotfiles

> [!CAUTION]
> **README NEEDS TO BE UPDATED!**
> the dotfiles are functunal but missing a proper readme and documentation

## Description

This is our compilation of dotfiles, they are build to be managed by [Anders Ingemann's homeshick](https://github.com/andsens/homeshick)

> [!NOTE]
> This includes

* [promptline.vim](https://github.com/edkolev/promptline.vim) Powerline Theme (powerlineclone)
* [Lokaltogs powerline-fonts](https://github.com/Lokaltog/powerline-fonts) which is installed into "${HOME}/.fonts"
* [seebis solarized dircolors ](https://github.com/seebi/dircolors-solarized#theme-1-256dark-by-seebi) which is installed into "${HOME}/.config"
* [seebis solarized tmux theme](https://github.com/seebi/tmux-colors-solarized)
* [tmux-plugins tpm](https://github.com/tmux-plugins/tpm) disabled at the moment
* a huge compilation of vim Plugins ([Pluginlist](https://github.com/NemesisRE/vimfiles/blob/master/home/.vim/rc/neobundle.rc.vim))
* and some other dotfiles e.g. gitconfig, wget, curl, tmux...

All contribution goes to the original developers we only have put the pieces together.

## Install

### Manual

1. Install homeshick like in the [Readme](https://github.com/andsens/homeshick/blob/master/README.md)
1. Add NRE.Com.Net Dotfiles to homeshick `homeshick clone https://github.com/NemesisRE/dotfiles.git`
1. Add our bashrc to your existing `printf '\nsource "${HOME}/.bashrc_homesick"' >> ${HOME}/.bashrc`

> [!NOTE]
> We sugest to install [Lokaltog powerline-fonts](https://github.com/Lokaltog/powerline-fonts) to "$HOME/.fonts"
> and run `fc-cache -fv` (The bootstrap script includes and installes/registers them automatically.).
> Then you should restart your terminal application and change the font to a powerline one.

### Bootstraped

Just run:

`bash <(curl -sL https://raw.githubusercontent.com/NemesisRE/dotfiles/master/bootstrap.sh)`

## Features

### Command Line

1. Fast Bash only Powerline Theme
    * VCS detection
    * Python virtualenv detection
    * Last error code (!=0)
1. Solarized dircolors
1. Inputrc tweaks
    * TAB/SHIFT-TAB menu-completion/menu-completion-backward
    * ALT-UP/ALT-DOWN search History for command
    * ALT-BACKSPACE kill-word
    * Complete hidden files
    * and more
