#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_cls() {
  typeset -i COUNT LINES_BEFOREEND
  COUNT=1
  shopt -s checkwinsize 2>/dev/null
  local LINES=${LINES:-(tput lines)}
  local LINES_BEFOREEND=$(( LINES - 1 ))
  while ((COUNT<=LINES_BEFOREEND)); do
    echo ""
    ((COUNT++))
  done
  printf '\33[%sA' "${LINES_BEFOREEND}"
}
