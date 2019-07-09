
eject () {
  local path=/media/$USER
  local first=$(ls -1 $path | head -1)
  local mpoint=$path/$first
  [[ -z "$first" ]] && echo Nothing to eject. && return
  umount $mpoint && echo $first ejected || echo Could not eject.
}

usb () {
  local path=/media/$USER
  local first=$(ls -1 $path | head -1)
  echo $path/$first
}

cdusb () {
  cd $(usb)
}

mvlast () {
  if [ -d ./assets ]; then
    mv "$(lastdown)" ./assets/$1
  else
    mv "$(lastdown)" ./$1
  fi
}

mvlastpic () {
  if [ -d ./assets ]; then
    mv "`lastpic`" ./assets/$1
  else
    mv "`lastpic`" ./$1
  fi
}

howin() {
  where="$1"; shift
  IFS=+ curl "http://cht.sh/$where/ $*"
}

grepall () {
  find . -name "*.git*" -prune -o -exec grep -i --color "$1" {} /dev/null 2>/dev/null \;
}

vic () {
  vi `which $1`
}

tstamp () {
  echo $1 $(date +%Y%m%d%H%M%S)
}

now () {
  echo $1 $(date "+%A, %B %e, %Y - %l:%M:%S%p")
}

# didn't want to stoop to eval

hnow () {
  echo $(printf '#%.0s' {1..1}) $(now)
}
h2now () {
  echo $(printf '#%.0s' {1..2}) $(now)
}
h3now () {
  echo $(printf '#%.0s' {1..3}) $(now)
}
h4now () {
  echo $(printf '#%.0s' {1..4}) $(now)
}
h5now () {
  echo $(printf '#%.0s' {1..5}) $(now)
}
h6now () {
  echo $(printf '#%.0s' {1..6}) $(now)
}

80cols () {
  echo $(printf '#%.0s' {1..80})
}

ex () {
  local file=$1
  [[ -z "$file" ]] && echo "usage: ex COMPRESSEDFILE" && return 1
  [[ ! -f "$file" ]] && echo "'$file' is not a valid file" && return 1
  case $file in
    *.tar.bz2)   tar xjf $file;;
    *.tar.gz)    tar xzf $file;;
    *.bz2)       bunzip2 $file;;
    *.rar)       unrar x $file;;
    *.gz)        gunzip $file;;
    *.tar)       tar xf $file;;
    *.tbz2)      tar xjf $file;;
    *.tgz)       tar xzf $file;;
    *.zip)       unzip $file;;
    *.Z)         uncompress $file;;
    *.7z)        7z x $file;;
    *.xz)        unxz $file;;
    *)           echo "'$file' unknown compression suffix"; return 1 ;;
  esac
}

isyes () {
  read -p "$* [y/N]: " yn
  [[ ${yn,,} =~ y(es)? ]] && return 0
  return 1
}

