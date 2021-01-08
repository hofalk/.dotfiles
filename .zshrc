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

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_UPDATE_PROMPT="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"

###############
#  DIRCOLORS  #
###############

#####################
#  PLUGIN SETTINGS  #
#####################

# bgnotify settings
# bgnotify_threshold=2    ## set your own notification threshold
# bgnotify_formatted() {
#     ## $1=exit_status, $2=command, $3=elapsed_time
#     [[ $1 -eq 0 ]] && title="Zsh" || title="Zsh (fail)"
#     bgnotify "$title (${3}s)" "$2"
# }

plugins=(
  zsh-syntax-highlighting
  zsh-completions
  zsh-autosuggestions
  git
  kubectl
  web-search
  bgnotify
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

export EDITOR='vim'

# Base16 Shell # not working
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

if [ -d ~/.kube/configs ]; then
  if [ -z "$KUBECONFIG_OVERRIDE" ]; then
    export KUBECONFIG=~/.kube/config$(find ~/.kube/configs -type f,l 2>/dev/null | xargs -I % echo -n ":%") 
  else 
    export KUBECONFIG=$KUBECONFIG_OVERRIDE
  fi
fi

# kubeconfig per session
file="$(mktemp -t "kubectx.XXXXXX")"
export KUBECONFIG="${file}:${KUBECONFIG}"
cat <<EOF >"${file}"
apiVersion: v1
kind: Config
current-context: ""
EOF


# Aliases
[[ -f "$ZSH_CONFIG/alias.zsh" ]] \
    && source "$ZSH_CONFIG/alias.zsh"


# aliases

function ide() { idea "$@" > /dev/null 2>&1 & }
function cc () { export KUBECONFIG=~/git/infra/gitops-kubernetes-cluster/cluster/$1/infra/output/kubeconfig.yaml }
function delkh () { sed  -i -e "$1d" ~/.ssh/known_hosts }
function mcd () { mkdir -p $1; cd $1 }
# function pgdir() { PGDIR=`date +%F`-$1; mkdir -p ~pg/$PGDIR; cd ~pg/$PGDIR }
function wsdir() { mkdir -p ~ws/$PGDIR; cd ~ws/$PGDIR }

## ansible shortcut functions
function aci () { ansible -i ~a/ci_hosts.yml $1 -k $@ }
function arun () { ansible -i ~a/ci_hosts.yml $1 -k -m shell -a "$2" ${@:3} }
function aruno () { ansible -i ~a/ci_hosts.yml $1 -ok -m shell -a "$2" ${@:3} }
function arunx () { set -x; ansible -i ~a/ci_hosts.yml $1 -k -m shell -a "$2" ${@:3} }
function apb () { ansible-playbook -i ~a/ci_hosts.yml -kbK ~a/playbooks/$1.yml ${@:2} }
function apbc () { ansible-playbook -i ~a/ci_hosts.yml -kbKC ~a/playbooks/$1.yml ${@:2} }

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
hash -d g=~/git/
hash -d h=~/git/helm/
hash -d c=~/git/cloud/

hash -d i=~/git/infra/
hash -d a=~/git/infra/ansible/

hash -d s=~/git/stuff/
hash -d dot=~/git/stuff/dot/
hash -d heap=~/git/stuff/_heap/
hash -d ws=~/git/stuff/_heap/workspaces/
hash -d dump=~/git/stuff/_heap/_dump/

hash -d tf=~/git/cloud/terraform/

hash -d st=~/git/smarttrack/
hash -d sta=~/git/smarttrack/app/
hash -d stc=~/git/smarttrack/compose/
hash -d sth=~/git/helm/smarttrack-helm-charts/

hash -d adp=~/git/adp/
hash -d adpf=~/git/adp/adp-frontend/
hash -d adpb=~/git/adp/adp-backend/

hash -d pg=~/playground/
hash -d ng=~/playground/angular/

hash -d dl=~/Downloads/

# completion
source <(kubectl completion zsh)
source <(velero completion zsh)
source <(helm completion zsh)
# source '/home/adihfalk/lib/azure-cli/az.completion'
# source '/home/adihfalk/google-cloud-sdk/completion.zsh.inc'
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/adihfalk/google-cloud-sdk/path.zsh.inc' ]; then . '/home/adihfalk/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/adihfalk/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/adihfalk/google-cloud-sdk/completion.zsh.inc'; fi



# exports
export PATH=$PATH:/home/adihfalk/bin:/home/adihfalk/.local/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
