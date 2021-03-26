# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_SPACE
setopt extendedglob
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sid/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U promptinit colors
promptinit
colors
source ~/config/zsh/prompt.zsh
alias ls="ls --color"
alias grep="grep --color=auto"
alias octave="octave-cli"
export EDITOR=vim
alias sctl="systemctl"
alias zathura="zathura --fork"
# Tensorflow env variables
export LD_LIBRARY_PATH="/opt/cuda/lib64"
export CUDA_HOME=/opt/cuda/
export VIRTUAL_ENV_DISABLE_PROMPT=1

#enable autocomplete
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
bindkey '[Z' autosuggest-accept
#enable syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/sid/.mujoco/mujoco200/bin

#conda stuff
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda deactivate

