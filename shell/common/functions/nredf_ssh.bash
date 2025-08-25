#!/usr/bin/env bash

# Alias function for 'ssh'
function nredf_ssh() {
  # Check if the first argument is a valid host alias
  # You can add logic here to determine whether to use sshpass or not
  # For now, we'll assume it's a known host
  _nredf_sshpass_totp "$@"
}

# Function for SSH login using TOTP via sshpass
function _nredf_sshpass_totp() {
  local host="$1"

  if [[ -z "${host}" ]]; then
    echo "Usage: nredf_ssh <ssh_host>"
    return 1
  fi

  local totp_host proxyjump pj_first
  if proxyjump=$(ssh -G "$host" | awk 'tolower($1)=="proxyjump"{print $2; f=1; exit} END{exit(f?0:1)}'); then
    pj_first=$(
      awk -v s="${proxyjump}" 'BEGIN {
      split(s, a, ",");
      first = a[1];
      sub(/^[^@]*@/, "", first);
      sub(/:.*/, "", first);
      print first
      }'
    )
  fi

  if ssh -G "$pj_first" | awk 'tolower($1)=="setenv"{for(i=2;i<=NF;i++){split($i,a,"="); if(a[1]=="TOTP_ITEMID") f=1}} END{exit(f?0:1)}'; then
    totp_host="${pj_first}"
  elif ssh -G "${host}" | awk 'tolower($1)=="setenv"{for(i=2;i<=NF;i++){split($i,a,"="); if(a[1]=="TOTP_ITEMID") f=1}} END{exit(f?0:1)}'; then
    totp_host="${host}"
  else
    ssh "${@}"
  fi

  local totp_itemid
  totp_itemid=$(
    ssh -G "${totp_host}" | awk '
      tolower($1)=="setenv" {
        for (i=2; i<=NF; i++) {
          split($i,a,"=");
          if (a[1]=="TOTP_ITEMID") v=a[2];
        }
      }
      END { if (v!="") print v }
    '
  )

  if [ "$(command -v bw)" ]; then
    item_totp=$(_nredf_sshpass_bitwarden_totp "$totp_itemid")
  fi

  if [[ -z "${item_totp}" ]]; then
    ssh "${@}"
  else
    sshpass -p "${item_totp}" ssh "${@}"
  fi
}

function _nredf_sshpass_bitwarden_totp() {
  local itemid="$1"
  local totp

  if ! bw login --check &>/dev/null; then
    BW_SESSION=$(bw login --raw)
    export BW_SESSION
  fi

  if ! bw unlock --check &>/dev/null; then
    BW_SESSION=$(bw unlock --raw)
    export BW_SESSION
  fi

  totp=$(bw get totp "${itemid}" --raw)

  echo "$totp"
}
