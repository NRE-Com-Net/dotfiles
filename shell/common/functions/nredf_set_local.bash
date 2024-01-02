#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

_nredf_set_local () {
  echo -e '\033[1mSourcing local aliases and functions\033[0m'

  if [[ ! -d "${NREDF_RC_LOCAL}" ]]; then
    mkdir -p "${NREDF_RC_LOCAL}"
  fi

  if [[ -e "${NREDF_DOT_PATH}/shell/common/aliases" ]]; then
    source "${NREDF_DOT_PATH}/shell/common/aliases"
  fi

  if [[ -e "${NREDF_RC_PATH}/aliases" ]]; then
    source "${NREDF_RC_PATH}/aliases"
  fi

  if [[ -f "${NREDF_RC_LOCAL}/aliases.local" ]]; then
    source "${NREDF_RC_LOCAL}/aliases.local"
  fi

  if [[ -f "${NREDF_RC_LOCAL}/functions.local" ]]; then
    source "${NREDF_RC_LOCAL}/functions.local"
  fi

  if [[ -f "${NREDF_COMMON_RC_LOCAL}/rc.local" ]]; then
    source "${NREDF_COMMON_RC_LOCAL}/rc.local"
  fi

  if [[ -f "${NREDF_RC_LOCAL}/rc.local" ]]; then
    source "${NREDF_RC_LOCAL}/rc.local"
  fi

  if [[ -d "${NREDF_CONFIG}/shell/common/functions" ]]; then
    for NREDF_LOCAL_FUNCTIONS in "${NREDF_CONFIG}/shell/common/functions/"*; do
      source "${NREDF_LOCAL_FUNCTIONS}"
    done
  fi

  if [[ -d "${NREDF_CONFIG}/shell/${NREDF_SHELL_NAME}/functions" ]]; then
    for NREDF_LOCAL_FUNCTIONS in "${NREDF_CONFIG}/shell/${NREDF_SHELL_NAME}/functions/"*; do
      source "${NREDF_LOCAL_FUNCTIONS}"
    done
  fi

  if [[ -f "${NREDF_CONFIG}/shell/common/aliases" ]]; then
    source "${NREDF_CONFIG}/shell/common/aliases"
  else
    touch "${NREDF_CONFIG}/shell/common/aliases"
  fi

  if [[ -f "${NREDF_CONFIG}/shell/${NREDF_SHELL_NAME}/aliases" ]]; then
    source "${NREDF_CONFIG}/shell/${NREDF_SHELL_NAME}/aliases"
  else
    touch "${NREDF_CONFIG}/shell/${NREDF_SHELL_NAME}/aliases"
  fi

  if [[ -f "${NREDF_CONFIG}/shell/common/rc" ]]; then
    source "${NREDF_CONFIG}/shell/common/rc"
  else
    touch "${NREDF_CONFIG}/shell/common/rc"
  fi

  if [[ -f "${NREDF_CONFIG}/shell/${NREDF_SHELL_NAME}/rc" ]]; then
    source "${NREDF_CONFIG}/shell/${NREDF_SHELL_NAME}/rc"
  else
    touch "${NREDF_CONFIG}/shell/${NREDF_SHELL_NAME}/rc"
  fi
}
