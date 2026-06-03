# Prompt for zsh shell
#
# Modified from github.com/kirelagin/prompt_kir
#
# Sid Desai 2019

local prompt_distro_fg=${DISTRO_COLOUR:-green}
local prompt_host_fg=${HOST_COLOUR:-cyan}
local prompt_root_red=196
#local prompt_line_fg="%(!.$prompt_root_red.15)"
local prompt_line_fg="8"
local prompt_paren_fg="8"
local prompt_venv_fg="5"

local prompt_head_start="."
local prompt_line="-"
local prompt_branch="|"
local prompt_arrow_start="\`"
local prompt_arrow_user=">"
local prompt_arrow_root="%F{white}%K{$prompt_root_red}#%k%f"
local prompt_dots="..."
local prompt_urcorner="+"
local prompt_lrcorner="+"

prompt_enable_utf8() {
  prompt_head_start="┌"
  prompt_line="─"
  prompt_branch="├"
  prompt_arrow_start="└"
  prompt_arrow_user="›"
  prompt_dots="…"
  prompt_urcorner="┐"
  prompt_lrcorner="┘"
}


# Beginning of an arrow: \-
prompt_start_input_line() {
  echo "%F{$prompt_line_fg}${prompt_arrow_start}${prompt_line}%f"
}

# Turns \- into |- on the previous line
prompt_branch_prev_line() {
  # Not sure about this one, there are some extra quotes in adam2 for some reason
  echo "%{\e[A\r%}%F{$prompt_line_fg}$prompt_branch%f%{\e[B\r%}"
}

venv_info() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo $(basename "$VIRTUAL_ENV")
    elif [ -n "$CONDA_PREFIX" ]; then
        echo $(basename "$CONDA_PREFIX")
    fi
}

prompt_subst_width() {
  local _s=$1
  echo ${#${(S%%)_s}}
}

prompt_replicate() {
    local char="$1" size="$2"
    eval "echo \${(l:${size}::${char}:)}"
}

prompt_ps1_line1() {
  local pre_prompt="%F{$prompt_line_fg}${prompt_head_start}${prompt_line}%f"
  local venv_prompt=""
  if [ $VIRTUAL_ENV ] || [ $CONDA_PREFIX ]; then
    venv_prompt="$venv_prompt%F{$prompt_paren_fg}(%f"
    venv_prompt="$venv_prompt%F{$prompt_venv_fg}"$(venv_info)"%f"
    venv_prompt="$venv_prompt%F{$prompt_paren_fg})%f"
  fi
  local dir1_prompt="%F{$prompt_paren_fg}(%f"
  dir1_prompt="$dir1_prompt%B%F{$prompt_distro_fg}%~%f%b"
  local dir2_prompt="%F{$prompt_paren_fg})%f"
  local host_prompt="%F{$prompt_paren_fg}(%f"
  host_prompt=$host_prompt"%F{$prompt_host_fg}%(!.%K{$prompt_root_red}.)%n%(!.%K.)@%f"
  host_prompt=$host_prompt"%F{$prompt_host_fg}%B%m%b%f"
  host_prompt=$host_prompt"%F{$prompt_paren_fg})%f"
  host_prompt=$host_prompt"%F{$prompt_line_fg}${prompt_line}${prompt_urcorner}%f"

  # First calculate widths
  local venv_width=0
  if [ $VIRTUAL_ENV ] || [ $CONDA_PREFIX ]; then
      venv_width=$(( 2 + $(prompt_subst_width "$(venv_info)") ))
  fi
  local dir_width=$(( 2 + $(prompt_subst_width "%~") ))
  local host_width=$(( 5 + $(prompt_subst_width "%n%m") ))

  local git_prompt=$_prompt_git_info
  local git_width=$_prompt_git_width

  # Try to fit all parts:
  local padding_size=$(( COLUMNS - 2 - venv_width - dir_width - git_width - host_width ))
  if (( padding_size > 0 )); then
    local padding=%F{$prompt_line_fg}$(prompt_replicate "$prompt_line" "$padding_size")%f
    echo "${pre_prompt}${venv_prompt}${dir1_prompt}${git_prompt}${dir2_prompt}${padding}${host_prompt}"
    return
  fi

  # Try dropping host
  padding_size=$(( padding_size + host_width ))
  if (( padding_size > 0 )); then
    local padding=%F{$prompt_line_fg}$(prompt_replicate "$prompt_line" "$padding_size")%f
    echo "${pre_prompt}${venv_prompt}${dir1_prompt}${git_prompt}${dir2_prompt}${padding}"
    return
  fi

  # Try dropping git
  padding_size=$(( padding_size + git_width ))
  if (( padding_size > 0 )); then
    local padding=%F{$prompt_line_fg}$(prompt_replicate "$prompt_line" "$padding_size")%f
    echo "${pre_prompt}${venv_prompt}${dir1_prompt}${dir2_prompt}${padding}"
    return
  fi

  # Truncate dir:
  padding_size=$(( padding_size + dir_width - 2))
  dir1_prompt="%F{$prompt_paren_fg}(%f"
  dir1_prompt=$dir1_prompt"%B%F{$prompt_distro_fg}%$padding_size<${prompt_dots}<%~%<<%f%b"
  echo "${pre_prompt}${venv_prompt}${dir1_prompt}${dir2_prompt}"
}

prompt_ps1_line2() {
  if [ $VIRTUAL_ENV ]; then
      prompt_host_fg=$prompt_venv_fg
  fi
  echo "$(prompt_start_input_line)%F{$prompt_host_fg}%B%(!.${prompt_arrow_root}.${prompt_arrow_user})%b%f "
}

prompt_ps2() {
  echo "$(prompt_branch_prev_line)$(prompt_start_input_line)%F{$prompt_distro_fg}%B%_${prompt_arrow_user}%b%f "
}

prompt_ps3() {
  echo "$(prompt_branch_prev_line)$(prompt_start_input_line)%F{$prompt_distro_fg}%B?#%b%f "
}


prompt_rps1() {
  echo "${VIMODE}%(?..%B%F{red}↵ %?%f%b )%F{$prompt_paren_fg}(%f%F{yellow}%D{%H:%M:%S}%F{$prompt_paren_fg})%f%F{$prompt_line_fg}${prompt_line}${prompt_lrcorner}%f"
}

VIMODE=''
zle-keymap-select() {
  case $KEYMAP in
    vicmd)      VIMODE='%F{8}[N]%f ' ;;
    viins|main) VIMODE='' ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select
autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_reset_vimode
_prompt_reset_vimode() { VIMODE='' }

ZLE_RPROMPT_INDENT=0
setopt PROMPT_SUBST PROMPT_CR PROMPT_SP PROMPT_PERCENT
PS1=$'$(prompt_ps1_line1)\n$(prompt_ps1_line2)'
RPS1='$(prompt_rps1)'
PS2=$'$(prompt_ps2)'
PS3=$'$(prompt_ps3)'
zle_highlight[(r)default:*]="default:bold"

if [[ ${LC_ALL:-${LC_CTYPE:-$LANG}} = *UTF-8* ]]; then
  prompt_enable_utf8
fi

# --- Async git status ---
# Globals updated by the background job and read by prompt_ps1_line1.
typeset -g _prompt_git_info=""
typeset -g _prompt_git_width=0
typeset -g _prompt_git_async_fd=

# Runs in a process substitution subshell; prints "width\nprompt_string" to stdout.
_prompt_git_compute() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || { printf '0\n'; return }

    local git_prompt=" %F{green}⎇ ${branch}%f"
    local git_width=$(( 3 + ${#branch} ))

    local _git_status
    _git_status=$(git status --porcelain 2>/dev/null)
    if [[ -n $_git_status ]]; then
        local _sym="" _sym_count=0 _a=0 _m=0 _d=0 _r=0 _u=0 _t=0
        while IFS= read -r _l; do
            [[ ${_l[1]} == '?' && ${_l[2]} == '?' ]] && _t=1 && continue
            [[ ${_l[1]} == 'A' || ${_l[2]} == 'A' ]] && _a=1
            [[ ${_l[1]} == 'M' || ${_l[2]} == 'M' ]] && _m=1
            [[ ${_l[1]} == 'D' || ${_l[2]} == 'D' ]] && _d=1
            [[ ${_l[1]} == 'R' || ${_l[2]} == 'R' ]] && _r=1
            [[ ${_l[1]} == 'U' || ${_l[2]} == 'U' ]] && _u=1
        done <<< "$_git_status"
        (( _a )) && _sym+="%F{green}✚%f"   && (( _sym_count++ ))
        (( _m )) && _sym+="%F{blue}✹%f"    && (( _sym_count++ ))
        (( _d )) && _sym+="%F{red}✖%f"     && (( _sym_count++ ))
        (( _r )) && _sym+="%F{magenta}➜%f" && (( _sym_count++ ))
        (( _u )) && _sym+="%F{yellow}═%f"  && (( _sym_count++ ))
        (( _t )) && _sym+="%F{cyan}✭%f"    && (( _sym_count++ ))
        git_prompt+=" $_sym"
        git_width=$(( git_width + 1 + _sym_count ))
    fi

    local _git_remote _tracking=""
    _git_remote=$(git rev-list --count --left-right HEAD...@{upstream} 2>/dev/null)
    if [[ -n $_git_remote ]]; then
        local _ahead=${_git_remote%%$'\t'*}
        local _behind=${_git_remote##*$'\t'}
        (( _ahead  > 0 )) && _tracking+="↑${_ahead}"
        (( _behind > 0 )) && _tracking+="↓${_behind}"
        if [[ -n $_tracking ]]; then
            git_prompt+=" %F{8}${_tracking}%f"
            git_width=$(( git_width + 1 + ${#_tracking} ))
        fi
    fi

    printf '%s\n%s\n' "$git_width" "$git_prompt"
}

# ZLE fd-widget: called when _prompt_git_compute's output is ready.
_prompt_git_async_callback() {
    local fd=$1
    zle -F "$fd" 2>/dev/null
    IFS= read -r -u $fd _prompt_git_width
    IFS= read -r -u $fd _prompt_git_info
    exec {fd}<&-
    _prompt_git_async_fd=
    zle reset-prompt 2>/dev/null
}
zle -N _prompt_git_async_callback

# ZLE line-init hook: fires as each prompt appears; starts a background git job.
_prompt_git_async_start() {
    # Cancel any in-flight job from the previous prompt.
    if [[ -n $_prompt_git_async_fd ]]; then
        zle -F "$_prompt_git_async_fd" 2>/dev/null
        exec {_prompt_git_async_fd}<&- 2>/dev/null
        _prompt_git_async_fd=
    fi
    exec {_prompt_git_async_fd}< <(_prompt_git_compute) 2>/dev/null
    [[ -n $_prompt_git_async_fd && _prompt_git_async_fd -gt 0 ]] || return
    zle -Fw "$_prompt_git_async_fd" _prompt_git_async_callback
}
zle -N _prompt_git_async_start
autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-init _prompt_git_async_start
