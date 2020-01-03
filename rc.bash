 
[[ $- != *i* ]] && return


[ -z "$OS" ] && OS=`uname`
case "$OS" in
  *indows* )        PLATFORM=windows ;;
  Linux )           PLATFORM=linux ;;
  FreeBSD|Darwin )  PLATFORM=mac ;;
esac
export PLATFORM OS

export PATH=\
$HOME/bin:\
$HOME/go/bin:\
$HOME/.cargo/bin:\
/usr/local/go/bin:\
/usr/local/tinygo/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/sbin:\
/usr/bin:\
/snap/bin:\
/sbin:\
/bin

HISTCONTROL=ignoredups:ignorespace
export PROMPT_COMMAND="history -a; history -c; history -r"
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
set -o notify
#set -o noclobber
set -o ignoreeof
set bell-style none
#set +h # disable hashing
set -o vi

shopt -s checkwinsize
shopt -s histappend
shopt -s expand_aliases
shopt -s nullglob

[[ $PLATFORM != mac ]] && shopt -s globstar

for t in aliases functions colors private completion; do
  [[ -r ~/.bash_$t ]] && . ~/.bash_$t
done

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*) PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"' ;;
  screen*) PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"' ;;
esac

if [[ ${EUID} == 0 ]] ; then
  PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\#\[\033[00m\] '
else
  PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]'$EMOJI'\$\[\033[00m\] '
fi

[[ $(type vim) ]] && alias vi=vim
export EDITOR=vi
export VISUAL=vi

if [ $PLATFORM != 'mac' ]; then
	alias ls='ls -h --color'
else
  #export CLICOLOR_FORCE=1
  export CLICOLOR=1
  export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
fi

if [ -x /usr/bin/dircolors ]; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

if [ $PLATFORM == mac ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi

# colorize man pages and anything in less
export LESS_TERMCAP_mb=$(sol m)
export LESS_TERMCAP_md=$(sol y)
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$(sol b)
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$(sol v)

# too much wierd, unexplainable old stuff cached still
export GOPROXY=direct

# Node Version Manager
export NVM_DIR="$HOME/repos/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
