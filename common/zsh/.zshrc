# ============================
#   InkSec ZSH (shared)
# ============================

# Oh My Zsh base
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  eza
  zsh-autosuggestions
  grc
  sudo
  colorize
  zsh-syntax-highlighting
  tmux
  history-substring-search
)

ZSH_COLORIZE_STYLE="colorful"

# Load Oh My Zsh
if [ -d "$ZSH" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# ----------------------------
# History (big, shared)
# ----------------------------
HISTDIR="$HOME/.config/zsh"
mkdir -p "$HISTDIR"

HISTFILE="$HISTDIR/history"
HISTSIZE=500000
SAVEHIST=500000

setopt APPEND_HISTORY          # append, don't overwrite
setopt SHARE_HISTORY           # merge across sessions
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_IGNORE_SPACE       # commands starting with space not saved

# Optional: avoid saving obvious secrets / flags
#zshaddhistory() {
#  local line="$1"
#  case "$line" in
#    *password*|*PASSWORD*|*token*|*TOKEN*|*HTB{*|*FLAG{* )
#      return 1 ;;
#  esac
#  return 0
#}

# ----------------------------
# InkSec prompt (pink + cyan)
# ----------------------------
# Example: INKSEC ~/path >
PROMPT='%F{magenta}INKSEC%f %F{cyan}%~%f %# '

# ----------------------------
# PATH tuning
# ----------------------------
export PATH="$HOME/tools/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin/:$PATH"
export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"

# ----------------------------
# Aliases (cheatsheets + quality of life)
# ----------------------------
alias nmap="grc nmap"
alias ls="eza -a --color=always --group-directories-first --icons"
alias la="eza -la --color=always --group-directories-first --icons"

alias revshells="cat ~/tools/revshells"
alias breakout="cat ~/tools/breakout"
alias nmapref="cat ~/tools/nmapref"

# ----------------------------
# Fastfetch banner (interactive shells only)
# ----------------------------
if [[ $- == *i* ]]; then
  if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
  fi
fi

# ----------------------------
# History substring search keybinds
# (type 'netexec', then ↑ / ↓ to cycle matching history)
# ----------------------------
if (( $+functions[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^P'   history-substring-search-up
  bindkey '^N'   history-substring-search-down
fi

# ----------------------------
# Completion extras (AWS, etc.)
# ----------------------------
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

if [ -x "/usr/local/bin/aws_completer" ]; then
  complete -C "/usr/local/bin/aws_completer" aws
fi
# ============================
# InkSec – Enhanced TAB logic (safe hybrid)
# ============================

# Prefer directories first in TAB completion
zstyle ':completion:*' list-dirs-first yes

# Case-insensitive completion (Ping = ping)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Make TAB use normal completion first, fallback to history when needed
bindkey '^I' expand-or-complete

# (arrow keys for substring search already configured above)
# ============================
# InkSec – FZF integration
# ============================

# Prefer fd/fdfind as the file walker for FZF
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v fdfind >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Try to source system fzf keybindings/completions
for fzf_bind in \
  /usr/share/fzf/key-bindings.zsh \
  /usr/share/fzf/shell/key-bindings.zsh \
  /usr/share/doc/fzf/examples/key-bindings.zsh
do
  [ -r "$fzf_bind" ] && source "$fzf_bind" && break
done

for fzf_comp in \
  /usr/share/fzf/completion.zsh \
  /usr/share/fzf/shell/completion.zsh \
  /usr/share/doc/fzf/examples/completion.zsh
do
  [ -r "$fzf_comp" ] && source "$fzf_comp" && break
done
# FZF history search on Alt+I
if typeset -f fzf-history-widget >/dev/null 2>&1; then
  bindkey -M emacs '\ei' fzf-history-widget
fi

# ============================
# InkSec Prompt
# ============================

# Colors (Zsh format)
ink_pink="%F{206}"     # #ff66c4 neon pink
ink_cyan="%F{51}"      # #33ffcc mint cyan
ink_white="%F{255}"
ink_reset="%f"

# Get OS name for prompt
os_name="$([[ -f /etc/os-release ]] && grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '\"')"

# Two-line prompt:
# 🩷 inksec @ kali : ~
# ❯
PROMPT='${ink_pink}inksec${ink_reset} ${ink_cyan}@ ${os_name}${ink_reset} ${ink_white}: %~${ink_reset}
❯ '
