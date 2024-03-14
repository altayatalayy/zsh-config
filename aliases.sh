# alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
# alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias d='dirs -v'
for index in {1..9}; do
    alias "$index"="cd +${index}"
done; unset index
