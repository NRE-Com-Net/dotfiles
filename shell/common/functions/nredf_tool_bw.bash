#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_bw() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  local GHUSER="bitwarden"
  local GHREPO="clients"
  local BINARY="bw"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}" "^cli")}"
  local VERSION="${TAGVERSION#cli-v}"
  local FILENAME="${BINARY}-oss-${NREDF_OS}-${VERSION}.zip"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} --version"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    if command -v ouch &> /dev/null; then
      command ouch decompress -qy "${NREDF_DOWNLOADS}/${FILENAME}" -d "${NREDF_DOWNLOADS}/" 2>/dev/null
    else
      command unzip -d "${NREDF_DOWNLOADS}/" "${NREDF_DOWNLOADS}/${FILENAME}"
    fi
    command cp -f "${NREDF_DOWNLOADS}/${BINARY}" "${XDG_BIN_HOME}/"
  '

  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"
}
