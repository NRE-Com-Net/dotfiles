#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh
# shellcheck disable=SC2016,SC2155

function _nredf_tool_krew() {
  [[ ! -f "${XDG_BIN_HOME}/kubectl" ]] && return 1
  _nredf_get_sys_info

  if [[ -n ${1} ]]; then
    FORCE_INSTALL=true
  fi

  local GHUSER="kubernetes-sigs"
  local GHREPO="krew"
  local BINARY="krew"
  local TAGVERSION="${1:-$(_nredf_github_latest_release "${GHUSER}" "${GHREPO}")}"
  local VERSION="${TAGVERSION#v}"
  local FILENAME="${GHREPO}-${NREDF_UNAME_LOWER}_${NREDF_ARCH}.tar.gz"
  local VERSION_CMD="version | awk '/^GitTag/{print \$2}'"
  local DOWNLOAD_CMD="_nredf_github_download_latest \"${GHUSER}\" \"${GHREPO}\" \"${FILENAME}\" \"${TAGVERSION}\""
  local EXTRACT_CMD='
    tar -xzf "${NREDF_DOWNLOADS}/${FILENAME}" -C "${XDG_BIN_HOME}/" "./${FILENAME%.tar.gz}"
    cp -f "${XDG_BIN_HOME}/${FILENAME%.tar.gz}" "${XDG_BIN_HOME}/${BINARY}"
  '

  if _nredf_install_tool "${BINARY}" "${FILENAME}" "${TAGVERSION}" "${VERSION}" "${VERSION_CMD}" "${DOWNLOAD_CMD}" "${EXTRACT_CMD}" "${FORCE_INSTALL}"; then
    "${XDG_BIN_HOME}/${BINARY}" install krew 2>/dev/null
  fi

  if [[ -f "${XDG_BIN_HOME}/${BINARY}" ]]; then
    export KREW_PLUGINS=()
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
    if _nredf_last_run; then
      return 0
    fi

    # Completion is currently not supported
    #if [[ "${NREDF_SHELL_NAME}" =~ ^(bash|zsh)$ ]]; then
    #  [[ -f "${XDG_BIN_HOME}/${BINARY}" ]] && "${XDG_BIN_HOME}/${BINARY}" completion "${NREDF_SHELL_NAME}" > "${XDG_CONFIG_HOME}/completion/${NREDF_SHELL_NAME}/_${BINARY}"
    #fi

    echo -e '\033[1m    Updating krew plugins\033[0m'
    kubectl krew update 2>/dev/null
    if kubectl krew upgrade 2>/dev/null; then
      _nredf_last_run "" "true"
    fi

    KREW_PLUGINS+=("ctx")
    KREW_PLUGINS+=("ns")
    KREW_PLUGINS+=("doctor")
    KREW_PLUGINS+=("fuzzy")
    KREW_PLUGINS+=("konfig")
    KREW_PLUGINS+=("images")
    KREW_PLUGINS+=("status")
    KREW_PLUGINS+=("oidc-login")
    KREW_PLUGINS+=("get-all")
    KREW_PLUGINS+=("resource-capacity")
    KREW_PLUGINS+=("deprecations")
    KREW_PLUGINS+=("df-pv")
    KREW_PLUGINS+=("outdated")
    KREW_PLUGINS+=("sniff")
    KREW_PLUGINS+=("unused-volumes")
    KREW_PLUGINS+=("cert-manager")

    for KREW_PLUGIN in "${KREW_PLUGINS[@]}"; do
      if ! kubectl krew list | command grep -q "${KREW_PLUGIN}"; then
        kubectl krew install "${KREW_PLUGIN}" 2>/dev/null
      fi
    done
  fi
}
