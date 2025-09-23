#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_step() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  local GHUSER="smallstep"
  local GHREPO="cli"
  local BINARY="step"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${BINARY}_${NREDF_UNAME_LOWER}_${VERSION}_${NREDF_ARCH}.tar.gz"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} --version | awk 'NR==1{sub(\".*/\",\"\",\$2); print \$2}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    command tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${NREDF_DOWNLOADS}/"
    command cp -f "${NREDF_DOWNLOADS}/${BINARY}_${VERSION}/bin/${BINARY}" "${XDG_BIN_HOME}/"
  '

  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"

  _nredf_create_tool_completion "${BINARY}" "completion ${NREDF_SHELL_NAME}"
}
