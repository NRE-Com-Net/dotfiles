#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_helix() {
  _nredf_get_sys_info

  local GHUSER="helix-editor"
  local GHREPO="helix"
  local BINARY="hx"
  local TAGVERSION="$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${GHREPO}-${VERSION}-${NREDF_UNAMEM}-${NREDF_OS}.tar.xz"
  local VERSION_CMD="--version | awk '{print \$2}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    tar -xJf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${NREDF_DOWNLOADS}/"
    cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.xz}/${BINARY}" "${XDG_BIN_HOME}/"
    cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.xz}/{contrib,runtime}" "${XDG_CONFIG_HOME}/${GHREPO}/"
  '

  _nredf_install_tool "${BINARY}" "${FILENAME}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}"
}
