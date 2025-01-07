#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_helix() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  local GHUSER="helix-editor"
  local GHREPO="helix"
  local BINARY="hx"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${GHREPO}-${VERSION}-${NREDF_UNAMEM}-${NREDF_OS}.tar.xz"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} --version | awk '{print \$2}' | awk -F. '{if (length(\$2) == 1) {print \$1\".0\"\$2} else {print \$0}}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    command tar -xJf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${NREDF_DOWNLOADS}/"
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.xz}/${BINARY}" "${XDG_BIN_HOME}/"
    command cp -rf "${NREDF_DOWNLOADS}/${FILENAME%.tar.xz}/contrib" "${XDG_CONFIG_HOME}/${GHREPO}/"
    command cp -rf "${NREDF_DOWNLOADS}/${FILENAME%.tar.xz}/runtime" "${XDG_CONFIG_HOME}/${GHREPO}/"
  '

  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"
}
