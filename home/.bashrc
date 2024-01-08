################################################
#
#	For your local overrides there are several configs in ${HOME}/.config/nredf/shell/bash/
#	* aliases
#	* functions/
#	* rc
#
#
################################################

# If not running interactively, don't do anything
[ -z "${PS1}" ] && return

export NREDF_SHELL_NAME="bash"
export NREDF_DOT_PATH="${HOME}/.homesick/repos/dotfiles"
source "${NREDF_DOT_PATH}/shell/common/rc"
#eval "$(starship init bash)"
_nredf_tool_fzf_source
