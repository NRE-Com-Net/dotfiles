#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_kubectl() {
  _nredf_get_sys_info

  local BINARY="kubectl"
  local TAGVERSION="${1:-$(command curl -L -s https://dl.k8s.io/release/stable.txt)}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${BINARY}"
  local VERSION_CMD="version --output yaml --client | yq '.clientVersion.gitVersion'"
  local DOWNLOAD_CMD="command curl -Lfso \"${NREDF_DOWNLOADS}/${FILENAME}\" \"https://dl.k8s.io/release/${TAGVERSION}/bin/${NREDF_UNAME_LOWER}/${NREDF_ARCH}/${BINARY}\""
  local EXTRACT_CMD='
    cp -f "${NREDF_DOWNLOADS}/${FILENAME}" "${XDG_BIN_HOME}/${BINARY}"
  '

  _nredf_install_tool "${BINARY}" "${FILENAME}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}"

  _nredf_create_tool_completion "${BINARY}" "completion ${NREDF_SHELL_NAME}"
}
