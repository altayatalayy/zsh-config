# path
export PATH=$PATH:/usr/local/go/bin

source "$ZDOTDIR/aliases.sh"
eval "$(fzf --zsh)"

fpath=("$ZDOTDIR/functions" $fpath)

autoload -Uz unlock_vault get_access_token

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
setopt prompt_subst

# Display python venv name
function virtualenv_info {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "("$(basename "$VIRTUAL_ENV")") "
    else
        echo ""
    fi
}


set_prompt() {
    vcs_info
    local venv_info="$(virtualenv_info)"
    if [[ -z ${vcs_info_msg_0_} ]]; then
        PROMPT='%B%(?.%F{green}➜.%F{red}➜)%f  '${venv_info}'%F{cyan}%1~ %f%b'
    else
        PROMPT='%B%(?.%F{green}➜.%F{red}➜)%f  '${venv_info}'%F{cyan}%1~ %f%F{blue}git:(%f%F{red}${vcs_info_msg_0_}%f%F{blue})%f%b '
    fi
}

precmd_functions+=(set_prompt)

setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

# vim mode
bindkey -v
export KEYTIMEOUT=1
bindkey -v '^?' backward-delete-char # make backspace work

# you should always load the module zsh/complist before autoloading compinit
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# normal mode -> block, insert mode -> beam
cursor_mode() {
    # See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
    cursor_block='\e[2 q'
    cursor_beam='\e[6 q'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] ||
            [[ $1 = 'block' ]]; then
            echo -ne $cursor_block
        elif [[ ${KEYMAP} == main ]] ||
            [[ ${KEYMAP} == viins ]] ||
            [[ ${KEYMAP} = '' ]] ||
            [[ $1 = 'beam' ]]; then
            echo -ne $cursor_beam
        fi
    }

    zle-line-init() {
        echo -ne $cursor_beam
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}

cursor_mode

# completion
autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files


# when you’re in NORMAL mode, you can hit v to directly edit your command in your editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line


# adding text objects
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done


# Vim surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
