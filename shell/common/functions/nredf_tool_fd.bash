#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_fd() {
  _nredf_get_sys_info
  if [[ "${NREDF_UNAMEM}" == "aarch64" ]]; then
    NREDF_PLATFORM="unknown-linux-gnu"
  fi

  local GHUSER="sharkdp"
  local GHREPO="fd"
  local BINARY="fd"
  local TAGVERSION="$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${GHREPO}-${TAGVERSION}-${NREDF_UNAMEM}-${NREDF_PLATFORM}.tar.gz"
  local VERSION_CMD="--version | awk '/fd/{print \$2}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${NREDF_DOWNLOADS}/"
    cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.gz}/${BINARY}" \"${XDG_BIN_HOME}/"
    cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.gz}/autocomplete/_fd" \"${XDG_CONFIG_HOME}/completion/zsh/_fd"
    cp -f "${NREDF_DOWNLOADS}/${FILENAME%.tar.gz}/autocomplete/fd.bash" \"${XDG_CONFIG_HOME}/completion/bash/fd.bash"
  '

  _nredf_install_tool "${BINARY}" "${FILENAME}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}"
}
