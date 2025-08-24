#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_set_ssh_agent_wsl() {
  # Ensure socket directory exists
  if [[ ! -d "${HOME}/.ssh" ]]; then
    mkdir -p "${HOME}/.ssh"
  fi
  chmod 700 "${HOME}/.ssh"
  export SSH_AUTH_SOCK="${HOME}/.ssh/auth_sock"
  rm -f "${SSH_AUTH_SOCK}"

  # Get Windows username
  if ! command -v whoami.exe &>/dev/null; then
    printf "Error: whoami.exe not found in PATH. Please ensure it is available.\n"
    return 1
  fi
  WINDOWS_USER=$(whoami.exe | sed 's/.*\\//' | tr -d '\r\n')

  # Construct the npiperelay path
  NPIPERELAY_DEFAULT_PATH="/mnt/c/Users/${WINDOWS_USER}/AppData/Local/Microsoft/WinGet/Packages/albertony.npiperelay_Microsoft.Winget.Source_8wekyb3d8bbwe/npiperelay.exe"
  NPIPERELAY="${NPIPERELAY_PATH:-$NPIPERELAY_DEFAULT_PATH}"

  # Try to auto-detect npiperelay.exe via Windows 'where' and convert to WSL path if default is not executable
  if [[ ! -x "${NPIPERELAY}" ]] && command -v where.exe &>/dev/null && command -v wslpath &>/dev/null; then
    win_npiperelay=$(cmd.exe /c "where.exe npiperelay.exe" 2>/dev/null | tr -d '\r' | head -n1)
    if [[ -n "${win_npiperelay}" ]]; then
      npiperelay_unix=$(wslpath -u "${win_npiperelay}" 2>/dev/null)
      if [[ -n "${npiperelay_unix}" ]]; then
        NPIPERELAY="${NPIPERELAY_PATH:-$npiperelay_unix}"
      fi
    else
      printf "Error: npiperelay.exe is not executable\n"
      printf "       Please ensure that npiperelay.exe is installed and accessible e.g.:\n"
      printf "       \e[3mwinget install albertony.npiperelay\e[23m\n"
      return 1
    fi
  fi

  if command -v setsid &>/dev/null && command -v socat &>/dev/null; then
    # Kill previous socat process if PID file exists
    SOCAT_PID_FILE="${HOME}/.ssh/socat_npiperelay.pid"
    if [[ -f "${SOCAT_PID_FILE}" ]]; then
      old_pid=$(<"${SOCAT_PID_FILE}")
      if kill -0 "${old_pid}" &>/dev/null; then
        kill "${old_pid}" &>/dev/null
      fi
      rm -f "${SOCAT_PID_FILE}"
    fi
    # Start new socat process, then record its PID reliably
    ( setsid socat UNIX-LISTEN:"${SSH_AUTH_SOCK}",fork EXEC:"${NPIPERELAY} -ei -s //./pipe/openssh-ssh-agent",nofork >/dev/null 2>&1 & )
    # Give socat a brief moment to start, then capture the pid
    sleep 0.1
    new_pid=$(pgrep -f "socat UNIX-LISTEN:${SSH_AUTH_SOCK}" | head -n1)
    if [[ -n "${new_pid}" ]]; then
      echo "${new_pid}" > "${SOCAT_PID_FILE}"
    fi
  else
    printf "Warning: 'setsid' or 'socat' not found; SSH agent bridging not started.\n"
  fi
}

function _nredf_set_ssh_agent_gpg() {
  if command -v gpgconf &>/dev/null; then
    # Only set SSH_AUTH_SOCK if not in an SSH session and this shell did not already set it (gnupg_SSH_AUTH_SOCK_by tracks the PID that set the socket)
    if [[ -z "${SSH_CONNECTION}" && "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
      unset SSH_AGENT_PID
      SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
      export SSH_AUTH_SOCK
      export gnupg_SSH_AUTH_SOCK_by=$$
    fi
  fi
}

function _nredf_set_ssh_agent() {
  if [[ -n "${WSL_DISTRO_NAME}" ]] || [[ -n "${WSL_INTEROP}" ]]; then
    _nredf_set_ssh_agent_wsl
  else
    _nredf_set_ssh_agent_gpg
  fi
}
