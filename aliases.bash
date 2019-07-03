unalias -a
alias df='df -h'
alias free='free -h'
alias path='echo -e ${PATH//:/\\n}'
alias more='less -R'
alias ls='ls --color=auto'
alias lx='ls -AlXB'  #  Sort by extension.
alias lxr='ls -ARlXB'  #  Sort by extension.
alias lk='ls -AlSr'  #  Sort by size, biggest last.
alias lkr='ls -ARlSr'  #  Sort by size, biggest last.
alias lt='ls -Altr'  #  Sort by date, most recent last.
alias ltr='ls -ARltr'  #  Sort by date, most recent last.
alias lc='ls -Altcr' #  Sort by change time, most recent last.
alias lcr='ls -ARltcr' #  Sort by change time, most recent last.
alias lu='ls -Altur' #  Sort by access time, most recent last.
alias lur='ls -ARltur' #  Sort by access time, most recent last.
alias ll='ls -Alhv'
alias llr='ls -ARlhv'
alias lr='ll -AR'    #  Recursive ls.
alias lm='ls |more'  #  Pipe through 'more'
alias lmr='lr |more'  #  Pipe through 'more'
alias whip="curl ipinfo.io"
alias weather="curl wttr.in"
alias repos='cd "$HOME/repos"'
alias lasttouched="ls -1 -dtr * | tail -1"
alias lastimage="ls -1 -dtr *.{img,iso} 2>/dev/null | tail -1"
alias lastdown="ls -1 -dtr $HOME/Downloads/* | tail -1"
alias lastpic="ls -1 -dtr $HOME/Pictures/* | tail -1"
alias errors="sudo journalctl -p 3 -xb"
alias sysderrors="sudo systemctl --failed"
alias grep='grep -i --colour=auto'
alias egrep='egrep -i --colour=auto'
alias fgrep='fgrep -i --colour=auto'
alias isgit='git rev-parse >/dev/null 2>&1'
alias dict="$EDITOR ~/.vim/spell/en.utf-8.add"
alias view=xviewer
alias glping="ssh git@gitlab.com"
alias ghping="ssh git@github.com"
alias bat='upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|to\ full|percentage"'
alias vimpluginstall="vim +':PlugInstall' +':q!' +':q!'"
alias open="gnome-open"
alias lynx="lynx -cfg=$HOME/repos/config/lynx/lynx.cfg -lss=$HOME/repos/config/lynx/lynx.lss"
