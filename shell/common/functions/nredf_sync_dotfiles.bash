#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_sync_dotfiles() {
  if [[ ! -d "${HOME}/.homesick" ]]; then
    _nredf_install_homeshick
  else
    source "${HOME}/.homesick/repos/homeshick/homeshick.sh"
    fpath=("${HOME}/.homesick/repos/homeshick/completions" "${fpath[@]}")
  fi

  _nredf_add_castles

  # We will wait cause the could be something new
  while ! _nredf_create_lock; do
    sleep 1
  done

  if _nredf_last_run; then
    _nredf_remove_lock
    return 0
  fi

  echo -e '\033[1mChecking dotfiles\033[0m'
  homeshick --quiet check
  case ${?} in
    86)
      echo -e '\033[1m  Pulling dotfiles\033[0m'
      if homeshick --batch --force pull; then
        echo -e '\033[1m  Linking dotfiles\033[0m'
        homeshick --batch --force link
        _nredf_remove_lock
        exec ${SHELL}
      else
        echo -e '\033[1m  Linking dotfiles\033[0m'
        homeshick --batch --force link
        return 1
      fi
      ;;
    85)
      echo -e '\033[1;38;5;222m  Your dotfiles are ahead of its upstream, consider pushing\033[0m'
      echo -e '\033[1m  Linking dotfiles\033[0m'
      homeshick --batch --force link
      ;;
    88)
      echo -e '\033[1;38;5;222m  Your dotfiles are modified, commit or discard changes to update them\033[0m'
      echo -e '\033[1m  Linking dotfiles\033[0m'
      homeshick --batch --force link
      ;;
  esac
  if command -pv fc-cache &>/dev/null; then
    fc-cache -f
  fi
  _nredf_last_run "" "true"
  _nredf_remove_lock
}

function _nredf_install_homeshick() {
  if [[ ! -d "${HOME}/.homesick" ]]; then
    echo -e '\033[1mInstalling homesick\033[0m'
    git clone https://github.com/andsens/homeshick.git "${HOME}/.homesick/repos/homeshick"
  fi
  source "${HOME}/.homesick/repos/homeshick/homeshick.sh"
  fpath=("${HOME}/.homesick/repos/homeshick/completions" "${fpath[@]}")
}

function _nredf_add_castles() {
  if [[ ! -f "${XDG_CONFIG_HOME}/nredf/CASTLES" ]]; then
    if command -pv homeshick &>/dev/null; then
      homeshick ls | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" | awk '{$1=$1;print $2}' > "${XDG_CONFIG_HOME}/nredf/CASTLES"
      return 0
    else
      _nredf_install_homeshick
      homeshick ls | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" | awk '{$1=$1;print $2}' > "${XDG_CONFIG_HOME}/nredf/CASTLES"
    fi
  else
    diff --changed-group-format='%>' --unchanged-group-format='' \
    <(sort "${XDG_CONFIG_HOME}/nredf/CASTLES") \
    <(homeshick ls | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" | awk '{$1=$1;print $2}' | sort) \
    > "${XDG_CONFIG_HOME}/nredf/CASTLES.tmp"
    if [[ -s "${XDG_CONFIG_HOME}/nredf/CASTLES.tmp" ]]; then
      cat "${XDG_CONFIG_HOME}/nredf/CASTLES.tmp" >> "${XDG_CONFIG_HOME}/nredf/CASTLES"
      rm -f "${XDG_CONFIG_HOME}/nredf/CASTLES.tmp"
    else
      return 0
    fi
  fi

  while read -r NREDF_CASTLE; do
    if [[ ${NREDF_CASTLE} =~ ^# ]]; then
      continue
    fi
    # shellcheck disable=SC2155
    local NREDF_CASTLE_NAME=$(echo "${NREDF_CASTLE}" | awk -F '/' '{sub(/\.git$/,""); print $5}')
    echo -e "\033[1m  Cloning castle \"${NREDF_CASTLE_NAME}\"\033[0m"
    homeshick --quiet --batch clone "${NREDF_CASTLE}"
  done < "${XDG_CONFIG_HOME}/nredf/CASTLES"
}
