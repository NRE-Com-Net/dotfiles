#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_ripgrep() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  if [[ "${NREDF_UNAMEM}" == "aarch64" ]]; then
    NREDF_PLATFORM="unknown-linux-gnu"
  fi

  local GHUSER="BurntSushi"
  local GHREPO="ripgrep"
  local BINARY="rg"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${GHREPO}-${VERSION}-${NREDF_UNAMEM}-${NREDF_PLATFORM}.tar.gz"
  local VERSION_CMD="--version | awk '/ripgrep/{print \$2}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${NREDF_DOWNLOADS}/" && cp "${NREDF_DOWNLOADS}/${FILENAME%.tar.gz}/${BINARY}" "${XDG_BIN_HOME}/"
    cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.gz}/complete/_rg" "${XDG_CONFIG_HOME}/completion/zsh/_rg"
    cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.gz}/complete/rg.bash" "${XDG_CONFIG_HOME}/completion/bash/rg.bash"
  '

  _nredf_install_tool "${BINARY}" "${FILENAME}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"

  _nredf_create_tool_completion "${BINARY}" "--generate complete-${NREDF_SHELL_NAME}"
}
