#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_github_latest_release() {
  local GHUSER=${1}
  local GHREPO=${2}
  local TAGREGEX=${3:-""}
  local PREFIX=${4:-""}
  local CACHEFILE="${NREDF_GHCACHE}/nredf_github_latest_release-${GHUSER}-${GHREPO}" local GITHUB_AUTH

  if [[ ! -s "${CACHEFILE}" || $(date -r "${CACHEFILE}" +%s) -le $(($(date +%s) - 3600 )) ]]; then
    if command -v jq &>/dev/null; then
      # shellcheck disable=SC2086
      command curl "${NREDF_CURL_GITHUB_AUTH}" -fs "https://api.github.com/repos/${GHUSER}/${GHREPO}/releases" | command jq -r 'first(.[].tag_name | select(startswith("'${TAGREGEX}'"))) | sub("'^${PREFIX}'"; "")' > "${CACHEFILE}"
    else
      # shellcheck disable=SC2086
      command curl "${NREDF_CURL_GITHUB_AUTH}" -fs "https://api.github.com/repos/${GHUSER}/${GHREPO}/releases" | command grep -Eo '"tag_name":[![:space:]]*"'${TAGREGEX}'[-.0-9a-zA-Z]*"' | command awk -F '"' '{print $4}' | command sed -e "s/^${PREFIX}//" | command head -n1 > "${CACHEFILE}"
    fi
  fi
  cat "${CACHEFILE}"
}
