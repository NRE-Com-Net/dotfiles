#!/usr/bin/env bash
#
# vim: ts=2 sw=2 et ff=unix ft=bash syntax=sh

function _nredf_set_defaults() {
  echo -e '\033[1mSetting defaults\033[0m'
  [[ -f "${HOME}/.proxy.local" ]] && source "${HOME}/.proxy.local"

  export NREDF_COMMON_RC_LOCAL="${HOME}/.config/shell"
  export NREDF_RC_PATH="${NREDF_DOT_PATH}/shell/${NREDF_SHELL_NAME}"
  export NREDF_RC_LOCAL="${HOME}/.config/${NREDF_SHELL_NAME}"

  # You may need to manually set your language environment
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8

  export XDG_CONFIG_HOME="${HOME}/.config"
  export XDG_CACHE_HOME="${HOME}/.cache"
  export XDG_BIN_HOME="${HOME}/.local/bin"
  export XDG_DATA_HOME="${HOME}/.local/share"
  export XDG_STATE_HOME="${HOME}/.local/state"
  export NREDF_CONFIG="${XDG_CONFIG_HOME}/nredf"
  export NREDF_DOWNLOADS="${XDG_CACHE_HOME}/nredf/Download"
  export NREDF_GHCACHE="${XDG_CACHE_HOME}/nredf/GHVersionCache"
  export NREDF_LRCACHE="${XDG_CACHE_HOME}/nredf/LRCache"
  export NREDF_LKCACHE="${XDG_CACHE_HOME}/nredf/LKCache"
  for XDG_PATH in "${NREDF_RC_LOCAL}" "${NREDF_COMMON_RC_LOCAL}" "${XDG_CONFIG_HOME}" "${XDG_BIN_HOME}" "${XDG_CACHE_HOME}" "${NREDF_CONFIG}" "${NREDF_GHCACHE}" "${NREDF_LRCACHE}" "${NREDF_LKCACHE}" "${NREDF_DOWNLOADS}" "${XDG_DATA_HOME}" "${XDG_STATE_HOME}"; do
    [[ ! -d "${XDG_PATH}" ]] && mkdir -p "${XDG_PATH}"
  done

  export PATH="${HOME}/bin:${XDG_BIN_HOME}:/usr/local/bin:${PATH}"
  [[ -d /snap/bin ]] && export PATH="${PATH}:/snap/bin"
  export GOPATH="${HOME}/.local"
  export RLWRAP_HOME="${XDG_CACHE_HOME}/RLWRAP"
  [[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"

  #set editor to vim/nvim
  if command -v hx &>/dev/null; then
    export EDITOR="hx"
    export GIT_EDITOR="hx"
  elif command -v nvim &>/dev/null; then
    export EDITOR="nvim"
    export GIT_EDITOR="nvim"
  else
    export EDITOR="vi"
    export GIT_EDITOR="vi"
  fi

  # Load PYENV if you are using it
  if [[ -s ${HOME}/.pyenv ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
  fi

  # FZF Defaults
  export FZF_DEFAULT_OPTS='--bind tab:down --bind btab:up --cycle --ansi'
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
    export FZF_ALT_C_COMMAND="fd --type directory --hidden --follow --exclude .git"
  else
    export FZF_DEFAULT_COMMAND="find -L"
  fi
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

  #  VIM/NVIM Defaults
  # shellcheck disable=SC2016
  export GVIMINIT='let $MYGVIMRC="$XDG_CONFIG_HOME/vim/gvimrc" | source $MYGVIMRC'
  # shellcheck disable=SC2016
  export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
  export NVIM_LOG_FILE="${XDG_CACHE_HOME}/vim/nvim_debug.log"
  export NVIM_RPLUGIN_MANIFESTE="${XDG_CACHE_HOME}/vim/rplugin.vim"

  # Timewarrior
  export TIMEWARRIORDB="${XDG_CACHE_HOME}/timewarrior"

  # docker-compose
  export COMPOSE_PARALLEL_LIMIT=10
  export COMPOSE_HTTP_TIMEOUT=600

  # k9s config directory
  export K9SCONFIG="${XDG_CONFIG_HOME}/k9s"

  # readline config
  export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"

  # screen config
  export SCREENRC="${XDG_CONFIG_HOME}/screen/screenrc"

  # wget config
  export WGETRC="${XDG_CONFIG_HOME}/wgetrc"

  export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"

  export _Z_DATA="${XDG_DATA_HOME}/z"

  # asdf config
  export ASDF_DIR="${HOME}/.homesick/repos/asdf"
  export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
  export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
  export ADSF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME}/asdf/tool-versions"

  # make less more friendly for non-text input files, see lesspipe(1)
  if [ -x /usr/bin/lesspipe ]; then eval "$(SHELL=/bin/sh lesspipe)"; fi

  if command -v dircolors &>/dev/null; then
    if [[ -e "${XDG_CONFIG_HOME}/dircolors" ]]; then eval "$(dircolors "${XDG_CONFIG_HOME}/dircolors")"; fi
  fi

  if [[ -f "${NREDF_CONFIG}/GITHUB.AUTH" ]]; then
    eval "$(cat "${NREDF_CONFIG}"/GITHUB.AUTH)"
    if [[ -n ${NREDF_GITHUB_USERNAME} && -n ${NREDF_GITHUB_TOKEN} ]]; then
      export NREDF_CURL_GITHUB_AUTH="-u ${NREDF_GITHUB_USERNAME}:${NREDF_GITHUB_TOKEN}"
    fi
  fi

  declare -ax NREDF_DEFAULT_TOOLS
  NREDF_DEFAULT_TOOLS[1]=_nredf_tool_btop
  NREDF_DEFAULT_TOOLS[2]=_nredf_tool_atuin
  NREDF_DEFAULT_TOOLS[3]=_nredf_tool_ctop
  NREDF_DEFAULT_TOOLS[4]=_nredf_tool_diskus
  NREDF_DEFAULT_TOOLS[5]=_nredf_tool_duf
  NREDF_DEFAULT_TOOLS[6]=_nredf_tool_dust
  NREDF_DEFAULT_TOOLS[7]=_nredf_tool_fd
  NREDF_DEFAULT_TOOLS[8]=_nredf_tool_fzf
  NREDF_DEFAULT_TOOLS[9]=_nredf_tool_githubcli
  NREDF_DEFAULT_TOOLS[10]=_nredf_tool_helix
  NREDF_DEFAULT_TOOLS[11]=_nredf_tool_jq
  NREDF_DEFAULT_TOOLS[12]=_nredf_tool_lazygit
  NREDF_DEFAULT_TOOLS[13]=_nredf_tool_lsd
  NREDF_DEFAULT_TOOLS[14]=_nredf_tool_ouch
  NREDF_DEFAULT_TOOLS[15]=_nredf_tool_q
  NREDF_DEFAULT_TOOLS[16]=_nredf_tool_ripgrep
  NREDF_DEFAULT_TOOLS[17]=_nredf_tool_yazi
  NREDF_DEFAULT_TOOLS[18]=_nredf_tool_yq
  NREDF_DEFAULT_TOOLS[19]=_nredf_tool_zellij

  if [[ -f "${HOME}/.kube/config" ]]; then
    # Default tools for k8s ops
    NREDF_DEFAULT_TOOLS[20]=_nredf_tool_kubectl
    NREDF_DEFAULT_TOOLS[21]=_nredf_tool_krew
    NREDF_DEFAULT_TOOLS[22]=_nredf_tool_kubeadm
    NREDF_DEFAULT_TOOLS[23]=_nredf_tool_kubeseal
    NREDF_DEFAULT_TOOLS[24]=_nredf_tool_fluxctl
    NREDF_DEFAULT_TOOLS[25]=_nredf_tool_flux
    NREDF_DEFAULT_TOOLS[26]=_nredf_tool_helm
    NREDF_DEFAULT_TOOLS[27]=_nredf_tool_oras
    NREDF_DEFAULT_TOOLS[28]=_nredf_tool_k9s
    NREDF_DEFAULT_TOOLS[29]=_nredf_tool_velero
    NREDF_DEFAULT_TOOLS[30]=_nredf_tool_kustomize
    NREDF_DEFAULT_TOOLS[31]=_nredf_tool_stern
    NREDF_DEFAULT_TOOLS[32]=_nredf_tool_calico
    NREDF_DEFAULT_TOOLS[33]=_nredf_tool_kubent
  fi
}
