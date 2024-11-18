#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_install_tools_default() {
  if _nredf_last_run; then
    return 0
  elif ! _nredf_create_lock; then
    return 0
  fi
  echo -e "\033[1mLooking for fresh batteries\033[0m"
  local BINARY=""

  for TOOL in "${NREDF_DEFAULT_TOOLS[@]}"; do
    eval "${TOOL}"
  done

  for FUNCTION in $(declare -f | awk '/^_nredf_tool_[a-z]+[ \t]/ {print $1}'); do
    if ! [[ ${NREDF_DEFAULT_TOOLS[*]} =~ ${FUNCTION} ]]; then
      BINARY="$(declare -f | sed -n "/^${FUNCTION}/,/^}/p" | sed -n 's/local BINARY="\([^"]*\)"/\1/p' | sed 's/[ \t]//g')"
      if [[ -x "${HOME}/.local/bin/${BINARY}" ]]; then
        eval "${FUNCTION}"
      fi
    fi
  done
  _nredf_last_run "" "true"
  _nredf_remove_lock
}
