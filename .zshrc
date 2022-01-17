###########
#  ZSHRC  #
###########
export ZSH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH_CONFIG/custom"

ZSH_THEME="random"
if [[ -d $ZSH_CUSTOM/themes/powerlevel10k ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

plugins=(
  zsh-syntax-highlighting
  zsh-completions
  zsh-autosuggestions
  git
  kubectl
  web-search
  bgnotify
  asdf
  pyenv
)

# Remove plugins if in tty
[[ "$TERM" = 'linux' ]] \
    && plugins=("${(@)plugins:#zsh-autosuggestions}")

# additional engines need to be loaded before oh-my-zsh is sourced
ZSH_WEB_SEARCH_ENGINES=(
    reddit "https://www.reddit.com/search/?q="
    amazon "https://www.amazon.de/s?k="
)

# Completions
[[ -f "$ZSH_CONFIG/completion.zsh" ]] \
    && source "$ZSH_CONFIG/completion.zsh"

# Oh-My-Zsh
[[ -f "$ZSH/oh-my-zsh.sh" ]] \
    && source "$ZSH/oh-my-zsh.sh"

# p10k
[[ -f $HOME/.p10k.zsh ]] \
    && source "$HOME/.p10k.zsh"

########################
#  USER CONFIGURATION  #
########################

# set -o vi
export EDITOR='vim'
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'


if [ -d ~/.kube/configs ]; then
  if [ -z "$KUBECONFIG_OVERRIDE" ]; then
    export KUBECONFIG=~/.kube/config$(find ~/.kube/configs -type f,l 2>/dev/null | xargs -I % echo -n ":%") 
  else 
    export KUBECONFIG=$KUBECONFIG_OVERRIDE
  fi
fi

# kubeconfig per session & init with context of last session if available
KUBECONFIG_LAST_CTX=`ls -t /tmp | grep kubectx | head -n 1`
KUBECONFIG_NEXT_CTX="$(mktemp -t "kubectx.XXXXXX")"
export KUBECONFIG="${KUBECONFIG_NEXT_CTX}:${KUBECONFIG}"
if [ -z "$KUBECONFIG_LAST_CTX" ]
then
     cat <<EOF >"${KUBECONFIG_NEXT_CTX}"
apiVersion: v1
kind: Config
current-context: ""
EOF
else
  cp "/tmp/${KUBECONFIG_LAST_CTX}" "${KUBECONFIG_NEXT_CTX}"
fi

# Aliases
[[ -f "$ZSH_CONFIG/alias.zsh" ]] \
    && source "$ZSH_CONFIG/alias.zsh"


# pet
function prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}

function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
# [[ $- = *i* ]] && stty -ixon
bindkey '^s' pet-select

# dir hashes
hash -d g=~/git

hash -d a=~/git/ansible

hash -d s=~/git/stuff
hash -d heap=~/git/stuff/_heap
hash -d ws=~/git/stuff/_heap/workspaces
hash -d dump=~/git/stuff/_heap/_dump

hash -d st=~/git/smarttrack
hash -d sta=~/git/smarttrack/app
hash -d sid=~/git/smarttrack/compose
hash -d sth=~/git/smarttrack-helm-charts

hash -d adp=~/git/adp
hash -d adpf=~/git/adp/frontend
hash -d adpb=~/git/adp/backend
hash -d adph=~/git/adp/helm-chart

hash -d pg=~/playground
hash -d ng=~/playground/angular

hash -d dl=~/Downloads

# completion
source <(kubectl completion zsh)
source <(helm completion zsh)
# source '/home/adihfalk/lib/azure-cli/az.completion'
# source '/home/adihfalk/google-cloud-sdk/completion.zsh.inc'
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# exports
export PATH=$PATH:/home/adihfalk/.bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# TMUX
local main_attached="$(tmux list-sessions -F '#S #{session_attached}' \
    2>/dev/null \
    | sed -n 's/^main[[:space:]]//p')"
if [[ "$main_attached" -le '0' ]] && [[ "$TERM" != 'linux' ]] && [[ ! "${TERMINAL_EMULATOR}" =~ .*JetBrains.* ]]; then
    tmux new -A -s main >/dev/null 2>&1
    exit
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/adihfalk/google-cloud-sdk/path.zsh.inc' ]; then . '/home/adihfalk/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/adihfalk/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/adihfalk/google-cloud-sdk/completion.zsh.inc'; fi
export CLOUDSDK_PYTHON=/usr/bin/python2

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
