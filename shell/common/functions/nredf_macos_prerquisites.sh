#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_macos_prerquisites() {
  _nredf_init_paths

  local BREW_PATH=""
  local BREW_UPGRADE_INTERVAL=86400
  local BREW_UPGRADE_KEY="_nredf_macos_prerquisites_brew_upgrade"
  local FORMULAE=(bash git diffutils util-linux gh)
  local FORMULA=""
  local MISSING_FORMULAE_INSTALLED=false
  local NEXT_BREW_UPGRADE="$(($(date +%s) + BREW_UPGRADE_INTERVAL))"
  local OUTDATED_FORMULAE=()
  local OUTDATED_OUTPUT=""

  echo -e '\033[1mChecking macOS prerequisites\033[0m'

  if command -v brew &>/dev/null; then
    BREW_PATH="$(command -v brew)"
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_PATH="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    BREW_PATH="/usr/local/bin/brew"
  fi

  if [[ -z "${BREW_PATH}" ]]; then
    echo -e "\033[1m  Installing Homebrew\033[0m"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ -x /opt/homebrew/bin/brew ]]; then
      BREW_PATH="/opt/homebrew/bin/brew"
    elif [[ -x /usr/local/bin/brew ]]; then
      BREW_PATH="/usr/local/bin/brew"
    else
      echo -e "\033[1;31m  Homebrew installation failed\033[0m"
      return 1
    fi
  fi

  eval "$("${BREW_PATH}" shellenv)"

  local UTIL_LINUX_PREFIX=""
  UTIL_LINUX_PREFIX="$("${BREW_PATH}" --prefix util-linux 2>/dev/null)"
  if [[ -n "${UTIL_LINUX_PREFIX}" ]]; then
    [[ -d "${UTIL_LINUX_PREFIX}/bin" ]] && export PATH="${UTIL_LINUX_PREFIX}/bin:${PATH}"
    [[ -d "${UTIL_LINUX_PREFIX}/sbin" ]] && export PATH="${UTIL_LINUX_PREFIX}/sbin:${PATH}"
  fi

  for FORMULA in "${FORMULAE[@]}"; do
    if ! "${BREW_PATH}" list --formula "${FORMULA}" &>/dev/null; then
      echo -e "\033[1m  Installing ${FORMULA}\033[0m"
      if ! HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 "${BREW_PATH}" install "${FORMULA}" >/dev/null; then
        echo -e "\033[1;31m  Installation of ${FORMULA} failed\033[0m"
        return 1
      fi
      MISSING_FORMULAE_INSTALLED=true
    fi
  done

  if ${MISSING_FORMULAE_INSTALLED}; then
    return 0
  fi

  if _nredf_last_run "${BREW_UPGRADE_KEY}"; then
    return 0
  fi

  for FORMULA in "${FORMULAE[@]}"; do
    OUTDATED_OUTPUT="$("${BREW_PATH}" outdated --formula --quiet "${FORMULA}" 2>/dev/null)"
    if [[ "${OUTDATED_OUTPUT}" == "${FORMULA}" ]]; then
      OUTDATED_FORMULAE+=("${FORMULA}")
    fi
  done

  if [[ ${#OUTDATED_FORMULAE[@]} -eq 0 ]]; then
    _nredf_last_run "${BREW_UPGRADE_KEY}" "true" "${NEXT_BREW_UPGRADE}"
    return 0
  fi

  echo -e "\033[1m  Upgrading Homebrew formulas: ${OUTDATED_FORMULAE[*]}\033[0m"
  if HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 "${BREW_PATH}" upgrade "${OUTDATED_FORMULAE[@]}" >/dev/null; then
    _nredf_last_run "${BREW_UPGRADE_KEY}" "true" "${NEXT_BREW_UPGRADE}"
  fi
}
