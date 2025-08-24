#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_set_ssh_agent() {

  if [[ -n "${WSL_DISTRO_NAME}" || -n "${WSL_INTEROP}" ]]; then
    # Ensure socket directory exists
    if [[ ! -d "${HOME}/.ssh" ]]; then
      mkdir -p "${HOME}/.ssh"
    fi
    export SSH_AUTH_SOCK="${HOME}/.ssh/auth_sock"
    rm -f "${SSH_AUTH_SOCK}"
    NPIPERELAY="/mnt/c/Users/nemes/AppData/Local/Microsoft/WinGet/Packages/albertony.npiperelay_Microsoft.Winget.Source_8wekyb3d8bbwe/npiperelay.exe"
    if [[ ! -x "${NPIPERELAY}" ]]; then
      echo "Error: npiperelay.exe is not executable"
      return 1
    fi
    if command -v setsid &>/dev/null && command -v socat &>/dev/null; then
      ( setsid socat UNIX-LISTEN:"${SSH_AUTH_SOCK}",fork EXEC:"${NPIPERELAY} -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
    fi
  elif command -v gpgconf &>/dev/null; then
    if [[ -z ${SSH_CONNECTION} && "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
      unset SSH_AGENT_PID
      SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
      export SSH_AUTH_SOCK
    fi
  fi
}
