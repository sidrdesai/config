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
local prompt_venv_fg="magenta"

local prompt_head_start="."
local prompt_line="-"
local prompt_branch="|"
local prompt_arrow_start="\`"
local prompt_arrow_user=">"
local prompt_arrow_root="%F{white}%K{$prompt_root_red}#%k%f"
local prompt_dots="..."

prompt_enable_utf8() {
  prompt_head_start="┌"
  prompt_line="─"
  prompt_branch="├"
  prompt_arrow_start="└"
  prompt_arrow_user="›"
  prompt_dots="…"
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
    [ $VIRTUAL_ENV ] && echo `basename $VIRTUAL_ENV`
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
  if [ $VIRTUAL_ENV ]; then
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
  host_prompt=$host_prompt"%F{$prompt_line_fg}${prompt_line}%f"

  # First calculate widths
  local venv_width=0
  if [ $VIRTUAL_ENV ]; then
      venv_width=$(( 2 + $(prompt_subst_width $(venv_info)) ))
  fi
  local dir_width=$(( 2 + $(prompt_subst_width "%~") ))
  local host_width=$(( 4 + $(prompt_subst_width "%n%m") ))

  # git disabled for now
  local git_prompt=""
  local git_width=0

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


setopt PROMPT_SUBST PROMPT_CR PROMPT_SP PROMPT_PERCENT
PS1=$'$(prompt_ps1_line1)\n$(prompt_ps1_line2)'
RPS1="%(?..%B%F{red}<%?>%f%b)"
PS2=$'$(prompt_ps2)'
PS3=$'$(prompt_ps3)'
zle_highlight[(r)default:*]="default:bold"

if [[ ${LC_ALL:-${LC_CTYPE:-$LANG}} = *UTF-8* ]]; then
  prompt_enable_utf8
fi
