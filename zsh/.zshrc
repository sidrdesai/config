export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="jonathan"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Arch packages these as system-wide plugins under /usr/share/zsh/plugins
# rather than into $ZSH/custom, so source them directly instead of via
# the oh-my-zsh plugins=() array.
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

export EDITOR='nvim'
alias vim="nvim"
bindkey -v

# Recall history with the cursor placed after the last character.
# Use the dot-prefixed *builtin* widgets: zsh-autocomplete replaces
# `up-line-or-search`/`down-line-or-select` with a history-menu that appends an
# auto-removable ';' suffix (which its removal hook deliberately leaves in place
# for the history-search-backward widget). Bypassing to the builtins avoids it.
_history-up() { zle .up-line-or-search; CURSOR=$#BUFFER; }
_history-down() { zle .down-line-or-history; CURSOR=$#BUFFER; }
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

source ~/.cargo/env

eval $(keychain --eval --quiet id_ed25519)
