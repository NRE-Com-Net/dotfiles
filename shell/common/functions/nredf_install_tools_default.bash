#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_install_tools_default() {
  echo -e "\033[1mLooking for fresh batteries\033[0m"
  _nredf_tool_btop
  _nredf_tool_ctop
  _nredf_tool_diskus
  [[ -f "${HOME}/.local/bin/drone" ]] && _nredf_tool_drone
  _nredf_tool_duf
  _nredf_tool_dust
  _nredf_tool_fd
  _nredf_tool_fzf
  _nredf_tool_helix
  _nredf_tool_jq
  _nredf_tool_lazygit
  _nredf_tool_lf
  _nredf_tool_lsd
  _nredf_tool_q
  _nredf_tool_ripgrep
  _nredf_tool_yq
  _nredf_tool_zellij
  [[ -f "${HOME}/.kube/config" ]] && _nredf_install_tools_k8s_ops
}
