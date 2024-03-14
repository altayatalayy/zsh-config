# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="/run/user/$UID"

export EDITOR="nvim"
export VISUAL="nvim"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Ensure the base directory for history files exists
mkdir -p "${ZDOTDIR}/history_files"

# Check if inside a tmux session and set history file accordingly
if [ -n "$TMUX" ]; then
    # Extract tmux session name for a unique history file
    TMUX_SESSION_NAME=$(tmux display-message -p '#S')
    HISTFILE="${ZDOTDIR}/history_files/history-${TMUX_SESSION_NAME}"
else
    # Default history file when not in a tmux session
    HISTFILE="${ZDOTDIR}/history_files/history-default"
fi


export HISTFILE
export HISTSIZE=10000
export SAVEHIST=10000

# Enable appending to the history file, rather than overwriting it
setopt APPEND_HISTORY

# Share command history between all sessions, allowing commands entered in one session
# to be seen and reused in other sessions immediately.
setopt SHARE_HISTORY

# Append each command to the history file as soon as it's executed, ensuring that
# commands are preserved even if the session ends unexpectedly.
setopt INC_APPEND_HISTORY

# Verify history expansions for review before execution.
setopt HIST_VERIFY

# Skip duplicate entries when searching command history.
setopt HIST_FIND_NO_DUPS

# Avoid saving consecutive duplicate commands in history.
setopt HIST_IGNORE_DUPS

# Avoid saving duplicate commands in history file
setopt HIST_SAVE_NO_DUPS

# Exclude commands starting with a space from history.
setopt HIST_IGNORE_SPACE
