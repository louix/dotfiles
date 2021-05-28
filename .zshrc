# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}


# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it does not exist or it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

# bindkey '^P' history-substring-search-up
# bindkey '^N' history-substring-search-down
# bindkey -M vicmd 'k' history-substring-search-up
# bindkey -M vicmd 'j' history-substring-search-down
# }}} End configuration added by Zim install

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

export EDITOR="kak"

# Lines configured by zsh-newuser-install
HISTFILE=~/.bash_history
HISTSIZE=100000
SAVEHIST=100000
# bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall

# Pacman Hooks: https://wiki.archlinux.org/index.php/Zsh#On-demand_rehash
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd
# end Pacman Hooks

# SSH agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
# end SSH Agent

# Aliases
## Colors!
#alias ls='ls --color=auto'
alias ls="exa"
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias watch='watch --color'

## General
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias ll='ls -lah'
#alias git='hub'
alias gif='sxiv -a'
alias detatch="pkill -9 -f 'docker.*attach'"
alias nethack="ssh nethack"
alias crawl="ssh crawl"
alias diff="diff --color"
alias gg="lazygit"
alias oath="ykman oath code \$(ykman oath list | fzf) -s | xclip -se c"
alias skey="eval \`ssh-agent -s\` && ssh-add ~/.ssh/id_rsa"
#alias skey="ssh-add ~/.ssh/id_rsa"
alias srm="shred -v -n 1 -z -u"
alias grep="rg"
alias xc="xclip -se c"
alias q="exit"
alias mkcam="sudo modprobe -r v4l2loopback && sudo modprobe v4l2loopback devices=2 exclusive_caps=1,1 && ls /dev/video*"
alias vcam='function _v() { ffmpeg -i http://$1:8080/video -vf format=yuv420p -f v4l2 /dev/video0; }; _v'
alias dcam='ffmpeg -f x11grab -framerate 30 -video_size 1920x1080 -i :0.0+0,360 -f v4l2 -vcodec rawvideo -pix_fmt rgb24 /dev/video1'
alias passinit='pass grep ¬'
alias xm='xlayoutdisplay && ~/.fehbg'
alias work='feh --bg-scale ~/media/wallpapers/firewatch-wallpaper.jpg'
alias home='feh --bg-scale ~/media/wallpapers/tiger-jungle-wallpaper.jpg'
alias yt='youtube-dl --write-sub --embed-subs'
alias passc='pass -c $@'
alias j='xclip -o -se c | jq . | xclip -se c'
alias tf='terraform'
alias ws='webstorm-eap . &> /dev/null &'
alias tab='xinput map-to-output "Tablet Monitor Pen Pen (0)" HDMI-0'
alias aa='~/Android/Sdk/emulator/emulator -avd Pixel_3a_API_30_x86'
alias vnc='x0vncserver -display :0 -passwordfile ~/.vnc/passwd'
alias stress='s-tui'
alias sudo="doas"
alias logout="qdbus org.kde.ksmserver /KSMServer logout -1 -1 -1"
alias e="emacs -nw"
alias audiorouter="pw-jack catia"
# end Aliases
 
# passwordstore
p () {
    gpg --card-status > /dev/null # Bug with gnpg 2.2.24
    clipctl disable
    $(which pass) "$@"
    clipctl enable
}

eval "$(direnv hook zsh)"

#prompt walters
export PATH="$HOME/.local/share/gem/ruby/2.7.0/bin:$PATH"
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
# Multi-core make
export MAKEFLAGS="-j$(nproc)"

# zim prompt
# export PWD_COLOR="white"

if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source $HOME/.asdf/asdf.sh
    # append completions to fpath
    fpath=(${ASDF_DIR}/completions $fpath)
    # initialise completions with ZSH's compinit
    autoload -Uz compinit
    compinit
fi

if [ -f "/usr/share/nvm/init-nvm.sh" ]; then
    source /usr/share/nvm/init-nvm.sh
fi
