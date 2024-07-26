#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_yq() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  local GHUSER="mikefarah"
  local GHREPO="yq"
  local BINARY="yq"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION}"
  local FILENAME="${GHREPO}_${NREDF_UNAME_LOWER}_${NREDF_ARCH}.tar.gz"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} -V | awk '{print \$4}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    command tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${XDG_BIN_HOME}/" "./${FILENAME%.tar.gz}"
    command cp -f "${XDG_BIN_HOME}/${FILENAME%.tar.gz}" "${XDG_BIN_HOME}/${BINARY}"
  '

  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"

  _nredf_create_tool_completion "${BINARY}" "shell-completion ${NREDF_SHELL_NAME}"
}
