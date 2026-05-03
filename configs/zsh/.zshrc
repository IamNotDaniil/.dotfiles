export ZDOTDIR="$HOME"
source "$HOME/.exports"
source "$HOME/.aliases"

setopt HIST_IGNORE_DUPS SHARE_HISTORY
bindkey -e

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats 'git:%b'
PS1=$'┌─[%n@%m]─[%~]─[${vcs_info_msg_0_}]\n└─$ '
