#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_os_specific() {
  case ${NREDF_OS} in
    linux)
      # Nothing yet
      ;;
    darwin)
      if [[ -d "${HOME}/.local/share/NerdFonts" && -d "${HOME}/Library/Fonts" ]]; then
        command cp -r "${HOME}/.local/share/NerdFonts" "${HOME}/Library/Fonts/"
      fi
      ;;
  esac
}
