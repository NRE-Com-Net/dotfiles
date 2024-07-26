#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_ctop() {
  if ! command -pv docker >/dev/null 2>&1; then
    return 0
  fi

  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  local GHUSER="bcicen"
  local GHREPO="ctop"
  local BINARY="ctop"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${BINARY}-${VERSION}-${NREDF_OS}-${NREDF_ARCH}"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} -v | awk '{sub(\",\",\"\"); print \$3}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME}" "${XDG_BIN_HOME}/${BINARY}"
  '

  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"
}
