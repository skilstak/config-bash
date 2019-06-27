# these days we can almost always assume
# bash will have 256 color support (at
# least on any interactive systems)

export CLICOLOR=1
export LSCOLORS=gxfxbEaEBxxEhEaDaCaD

solnames=(y o r m v b c g)

sol () {
  case $1 in
    base03|b03) echo -ne '\033[1;30m' ;; # brblack
    base02|b02) echo -ne '\033[0;30m' ;; # black
    base01|b01) echo -ne '\033[1;32m' ;; # brgreen
    base00|b00) echo -ne '\033[1;33m' ;; # bryellow 
    base0|b0) echo -ne '\033[1;34m' ;;   # brblue
    base1|b1) echo -ne '\033[1;36m' ;;   # brcyan
    base2|b2) echo -ne '\033[0;37m' ;;   # white
    base3|b3) echo -ne '\033[1;37m' ;;   # brwhite
    yellow|y) echo -ne '\033[0;33m' ;;   # yellow
    orange|o) echo -ne '\033[1;31m' ;;   # brred
    red|r) echo -ne '\033[0;31m' ;;      # red
    magenta|m) echo -ne '\033[0;35m' ;;  # magenta
    violet|v) echo -ne '\033[1;35m' ;;   # brmagenta
    blue|b) echo -ne '\033[0;34m' ;;     # blue
    cyan|c) echo -ne '\033[0;36m' ;;     # cyan
    green|g) echo -ne '\033[0;32m' ;;    # green 
    rnd)  echo -ne $(sol ${solnames[$((RANDOM%8))]}) ;;
    reset|x) echo -ne '\033[0m' ;;
    clear|cl) echo -ne '\033[H\033[2J' ;;
    line|ln) echo -ne '\033[2K\r' ;;
  esac
}

sols () {
  for i in b03 b02 b01 b00 b0 b1 b2 b3 y o r m v b c g rnd; do
    echo -ne $(sol $i)$i" "
  done
  echo $(sol x)x cl ln 
}

export -f sol sols
