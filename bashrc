# Exa
alias ll='exa -l --git'

##fortune+cowsay
fortune -u fr -s |cowsay -f /usr/share/cowsay/cows/koala.cow

alias pic_et_pic_et_colegram="echo Dimitri Jeremi JC Geoffrey |xargs shuf -n 1 -e"
alias ou_manger="echo \"import random; foo = ['Tandoori Masala', 'Le BUS', 'Sandwich Franprix', 'JAP speedy' , 'JAP Milf' , 'Terrase du Bellevue' , 'Chicken Broadway' , 'Bal Perdu' , 'Courtois']; print(random.choice(foo))\" |python"

alias meteo="curl wttr.in/bagnolet"

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

