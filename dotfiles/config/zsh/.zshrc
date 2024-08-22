# -----------------
# Zsh configuration
# -----------------

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

zmodload -F zsh/terminfo +p:terminfo

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '+' '+m:{[:lower:]}={[:upper:]}' '+r:|[._-]=* r:|=*' '+l:|=* r:|=*'
zstyle :compinstall filename ${ZDOTDIR:-${HOME}}/.zshrc
# End of lines added by compinstall

# Poetry completions are added into this location
fpath+=~/.zfunc

autoload -Uz compinit
compinit -d ${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump-$ZSH_VERSION

# Lines configured by zsh-newuser-install
HISTSIZE=1000
SAVEHIST=1000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
# Immediately commit to, and load from, history
setopt share_history
setopt complete_aliases
setopt beep extendedglob
setopt AUTO_CD
unsetopt nomatch
bindkey -v
bindkey "^?" backward-delete-char
# End of lines configured by zsh-newuser-install

# init starship prompt
eval "$(starship init zsh)"

# load aliases
source  ${ZDOTDIR:-${HOME}}/aliases.zsh

# some system installed plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
