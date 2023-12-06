#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_install_tool() {
  local BINARY=${1}
  local FILENAME=${2}
  local TAGVERSION=${3}
  local VERSION=${4}
  local VERSION_CMD=${5}
  local DOWNLOAD_CMD=${6}
  local EXTRACT_CMD=${7}

  if [[ -n $BASH_VERSION ]]; then
    local CURRENT_TOOL="${FUNCNAME[1]}"
  else  # zsh
    # shellcheck disable=SC2124,SC2154
    local CURRENT_TOOL="${funcstack[@]:1:1}"
  fi

  if _nredf_last_run "${CURRENT_TOOL}"; then
    return 0
  fi

  if [[ ! -f "${XDG_BIN_HOME}/${BINARY}" ]]; then
    rm -rf "${XDG_BIN_HOME:?}/${BINARY:?}"
  elif [[ ! -x "${XDG_BIN_HOME}/${BINARY}" ]]; then
    rm -rf "${XDG_BIN_HOME:?}/${BINARY:?}"
  elif [[ -x "${XDG_BIN_HOME}/${BINARY}" ]]; then
    local CURRENT_VERSION
    CURRENT_VERSION="$(eval "${XDG_BIN_HOME}/${BINARY} ${VERSION_CMD}")"
    if [[ "${TAGVERSION}" == "" ]]; then
      echo -e "\033[1;33m  \U2713 ${BINARY} version could not be fetched \033[0m"
      # shellcheck disable=SC2155
      local RATELIMIT_REMAINING=$(curl -LIs https://api.github.com/meta | awk '/x-ratelimit-remaining/{print $2}')
      if [[ "${RATELIMIT_REMAINING}" == "0" ]]; then
        # shellcheck disable=SC2155
        #local RATELIMIT_RESET="$(curl -LIs https://api.github.com/meta | awk '/x-ratelimit-reset/{print $2}')"
        # shellcheck disable=SC2155
        #local CURRENT_TIME="$(date +%s)"
        echo -e "\033[1;31m    \U21B3 Github rate limit exceeded\033[0m"
        _nredf_last_run "${CURRENT_TOOL}" "true" "${RATELIMIT_RESET}"
      else
        _nredf_last_run "${CURRENT_TOOL}" "true"
      fi
      return 1
    fi
    if [[ "${VERSION}" == "${CURRENT_VERSION}" || "${TAGVERSION}" == "${CURRENT_VERSION}" ]]; then
      echo -e "\033[1;32m  \U2713 ${BINARY} (${VERSION}) up-to-date\033[0m"
      _nredf_last_run "${CURRENT_TOOL}" "true"
      return 0
    fi
  fi

  echo -e "\033[1;36m  \U25B6 ${BINARY} is getting installed in version ${VERSION}\033[0m"
  eval "${DOWNLOAD_CMD}"
  if [[ -f "${NREDF_DOWNLOADS}/${FILENAME}" ]]; then
    eval "${EXTRACT_CMD}"
  else
    echo -e "\033[1;31m    \U21B3 Installation failed\033[0m"
    return 1
  fi
  if [[ -f "${XDG_BIN_HOME}/${BINARY}" ]]; then
    chmod +x "${XDG_BIN_HOME}/${BINARY}"
  else
    echo -e "\033[1;31m    \U21B3 Installation failed\033[0m"
    return 1
  fi
  echo -e "\033[1;32m    \U21B3 Installation successful\033[0m"
  _nredf_last_run "${CURRENT_TOOL}" "true"
}
