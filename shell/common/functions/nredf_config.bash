#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh


function _nredf_read_config() {
  declare -A NREDF_CONFIGS

  for CONFIG in "${!NREDF_CONFIGS[@]}"; do
    local CONFIG_SECTION="${CONFIG%,*}"
    local CONFIG_KEY="${CONFIG#*,}"
    local CONFIG_VALUE="${CONFIG[${CONFIG}]}"
  done
}
