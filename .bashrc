#
# ~/.bashrc
#

export EDITOR="kak"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
PS1='\W$(parse_git_branch) \$ '
#alias ls='ls --color=auto'
#alias ls="exa"
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias watch='watch --color'

# Aliases
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
#alias sudo="doas"

# passwordstore
p () {
    gpg --card-status > /dev/null # Bug with gnpg 2.2.24
    clipctl disable
    $(which pass) "$@"
    clipctl enable
}

je() {
  cd ~/dev/gridshare-edge
  cd $(fd . --type directory | fzf)
}

shopt -s expand_aliases
shopt -s histappend

export HISTSIZE=10000
export HISTCONTROL=ignorespace

# Local
export PATH="$HOME/.local/bin:$PATH"

eval "$(direnv hook bash)"

if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source $HOME/.asdf/asdf.sh
    source $HOME/.asdf/completions/asdf.bash
fi

if [ -f "/usr/share/nvm/init-nvm.sh" ]; then
    source /usr/share/nvm/init-nvm.sh
fi

eval "$(starship init bash)"
