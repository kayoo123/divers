#===============================================================================
#
# Alias SVN
#
#===============================================================================
# a include dans son .bashrc


# ------------------------------------------------------------------------------
# FUNCTION: findsvn / findrepo
# ------------------------------------------------------------------------------
function findsvn() {
if test -z "$1"; then
  echo
  echo "Ce script recherche (find) les \"arguments\" dans l'arboresence du depot SVN local"
  echo "=> findsvn \$arg1 \$arg2 \$arg3 \$arg4 ..."
  echo
  echo "  ex: findsvn dev ecare fluxp"
  echo
else
  find $HOME/repositories \( ! -regex '.*/\..*' \) -type f -print \
  |grep -i "$1" \
  |grep -i "$2" \
  |grep -i "$3" \
  |grep -i "$4" \
  |grep -i "$5" \
  |grep -i "$6" \
  |grep -i "$7" \
  |grep -i "$8" \
  |grep -i "$9" \
  > /tmp/findsvn.out
  grep -iE --color "$1|$2|$3|$4|$5|$6|$7|$8|$9" /tmp/findsvn.out
fi
}
alias findrepo=findsvn


# ------------------------------------------------------------------------------
# FUNCTION: grepsvn / greprepo
# ------------------------------------------------------------------------------
function grepsvn() {
if test -z "$1"; then
  echo
  echo "Ce script recherche (grep) une \"occurence\" a l'interieur des fichiers du depot SVN local trie par \"arguments\""
  echo "=> grepsvn \$occurence \$arg2 \$arg3 \$arg4 ..."
  echo
  echo "  ex: grepsvn /home dev ecare"
  echo
else
  find $HOME/repositories \( ! -regex '.*/\..*' \) -type f -print \
  |grep -i "$2" \
  |grep -i "$3" \
  |grep -i "$4" \
  |grep -i "$5" \
  |grep -i "$6" \
  |grep -i "$7" \
  |grep -i "$8" \
  |grep -i "$9" \
  > /tmp/grepsvn.out
  for i in $(cat /tmp/grepsvn.out); do grep -il "$1" $i; done
fi
}
alias greprepo=grepsvn


# ------------------------------------------------------------------------------
# FUNCTION: svim
# ------------------------------------------------------------------------------
function svim() {
if test -z "$1"; then
  echo
  echo "Ce script update le repository avant l'edition du fichier de depot SVN"
  echo "Possibilite d'integrer directement le header"
  echo "=> svim \$directory/\$file"
  echo "=> svim \$header/\$directory/\$file"
  echo
  echo "  ex: svim apache2/sites-available/mfy-portal-frc_preview.conf"
  echo "  ex: svim file:///svnroot/slave/.../.../mfy-portal-frc_preview.conf"
  echo
else
  FILENAME=$(basename $1)
  DIRECTORY=$(dirname $1)
  if [[ "$DIRECTORY=" =~ "file:///svnroot" ]]; then
        DIR_REPO="$HOME/repositories/"
        DIR_PATH=$(echo "$DIRECTORY" |awk -F/ '{ print $6"/"$9"/"$10"/"$11"/"$12"/"$13"/"$14"/"$15"/"$16"/"$17"/"$18"/"$19"/"$20"/"$21"/"$22"/"$23"/"$24}')
        DIRECTORY="$DIR_REPO"/"$DIR_PATH"
  fi
  cd $DIRECTORY
  svn update
  vim $FILENAME
fi
}


# ------------------------------------------------------------------------------
# ALIAS: globales
# ------------------------------------------------------------------------------
alias repo='cd $HOME/repositories'
alias depo=repo

