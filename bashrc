# Exa
alias ll='exa -l --git'

##fortune+cowsay
fortune -u fr -s |cowsay -f /usr/share/cowsay/cows/koala.cow

alias pic_et_pic_et_colegram="echo Dimitri Jeremi JC Geoffrey |xargs shuf -n 1 -e"
alias ou_manger="echo \"import random; foo = ['Tandoori Masala', 'Le BUS', 'Sandwich Franprix', 'JAP speedy' , 'JAP Milf' , 'Terrase du Bellevue' , 'Chicken Broadway' , 'Bal Perdu' , 'Courtois']; print(random.choice(foo))\" |python"

alias meteo="curl wttr.in/bagnolet"

############"
check_svn() {
  svn info &>/dev/null
  if [ $? == 0 ]; then
    upfile=$(svn status |wc -l)
    branch=$(svn info | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' | egrep -o '[^/]+$')
    echo " (svn:${branch}:${upfile})"
  fi
}
check_git() {
  git branch &>/dev/null
  if [ $? == 0 ]; then
    upfile=$(git status -s |wc -l)
    branch=$(git branch |grep '*' |awk '{ print $NF }')
    echo " (git:${branch}:${upfile})"
  fi
}

function PS1_super {
        export PROMPT_DIRTRIM=3
        #  ▶  -- Retour chario non-fonctionnel
        export PROMPT_COMMAND='PS1="${debian_chroot:+($debian_chroot)}\$(if [ \$? == 0 ]; then echo \\[\\033[32m\\]; else echo \\[\\033[31m\\]; fi)\t\[\033[00m\]: \[\033[01;34m\]\w\[\033[33m\]\$(check_svn)\$(check_git)\[\033[00m\] >>> "'
}
PS1_super
###############

######################
## source : https://github.com/dracula/terminal-app/issues/2

# Colors - https://github.com/dracula/dracula-theme#color-palette
black="\[$(tput setaf 0)\]"
red="\[$(tput setaf 1)\]"
green="\[$(tput setaf 2)\]"
yellow="\[$(tput setaf 3)\]"
blue="\[$(tput setaf 4)\]"
magenta="\[$(tput setaf 5)\]"
cyan="\[$(tput setaf 6)\]"
white="\[$(tput setaf 7)\]"
clear_color="\[$(tput sgr0)\]"

# Last result color
result_color="\$(if [ \$? == 0 ]; then echo ${green} ; else echo ${red}; fi)"

# Git branch
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)\ /';
#  git branch &>/dev/null
#  if [ $? == 0 ]; then
#    upfile=$(git status -s |wc -l)
#    branch=$(git branch |grep '*' |awk '{ print $NF }')
#    if [ "$upfile" -eq 0 ]; then
#      echo "(${branch}) ${green}✔ "
#    else
#      echo "(${branch}) ${yellow}✗ "
#    fi
#  fi
}

# Max directory 
export PROMPT_DIRTRIM=3

# Custom bash prompt - "➜  ~ (master) ✔ ✗"
export PS1="${result_color}➜  ${magenta}\w ${cyan}\$(git_branch)${clear_color}"

######################


