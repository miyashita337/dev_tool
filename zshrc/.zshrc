# .zshrc
export PS1="%10F%m%f:%11F%1~%f \$ "
#export PATH="/usr/local/opt/mysql-client/bin:$PATH"
# some more ls aliases
alias ll='ls -al'
alias lla='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#PROMPT='%F{green}%n@%m%f:%F{cyan}%~%f

# Python
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"


# git
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }

autoload -Uz compinit
compinit

function ssh_color() {
  case $1 in
   # product から始まるところは背景を赤くする
   # staging から始まるところは背景を青くする
   #product-* ) echo -e "\033]50;SetProfile=zsh_red\a" ;;
   #staging-* ) echo -e "\033]50;SetProfile=zsh_blue\a" ;;
   prod-bastion01-a* ) echo -e "\033]50;SetProfile=bs_pro\a" ;;
   *) echo -e "\033]50;SetProfile=zsh\a" ;;
 esac
  ssh $@
  echo -e "\033]50;SetProfile=zsh\a"
}
#
alias ssh='ssh_color'
compdef _ssh ssh_color=ssh

#alias ssh='~/ssh-background'

# プロンプトカスタマイズ
PROMPT='
[%B%F{red}%n@%m%f%b:%F{green}%~%f]%F{cyan}$vcs_info_msg_0_%f
#%F{yellow}$%f '


