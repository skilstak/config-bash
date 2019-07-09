 
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
set -o noclobber
set -o ignoreeof
set bell-style none
set +h # disable hashing
set -o vi
shopt -s checkwinsize
shopt -s histappend
shopt -s expand_aliases
shopt -s globstar

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

for t in aliases functions colors private completion; do
  [[ -f ~/.bash_$t ]] && . ~/.bash_$t
done

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
[[ -r ~/.bash_completion ]] && . ~/.bash_completion

case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*) PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"' ;;
  screen*) PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"' ;;
esac

if [[ ${EUID} == 0 ]] ; then
  PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
else
  PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
fi

# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ' 

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

if [ $PLATFORM == mac ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi
