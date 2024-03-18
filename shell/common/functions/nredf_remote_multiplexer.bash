#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_remote_multiplexer() {
  local HOSTNAME
  if command -pv hostname &>/dev/null; then
    HOSTNAME=$(hostname -s)
  elif command -pv hostnamectl &>/dev/null; then
    HOSTNAME=$(hostnamectl hostname)
  fi
  if [[ "${TERM_PROGRAM}" != "vscode" ]]; then
    if [[ -n "${SSH_TTY}" || -n "${WSL_DISTRO_NAME}" ]] && command -v zellij &>/dev/null; then
      if [[ -z "${ZELLIJ}" ]]; then
        echo -e "\033[1mStarting multiplexer\033[0m"
        if [[ -n "${SSH_AUTH_SOCK}" ]] && [[ "${SSH_AUTH_SOCK}" != "${HOME}/.ssh/agent_sock" ]]; then
          if [[ ! -d "${HOME}/.ssh" ]]; then
            mkdir "${HOME}/.ssh"
          fi
          unlink "${HOME}/.ssh/auth_sock" 2>/dev/null
          ln -sf "${SSH_AUTH_SOCK}" "${HOME}/.ssh/auth_sock"
          export SSH_AUTH_SOCK="${HOME}/.ssh/auth_sock"
        fi
        zellij attach -c "${HOSTNAME}"
      fi
    elif [[ "${NREDF_OS}" == "linux" ]] && [[ -n "${SSH_TTY}" ]] && [[ "${PS1}" != "" ]] && command -pv tmux &>/dev/null; then
      if [[ -z "${TMUX}" ]]; then
        if [ -n "${SSH_AUTH_SOCK}" ] && [ "${SSH_AUTH_SOCK}" != "${HOME}/.ssh/agent_sock" ]; then
            unlink "${HOME}/.ssh/auth_sock" 2>/dev/null
            ln -sf "${SSH_AUTH_SOCK}" "${HOME}/.ssh/auth_sock"
            export SSH_AUTH_SOCK="${HOME}/.ssh/auth_sock"
        fi
              # Start tmux on connection
        if [[ "$(tmux -L "${HOSTNAME}" has-session -t "${HOSTNAME}" &>/dev/null; echo $?)" = 0 ]]; then
            echo -e '\033[1mAttach to running tmux session\033[0m'
            tmux -L "${HOSTNAME}" attach-session -t "${HOSTNAME}"
        elif [[ "$(which tmux 2>/dev/null)" != "" ]] && [[ "${TMUX}" = "" ]]; then
            echo -e '\033[1mStart new tmux session\033[0m'
            tmux -L "${HOSTNAME}" new-session -s "${HOSTNAME}"
        fi
      fi
    fi
  fi
}
