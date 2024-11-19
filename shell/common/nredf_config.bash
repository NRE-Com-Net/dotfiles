#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

declare -A NREDF_CONFIGS
source "${NREDF_DOT_PATH}/shell/common/default_config.bash"
if [[ -e "${NREDF_CONFIG}/config.bash" ]]; then
  source "${NREDF_CONFIG}/config.bash"
fi
echo -n "" > "${NREDF_CONFIG}/config.bash"
for CONFIG in "${!NREDF_CONFIGS[@]}"; do
  CONFIG_KEY="${CONFIG}"
  CONFIG_VALUE="${NREDF_CONFIGS[${CONFIG}]}"
  echo "NREDF_CONFIGS[\"$CONFIG_KEY\"]=\"$CONFIG_VALUE\"" >> "${NREDF_CONFIG}/config.bash"
done
