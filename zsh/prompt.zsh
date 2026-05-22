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
    if [ $VIRTUAL_ENV ]; then
        echo `basename $VIRTUAL_ENV`
    elif [ $CONDA_PREFIX ]; then
        echo `basename $CONDA_PREFIX`
    else
        echo ""
    fi
}

prompt_subst_width() {
  echo ${#${(S%%)1}}
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
  local dir2_prompt="$dir_prompt%F{$prompt_paren_fg})%f"
  local host_prompt="%F{$prompt_paren_fg}(%f"
  host_prompt=$host_prompt"%F{$prompt_host_fg}%(!.%K{$prompt_root_red}.)%n%(!.%K.)@%f"
  host_prompt=$host_prompt"%F{$prompt_host_fg}%B%m%b%f"
  host_prompt=$host_prompt"%F{$prompt_paren_fg})%f"
  host_prompt=$host_prompt"%F{$prompt_line_fg}${prompt_line}${prompt_urcorner}%f"

  # First calculate widths
  local venv_width=0
  if [ $VIRTUAL_ENV ] || [ $CONDA_PREFIX ]; then
      venv_width=$(( 2 + $(prompt_subst_width $(venv_info)) ))
  fi
  local dir_width=$(( 2 + $(prompt_subst_width "%~") ))
  local host_width=$(( 5 + $(prompt_subst_width "%n%m") ))

  local git_prompt=""
  local git_width=0
  local _git_branch
  _git_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n $_git_branch ]]; then
    local _git_status
    _git_status=$(git status --porcelain 2>/dev/null)
    git_prompt=" %F{green}⎇ ${_git_branch}%f"
    git_width=$(( 3 + ${#_git_branch} ))
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
    local _git_remote _ahead _behind _tracking=""
    _git_remote=$(git rev-list --count --left-right HEAD...@{upstream} 2>/dev/null)
    if [[ -n $_git_remote ]]; then
      _ahead=${_git_remote%%$'\t'*}
      _behind=${_git_remote##*$'\t'}
      (( _ahead > 0 ))  && _tracking+="↑${_ahead}"
      (( _behind > 0 )) && _tracking+="↓${_behind}"
      if [[ -n $_tracking ]]; then
        git_prompt+=" %F{8}${_tracking}%f"
        git_width=$(( git_width + 1 + ${#_tracking} ))
      fi
    fi
  fi

  local left=$pre_prompt$venv_prompt$dir1_prompt$git_prompt$dir2_prompt
  local right=$host_prompt
  local left_width=$(( 2 + $venv_width + $dir_width + $git_width))
  local right_width=$host_width

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
