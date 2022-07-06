# TMUX
local main_attached="$(tmux list-sessions -F '#S #{session_attached}' \
    2>/dev/null \
    | sed -n 's/^main[[:space:]]//p')"
if [[ "$main_attached" -le '0' ]] && [[ "$TERM" != 'linux' ]] && [[ ! "${TERMINAL_EMULATOR}" =~ .*JetBrains.* ]]; then
    tmux new -A -s main >/dev/null 2>&1
    exit
fi
