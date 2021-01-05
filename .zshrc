
###########
#  ZSHRC  #
###########

export ZSH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH_CONFIG/custom"

ZSH_THEME="random"
if [[ -d $ZSH_CONFIG/themes/powerlevel10k ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"


#####################
#  PLUGIN SETTINGS  #
#####################

# bgnotify settings
bgnotify_threshold=2    ## set your own notification threshold
bgnotify_formatted() {
    ## $1=exit_status, $2=command, $3=elapsed_time
    [[ $1 -eq 0 ]] && title="Zsh" || title="Zsh (fail)"
    bgnotify "$title (${3}s)" "$2"
}

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


########################
#  USER CONFIGURATION  #
########################

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

[[ -f $HOME/.p10k.zsh ]] \
    && source "$HOME/.p10k.zsh"

export PATH=$PATH:/home/adihfalk/.bin:/home/adihfalk/.local/bin
