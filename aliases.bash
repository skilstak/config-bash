unalias -a

alias path='echo -e ${PATH//:/\\n}'

alias more='less -R'

alias ls='ls --color=auto'
alias lx='ls -AlXB'    #  Sort by extension.
alias lxr='ls -ARlXB'  #  Sort by extension.
alias lk='ls -AlSr'    #  Sort by size, biggest last.
alias lkr='ls -ARlSr'  #  Sort by size, biggest last.
alias lt='ls -Altr'    #  Sort by date, most recent last.
alias ltr='ls -ARltr'  #  Sort by date, most recent last.
alias lc='ls -Altcr'   #  Sort by change time, most recent last.
alias lcr='ls -ARltcr' #  Sort by change time, most recent last.
alias lu='ls -Altur'   #  Sort by access time, most recent last.
alias lur='ls -ARltur' #  Sort by access time, most recent last.
alias ll='ls -Alhv'
alias llr='ls -ARlhv'
alias lr='ll -AR'      #  Recursive ls.
alias lm='ls |more'    #  Pipe through 'more'
alias lmr='lr |more'   #  Pipe through 'more'

alias lasttouched="ls -1 -dtr * | tail -1"
alias lastimage="ls -1 -dtr *.{img,iso} 2>/dev/null | tail -1"
alias lastdown="ls --color=never -1 -dtr ~/Downloads/* | tail -1"
alias lastpic="ls --color=never -1 -dtr ~/Pictures/* | tail -1"

alias wip="curl ipinfo.io"
alias weather="curl wttr.in"

alias syserrors="sudo journalctl -p 3 -xb"
alias sysderrors="sudo systemctl --failed"
alias bat='upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|to\ full|percentage"'
alias df='df -h'
alias free='free -h'

alias grep='grep -i --colour=auto'
alias egrep='egrep -i --colour=auto'
alias fgrep='fgrep -i --colour=auto'

alias isgit='git rev-parse >/dev/null 2>&1'
alias glping="ssh git@gitlab.com"
alias ghping="ssh git@github.com"

alias view=xviewer
alias open="gnome-open"

alias vimpluginstall="vim +':PlugInstall' +':q!' +':q!'"

alias repos="cd ~/repos"
alias config="cd ~/repos/config"
alias private="cd ~/repos/private"
alias downloads="cd ~/Downloads"
alias desktop="cd ~/Desktop"
alias pictures="cd ~/Pictures"
alias videos="cd ~/Videos"

if [[ $(which lynx) ]]; then
  [[ -r ~/repos/config/lynx/lynx.cfg ]]  && lynxcfg="-cfg=$HOME/repos/config/lynx/lynx.cfg"
  [[ -r ~/repos/private/lynx/lynx.cfg ]]  && lynxcfg="-cfg=$HOME/repos/private/lynx/lynx.cfg"
  [[ -r ~/.lynx.cfg ]] && lynxcfg="-cfg=$HOME/.lynx.cfg"
  [[ -r ~/repos/config/lynx/lynx.lss ]]  && lynxlss="-lss=$HOME/repos/config/lynx/lynx.lss"
  [[ -r ~/repos/private/lynx/lynx.lss ]]  && lynxlss="-lss=$HOME/repos/private/lynx/lynx.lss"
  [[ -r ~/.lynx.lss ]] && lynxlss="-lss=$HOME/.lynx.lss"
  alias lynx="lynx '$lynxcfg' '$lynxlss'"
fi

alias skilstak="xdg-open https://skilstak.io &>/dev/null"
alias twitter="xdg-open https://twitter.com &>/dev/null"
alias medium="xdg-open https://medium.com &>/dev/null"
alias reddit="xdg-open https://reddit.com &>/dev/null"
alias xkcd="xdg-open https://xkcd.com &>/dev/null"

