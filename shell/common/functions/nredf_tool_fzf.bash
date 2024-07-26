#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155,SC2086

function _nredf_tool_fzf() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  if [[ ${NREDF_OS} =~ ^(macos|windows)$ ]]; then
    local FILEEXT="zip"
  fi

  local GHUSER="junegunn"
  local GHREPO="fzf"
  local BINARY="fzf"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${BINARY}-${VERSION}-${NREDF_UNAME_LOWER}_${NREDF_ARCH}.${FILEEXT:-tar.gz}"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} --version | awk '{print \$1}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    command tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${XDG_BIN_HOME}/"

    #command curl ${NREDF_CURL_GITHUB_AUTH} -Lfso "${XDG_BIN_HOME}/fzf-tmux" "https://raw.githubusercontent.com/${GHUSER}/${GHREPO}/master/bin/fzf-tmux"

    #if [[ -f "${XDG_BIN_HOME}/fzf-tmux" ]]; then
    #  chmod +x "${XDG_BIN_HOME}/fzf-tmux"
    #else
    #  return 1
    #fi

    [[ ! -d ${HOME}/.config/fzf ]] && /bin/mkdir "${HOME}/.config/fzf"
    for FZF_FILE in completion.bash completion.zsh key-bindings.bash key-bindings.zsh key-bindings.fish; do
      command curl ${NREDF_CURL_GITHUB_AUTH} -Lfso "${HOME}/.config/fzf/${FZF_FILE}" "https://raw.githubusercontent.com/${GHUSER}/${GHREPO}/master/shell/${FZF_FILE}"
    done
  '
  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"
}

function _nredf_tool_fzf_source() {
  if command -v fzf &>/dev/null; then
    if [[ "${NREDF_SHELL_NAME}" =~ ^(bash|zsh)$ ]]; then
      [[ -f "${HOME}/.config/fzf/completion.${NREDF_SHELL_NAME}" ]] && source "${HOME}/.config/fzf/completion.${NREDF_SHELL_NAME}"
      [[ -f "${HOME}/.config/fzf/key-bindings.${NREDF_SHELL_NAME}" ]] && source "${HOME}/.config/fzf/key-bindings.${NREDF_SHELL_NAME}"
    fi

    [[ -f "${NREDF_DOT_PATH}/shell/common/fzf" ]] && source "${NREDF_DOT_PATH}/shell/common/fzf"
  fi
}
