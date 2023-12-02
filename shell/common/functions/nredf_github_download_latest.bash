#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_github_download_latest() {
  local GHUSER=${1}
  local GHREPO=${2}
  local GHFILE=${3}
  local VERSION=${4}
  local VERSIONURLENC

  if [[ ${VERSION} == "latest" ]]; then
    command curl -Lfso "${NREDF_DOWNLOADS}/${GHFILE}" "https://github.com/${GHUSER}/${GHREPO}/releases/latest/download/${GHFILE}"
  else
    VERSIONURLENC=$(_nredf_urlencode "${VERSION}")
    command curl -Lfso "${NREDF_DOWNLOADS}/${GHFILE}" "https://github.com/${GHUSER}/${GHREPO}/releases/download/${VERSIONURLENC}/${GHFILE}"
  fi

  return ${?}
}
