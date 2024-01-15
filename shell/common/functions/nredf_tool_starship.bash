#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_starship() {
  _nredf_get_sys_info

  local GHUSER="starship"
  local GHREPO="starship"
  local BINARY="starship"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${GHREPO}-${NREDF_UNAMEM}-${NREDF_PLATFORM}.tar.gz"
  local VERSION_CMD="--version | awk 'NR==1{print \$2}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${XDG_BIN_HOME}" "${BINARY}"
  '

  _nredf_install_tool "${BINARY}" "${FILENAME}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}"

  _nredf_create_tool_completion "${BINARY}" "completions ${NREDF_SHELL_NAME}"
}