urlencode () {
  local str="$*"
  local encoded=""
  local i c x
  for (( i=0; i<${#str}; i++ )); do
    c=${str:$i:1}
    case "$c" in
      [-_.~a-zA-Z0-9] ) x="$c" ;;
      * ) printf -v x '%%%02x' "'$c" ;;
    esac
    encoded+="$x"
  done
  echo "$encoded"
}

duck () {
  local url=$(urlencode "$*")
  lynx "https://duckduckgo.com/lite?q=$url"
}
alias "?"=duck

google () {
  local url=$(urlencode "$*")
  lynx "https://google.com/search?q=$url"
}
alias "??"=google

zeroblk () {
  [[ -z "$1" ]] && echo usage: zerobkd BLKDEV && return 1
  [[ ! -b "/dev/$1" ]] && echo not a block device && return 1
  isyes "$(sol r)Are you absolutely sure you want to completly erase /dev/$1?$(sol x)" || return 1
  sudo dd if=/dev/zero of=/dev/$1 bs=4M status=progress
  sync
}

imgdev () {
  local file=$1
  [[ -z "$file" ]] && echo "usage: imgdev IMGFILE" && return 1
  [[ ! -f "$file" ]] && echo "file not found: $file"  && return 1

  echo -n "Extracting ... "
  ex "$file"
  [[ $? -eq 0 ]] && file=$(lastimage)
  [[ -z "$file" ]] && echo "Humm, not an image." && return 1
  echo -n "$file ..."
  echo done.

  lsblk
  echo -n "$(sol y)Which device should I destroy and write the image to?$(sol x) "
  local blkdev
  read blkdev
  [[ ! -b "/dev/$blkdev" ]] && echo not a block device && return 1

  echo -n Unmounting ...
  for i in /dev/$blkdev*; do umount $i 2>/dev/null; done
  echo done.

  #isyes "$(sol r)Are you absolutely sure you want to completly erase /dev/$blkdev?$(sol x)" || return 1
  #echo -n Zeroing out $blkdev ... 
  #sudo dd if=/dev/zero of=/dev/$blkdev bs=4M status=progress
  #sync
  #echo done.

  echo -n Writing $file to $blkdev ...
  sudo dd if="$PWD/$file" of=/dev/$blkdev bs=4M status=progress
  sync
  echo done.
}

getncheck () {
  local url=$1
  local goodsha=$2
  local usage="usage: getncheck URL SHA"
  [[ -z "$url" || -z "$goodsha" ]] && echo $usage && return 1
  local file=${url##*/}
  wget -O $file "$url"

  echo -n Validating $file ...
  local sha=$(sha256sum -b $file); sha=${sha/ *}
  if [[ $sha != $goodsha ]]; then
    echo $(sol r)Woah! Looks like a corrupt or hacked download.$(sol x)
    echo $(sol r)Removing $file to be safe.$(sol x)
    rm -f $file
    return 1
  fi
  echo done.

  isyes $(sol y)Wanna image something with it?$(sol x) && imgdev $file
}

pubkey () {
  local name=id_rsa
  [[ -n "$1" ]] && name="$1"
  cat $HOME/.ssh/$name.pub
}

ssh-hosts () {
  local file="$HOME/.ssh/config"
  [[ -f $file ]] || return 1
  while read -r line; do
    [[ "$line" =~ ^Host\ *([^\ ]*) ]] || continue
    echo ${BASH_REMATCH[1]}
  done < "$file"
}

_ssh() {
  COMPREPLY=($(compgen -W "$(ssh-hosts)" -- ${COMP_WORDS[COMP_CWORD]}))
} && complete -F _ssh ssh

lsrepo () {
  local repohome=$HOME/repos
  [[ -n "$1" ]] && repohome=$1
  local repos=($(ls -d $repohome/**/.git))
  for i in ${repos[@]}; do
    i=${i%\/.git}
    i=${i#$repohome\/}
    echo $i
  done
}

repo () {
  local r=$1
  [[ -z "$r" ]] && echo usage: repo REPO && return 1
  cd $HOME/repos/$r
} &&
_repo() {
  COMPREPLY=($(compgen -W "$(lsrepo)" -- ${COMP_WORDS[COMP_CWORD]}))
} && complete -F _repo repo && alias r=repo && complete -F _repo r

testemail () {
  local addr="$1"
  [[ -z "$addr" ]] && addr="$EMAIL"
  [[ -z "$addr" ]] && echo "usage: testemail" EMAIL && return 1
  local subj="$*"
  subj=${subj#$addr}
  [[ -z "$subj" ]] && subj="Testing Email $(tstamp)"
  echo $(sol y)Sending mail to $(sol c)$addr$(sol y) to test.$(sol x)
  echo "$subj" | mutt -s "$subj" $addr
}

monitor-once () {
  local cmpfile=/tmp/monitor$$
  local action="ls '{}'"
  [[ -n "$1" ]] && action="$*"
  [[ ! -f "$cmpfile" ]] && touch "$cmpfile"
    find . -type f -newer "$cmpfile" -exec bash -c "$action" \;
    touch "$cmpfile"
}

rep () {
  local str="$1"
  local cnt="$2"
  local i
  for ((i=0; i<$2; i++)); do echo -n "$str"; done
}

monitor () {
  shift;
  while true; do 
    monitor-once "$*"
    sleep 2
  done
}

watch () {
  while true; do 
    clear
    $*
    sleep 2
  done
}

funcsin () {
  egrep '^[-_[:alpha:]]* ?\(' $1 | while read line; do
    echo ${line%%[ (]*}
  done
}

is-valid-username () {
  [[ "$1" =~ ^[a-z_][a-z0-9_]{0,31}$ ]] && echo yes && return 0
  echo no && return 1
}

change-user-name () {
  local old="$1"
  local new="$2"
  [[ -z "$old" || -z "$new" ]] && echo "usage: change-user-name OLD NEW" && return 1
  [[ $(is-valid-username "$old") = no ]] && echo "Invalid username: $old" && return 1
  [[ $(is-valid-username "$new") = no ]] && echo "Invalid username: $new" && return 1
  groupadd $new
  usermod -d /home/$new -m -g $new -l $new $old
}

preview () {
  browser-sync start \
    --no-notify --no-ui \
    --ignore '**/.*' \
    -sw
}

save () { 
    local y;
    local repo;
    local user=$(git config user.name);
    [[ -z "$user" ]] && echo "Git doesn't look configured yet." && return 1;
    git rev-parse > /dev/null 2>&1;
    if [[ ! $? = "0" ]]; then
        read -p "$(sol y)Not a git repo. Create? $(sol b3)" y;
        if [[ $y =~ ^[yY] ]]; then
            touch README.md;
            read -p "$(sol y)GitLab path: $(sol b3)" repo;
            echo -n $(sol c);
            git init;
            git remote add origin "git@gitlab.com:$repo.git";
            git add -A .;
            git commit -a -m initial;
            git push -u origin master;
            echo -n $(sol x);
        fi;
        return 0;
    fi;
    if [[ -z "$(git status -s)" && $(git rev-list --count origin/master..master) = 0 ]]; then
        echo Already at the latest.;
        return 0;
    fi;
    local comment=save;
    [ ! -z "$*" ] && comment="$*";
    git pull;
    git add -A .;
    git commit -a -m "$comment";
    git push
}

#caniuse () {
#  xdg-open "https://caniuse.com/#search=$(urlencode $1)" &>/dev/null
#}

gocd () {
  cd `go list -f '{{.Dir}}' ...$1`
}

export -f eject usb cdusb mvlast mvlastpic howin grepall vic tstamp now hnow h2now h3now h4now h5now h6now 80cols ex isyes urlencode duck google zeroblk imgdev getncheck pubkey ssh-hosts lsrepo lsrepo testemail monitor funcsin change-user-name is-valid-username preview save gocd

