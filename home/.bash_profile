################################################
#
#  Login shell setup (minimal):
#  - initializes paths and environment defaults
#  - includes PATH tools like fnm
#  - skips tool installation and multiplexer startup
#
################################################

export NREDF_SHELL_NAME="bash"
export NREDF_DOT_PATH="${HOME}/.homesick/repos/dotfiles"
export NREDF_COMMON_RC_PROFILE="login-minimal"
source "${NREDF_DOT_PATH}/shell/common/rc"
