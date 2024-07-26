#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_duf() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  if [[ "${NREDF_UNAMEM}" == "aarch64" ]]; then
    NREDF_UNAMEM="arm64"
  fi

  local GHUSER="muesli"
  local GHREPO="duf"
  local BINARY="duf"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${GHREPO}_${VERSION}_${NREDF_OS}_${NREDF_UNAMEM}.tar.gz"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} -version | awk '/duf/{print \$2}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    command tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${XDG_BIN_HOME}/" ${BINARY}
  '

  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"

  if alias duf &>/dev/null; then
    unalias duf &>/dev/null
  fi
}
