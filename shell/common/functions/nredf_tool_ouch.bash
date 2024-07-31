#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_ouch() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  local GHUSER="ouch-org"
  local GHREPO="ouch"
  local BINARY="ouch"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION}"
  local FILENAME="${BINARY}-${NREDF_UNAMEM}-${NREDF_PLATFORM}.tar.gz"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} --version 2>/dev/null | awk '{print \$2}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    if command -v ouch &> /dev/null; then
      command ouch decompress -qy "${NREDF_DOWNLOADS}/${FILENAME}" -d "${NREDF_DOWNLOADS}/" 2>/dev/null
    else
      command tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${NREDF_DOWNLOADS}/"
    fi
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.gz}/${BINARY}" "${XDG_BIN_HOME}/"
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.gz}/completions/ouch.bash" "${XDG_CONFIG_HOME}/completion/bash/"
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.gz}/completions/_ouch" "${XDG_CONFIG_HOME}/completion/zsh/"
  '

  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"
}
