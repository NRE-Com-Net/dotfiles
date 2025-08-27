# NRE.Com.Net Dotfiles

> [!CAUTION]
> **README NEEDS TO BE UPDATED!**
> the dotfiles are functunal but missing a proper readme and documentation

## Description

This is our compilation of dotfiles, they are build to be managed by [Anders Ingemann's homeshick](https://github.com/andsens/homeshick)

> [!NOTE]
> This includes
> A LOT

All contribution goes to the original developers we only put the pieces together.

## Install

### Manual

1. Install homeshick like in the [Readme](https://github.com/andsens/homeshick/blob/master/README.md)
1. Add NRE.Com.Net Dotfiles to homeshick `homeshick clone https://github.com/NRE-Com-Net/dotfiles.git`
1. Add our bashrc to your existing `printf '\nsource "${HOME}/.bashrc_homesick"' >> ${HOME}/.bashrc`

> [!NOTE]
> We sugest to install [Fira Code Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)

### Bootstraped

Just run:

`bash <(curl -sL https://raw.githubusercontent.com/NRE-Com-Net/dotfiles/master/bootstrap.sh)`
