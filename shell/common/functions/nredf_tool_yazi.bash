#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_yazi() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  local GHUSER="sxyazi"
  local GHREPO="yazi"
  local BINARY="yazi"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${BINARY}-${NREDF_UNAMEM}-${NREDF_PLATFORM}.zip"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} --version | awk '{print \$2}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    if command -v ouch &> /dev/null; then
      command ouch decompress -qy "${NREDF_DOWNLOADS}/${FILENAME}" -d "${NREDF_DOWNLOADS}/" 2>/dev/null
    elif command -v unzip &> /dev/null; then
      command unzip -oq "${NREDF_DOWNLOADS}/${FILENAME}" -d "${NREDF_DOWNLOADS}"
    else
      echo "missing ouch or unzip"
    fi

    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.zip}/${BINARY}" "${XDG_BIN_HOME}/${BINARY}"
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.zip}/ya" "${XDG_BIN_HOME}/ya"
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.zip}/completions/yazi.bash" "${XDG_CONFIG_HOME}/completion/bash/"
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.zip}/completions/ya.bash" "${XDG_CONFIG_HOME}/completion/bash/"
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.zip}/completions/_yazi" "${XDG_CONFIG_HOME}/completion/zsh/"
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.zip}/completions/_ya" "${XDG_CONFIG_HOME}/completion/zsh/"
  '

  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"

}
