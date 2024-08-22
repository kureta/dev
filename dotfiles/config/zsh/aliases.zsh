# github aliases
alias git-log="git log --graph --pretty=oneline --abbrev-commit --decorate --all"

# ls/lsd aliases
alias l="/usr/bin/lsd"
alias ll="/usr/bin/lsd -l"
alias la="/usr/bin/lsd -a"
alias lt="/usr/bin/lsd --tree --depth=4"
alias lla="/usr/bin/lsd -la"
alias llt="/usr/bin/lsd -l --tree --depth=4"
alias lta="/usr/bin/lsd -a --tree --depth=4"
alias llta="/usr/bin/lsd -la --tree --depth=4"

# tmux shortcut
t() {
  tmux new-session -A -s $([ -z $1 ] && echo $HOST || echo $1)
}
alias tls="tmux ls"

# other
alias vim=nvim
alias wget=wget --hsts-file=${XDG_DATA_HOME:-${HOME}/.local/share}/wget-hsts
alias rm='trash'
