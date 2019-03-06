# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sid/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit
promptinit
source ~/config/zsh/prompt.zsh
alias ls="ls --color"
alias octave="octave-cli"
export EDITOR=vim
alias sctl="systemctl"
alias zathura="zathura --fork"
# Tensorflow env variables
export LD_LIBRARY_PATH="/opt/cuda/lib64"
export CUDA_HOME=/opt/cuda/
export VIRTUAL_ENV_DISABLE_PROMPT=1
