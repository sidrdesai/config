export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="jonathan"
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# zsh-autocomplete appends an auto-removable ';' suffix to recalled history lines;
# in vi mode its suffix-removal eats the last real character too. Disable it.
zstyle ':autocomplete:*' add-semicolon no
source ~/.oh-my-zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

export EDITOR='nvim'
alias vim="nvim"
bindkey -v

# Recall history with the cursor placed after the last character.
_history-up() { zle up-line-or-search; CURSOR=$#BUFFER; }
_history-down() { zle down-line-or-select; CURSOR=$#BUFFER; }
zle -N _history-up
zle -N _history-down

# zsh-autocomplete binds arrows to emacs widgets at load (before bindkey -v),
# so re-apply our widgets in viins for vim insert mode.
bindkey -M viins '^[[A' _history-up
bindkey -M viins '^[[B' _history-down
bindkey -M viins '^[OA' _history-up
bindkey -M viins '^[OB' _history-down
bindkey -M viins '^N' _history-down
bindkey -M viins '^P' _history-up

# Shift-Tab accepts autosuggestion in vim insert mode
bindkey -M viins '^[[Z' autosuggest-accept

# Vim-style navigation inside the completion menu
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'j' down-history
bindkey -M menuselect 'k' up-history
bindkey -M menuselect 'l' forward-char
bindkey -M menuselect '^N' down-history
bindkey -M menuselect '^P' up-history
bindkey -M menuselect '^[' send-break

export VIRTUAL_ENV_DISABLE_PROMPT=1
source ~/config/zsh/prompt.zsh

export PATH="$PATH:/opt/nvim/bin"
source ~/.cargo/env
. "$HOME/.local/bin/env"

export CONDA_CHANGEPS1=false
conda() {
    unfunction conda
    local __conda_setup="$('/home/sid/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    elif [ -f "/home/sid/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/sid/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/sid/miniforge3/bin:$PATH"
    fi
    unset __conda_setup
    conda "$@"
}

export NVM_DIR="$HOME/.nvm"
# Prepend the default node version's bin so node/npm/npx work without triggering nvm.
# The alias file may hold a partial version (e.g. "24"), so glob-match installed dirs.
() {
    [[ -f "$NVM_DIR/alias/default" ]] || return
    local alias=${$(< "$NVM_DIR/alias/default")#v}   # strip leading v if present
    local -a matches=( "$NVM_DIR/versions/node/v${alias}"*(N/) )
    (( ${#matches} )) || return
    export PATH="${matches[-1]}/bin:$PATH"
}
nvm() {
    unfunction nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}

export CUDA_HOME="/usr/local/cuda"
export PATH="$CUDA_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CUDA_HOME/lib64:$LD_LIBRARY_PATH"
