#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR="kak"
export REACT_EDITOR="webstorm"
GPG_TTY=$(tty)
export GPG_TTY

parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# SSH agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
#

# Colors!
PS1="\W$(parse_git_branch) \$ "
#alias ls="ls --color=auto"
#alias ls="exa"
# alias ls="ls --colour=auto"
alias grep="grep --colour=auto"
alias egrep="egrep --colour=auto"
alias fgrep="fgrep --colour=auto"
alias watch="watch --color"

# Aliases
alias cp="cp -i"                          # confirm before overwriting something
alias df="df -h"                          # human-readable sizes
alias free="free -m"                      # show sizes in MB
alias np="nano -w PKGBUILD"
alias more=less
alias ll="ls -lah"
#alias git="hub"
alias gif="sxiv -a"
alias detatch="pkill -9 -f 'docker.*attach'"
alias nethack="ssh nethack"
alias crawl="ssh crawl"
alias diff="diff --color"
alias gg="lazygit"
alias oath="ykman oath code \$(ykman oath list | fzf) -s | xclip -se c"
alias skey="eval \`ssh-agent -s\` && ssh-add"
#alias skey="ssh-add ~/.ssh/id_rsa"
alias srm="shred -v -n 1 -z -u"
alias grep="rg"
alias xc="xclip -se c"
alias q="exit"
alias mkcam="sudo modprobe -r v4l2loopback && sudo modprobe v4l2loopback devices=2 exclusive_caps=1,1 && ls /dev/video*"
alias vcam="function _v() { ffmpeg -i http://$1:8080/video -vf format=yuv420p -f v4l2 /dev/video0; }; _v"
alias dcam="ffmpeg -f x11grab -framerate 30 -video_size 1920x1080 -i :0.0+0,360 -f v4l2 -vcodec rawvideo -pix_fmt rgb24 /dev/video1"
alias passinit="pass grep ¬"
alias xm="xlayoutdisplay && ~/.fehbg"
alias work="feh --bg-scale ~/media/wallpapers/firewatch-wallpaper.jpg"
alias home="feh --bg-scale ~/media/wallpapers/tiger-jungle-wallpaper.jpg"
alias yt="youtube-dl --write-sub --embed-subs"
alias json="xclip -o -se c | jq . | xclip -se c"
alias tf="terraform"
alias ws="unset XDG_DATA_DIRS && ionice webstorm . &> /dev/null &"
alias wsx="unset XDG_DATA_DIRS && ionice webstorm ."
alias tab="xinput map-to-output 'Tablet Monitor Pen Pen (0)' HDMI-0"
alias aa="~/Android/Sdk/emulator/emulator -avd Pixel_3a_API_30_x86"
alias stress="s-tui"
alias kak="unset LD_LIBRARY_PATH && tmux new 'kak'"
alias hx="helix"
alias pnpx="pnpm exec"
alias yay="paru"
alias ew="cd ~/dev/gridshare-edge/ && unset LD_LIBRARY_PATH"
alias ele="cd ~/dev/lunar-edge/"
alias el="cd ~/dev/labs/"


adbc () {
    HOST=$1
    if [ ! -n "$HOST" ]; then
        echo "Please provide the host IP address, e.g: adbc 1.1.1.1"
        return 1
    fi
    
    PORT=$(nmap $HOST -p 37000-44000 | awk "/\/tcp open/" | cut -d/ -f1)
    if [ -n "$PORT" ]; then
        echo "Connecting to $HOST:$PORT..."
        adb connect $HOST:$PORT
    else
        echo "Unable to find port for $HOST"
        return 1
    fi
}

# passwordstore
p () {
    gpg --card-status > /dev/null # Bug with gnpg 2.2.24
    clipctl disable
    $(which pass) "$@"
    clipctl enable
}

j() {
    CURRENT_DIR=$(git rev-parse --show-toplevel)
    DIR=$(fd . --type directory "$CURRENT_DIR" | fzf)
    if [ -n "$DIR" ]; then
        cd "$DIR"
    fi
}

shopt -s expand_aliases
shopt -s histappend

export HISTSIZE=100000
export HISTCONTROL=ignorespace

# Takle stuff
FZF_THEME="--color='bg+:-1,fg+:-1,fg:#AEACAA,fg+:#FFFBF6'"

export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --extended ${FZF_THEME}"
export FZF_DEFAULT_COMMAND="fd --type file --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="fd --type directory --hidden"

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# Local
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

eval "$(direnv hook bash)"

if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source $HOME/.asdf/asdf.sh
    source $HOME/.asdf/completions/asdf.bash
fi

if [ -f "/usr/share/nvm/init-nvm.sh" ]; then
    source /usr/share/nvm/init-nvm.sh
fi

export STARSHIP_CONFIG=~/.config/starship/bash.toml
eval "$(starship init bash)"

