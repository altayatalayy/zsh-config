# alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
# alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias d='dirs -v'
for index in {1..9}; do
    alias "$index"="cd +${index}"
done; unset index

alias tmux='tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
