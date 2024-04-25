#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

_nredf_install_tools_k8s_ops () {
  _nredf_tool_kubectl;
  _nredf_tool_krew;
  _nredf_tool_kubeadm;
  _nredf_tool_kubeseal;
  _nredf_tool_fluxctl;
  _nredf_tool_flux;
  _nredf_tool_helm;
  _nredf_tool_oras;
  _nredf_tool_k9s;
  _nredf_tool_velero;
  _nredf_tool_kustomize;
  _nredf_tool_stern;
  _nredf_tool_calico;
  _nredf_tool_kubent
}
