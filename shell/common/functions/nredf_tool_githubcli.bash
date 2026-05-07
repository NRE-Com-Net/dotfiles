#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_githubcli() {
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  local GHUSER="cli"
  local GHREPO="cli"
  local BINARY="gh"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILE_EXT="tar.gz"
  local OS_LABEL="$(_nredf_asset_os uname-lower)"

  if [[ "${NREDF_OS}" == "macos" ]]; then
    FILE_EXT="zip"
    OS_LABEL="$(_nredf_asset_os macos-release)"
  fi

  local FILENAME="${BINARY}_${VERSION}_${OS_LABEL}_${NREDF_ARCH}.${FILE_EXT}"
  local VERSION_CMD="${XDG_BIN_HOME}/${BINARY} --version | awk '{print \$3}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    if [[ "${FILENAME}" == *.zip ]]; then
      if command -v ouch &> /dev/null; then
        command ouch decompress -qy "${NREDF_DOWNLOADS}/${FILENAME}" -d "${NREDF_DOWNLOADS}/" 2>/dev/null
      else
        command unzip -oq "${NREDF_DOWNLOADS}/${FILENAME}" -d "${NREDF_DOWNLOADS}/"
      fi
    else
      command tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${NREDF_DOWNLOADS}/"
    fi
    command cp -f "${NREDF_DOWNLOADS}/${FILENAME%.${FILE_EXT}}/bin/${BINARY}" "${XDG_BIN_HOME}/"
  '

  _nredf_install_tool "${BINARY}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"

  _nredf_create_tool_completion "${BINARY}" "completion --shell ${NREDF_SHELL_NAME}"
}
