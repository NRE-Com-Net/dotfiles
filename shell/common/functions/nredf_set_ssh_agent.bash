#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_set_ssh_agent() {
  if [[ -n "${WSL_DISTRO_NAME}" ]] || [[ -n "${WSL_INTEROP}" ]]; then
    # Ensure socket directory exists
    if [[ ! -d "${HOME}/.ssh" ]]; then
      mkdir -p "${HOME}/.ssh"
    fi
    export SSH_AUTH_SOCK="${HOME}/.ssh/auth_sock"
    rm -f "${SSH_AUTH_SOCK}"

    # Get Windows username
    if ! command -v whoami.exe &>/dev/null; then
      printf "Error: whoami.exe not found in PATH. Please ensure it is available.\n"
      return 1
    fi
    WINDOWS_USER=$(whoami.exe | sed 's/.*\\//' | tr -d '\r\n')

    # Construct the npiperelay path
    # NOTE: The default path assumes npiperelay.exe is installed via WinGet in the default location.
    # If your installation is elsewhere, set NPIPERELAY_PATH in your environment to override.
    NPIPERELAY_DEFAULT_PATH="/mnt/c/Users/${WINDOWS_USER}/AppData/Local/Microsoft/WinGet/Packages/albertony.npiperelay_Microsoft.Winget.Source_8wekyb3d8bbwe/npiperelay.exe"
    NPIPERELAY="${NPIPERELAY_PATH:-$NPIPERELAY_DEFAULT_PATH}"

    if [[ ! -x "${NPIPERELAY}" ]]; then
      printf "Error: npiperelay.exe is not executable\n"
      printf "       Please ensure that npiperelay.exe is installed and accessible:\n"
      printf "       \e[3mwinget install albertony.npiperelay\e[23m\n"
      return 1
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
      # Start new socat process and save its PID
      ( setsid socat UNIX-LISTEN:"${SSH_AUTH_SOCK}",fork EXEC:"${NPIPERELAY} -ei -s //./pipe/openssh-ssh-agent",nofork & echo $! > "${SOCAT_PID_FILE}" ) >/dev/null 2>&1
    fi
  elif command -v gpgconf &>/dev/null; then
    if [[ -z ${SSH_CONNECTION} && "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
      unset SSH_AGENT_PID
      SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
      export SSH_AUTH_SOCK
    fi
  fi
}
