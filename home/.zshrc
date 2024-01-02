################################################
#
#	For your local overrides there are several configs in ${HOME}/.config/nredf/shell/zsh
#	* aliases
#	* functions/
#	* rc
#	* plugins
#
################################################

# If not running interactively, don't do anything
[ -z "${PS1}" ] && return

export NREDF_SHELL_NAME="zsh"
export NREDF_DOT_PATH="${HOME}/.homesick/repos/dotfiles"
source "${NREDF_DOT_PATH}/shell/common/rc"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
_nredf_tool_fzf_source
