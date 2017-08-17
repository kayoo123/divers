#!/bin/sh

#===============================================================================
# CREATION
# Date de creation      : 17/08/2017
# Auteur                : jdesesquelles
# Version               : V1.0
#===============================================================================
#
# Script Synchro home => USB backup
#
#===============================================================================


# ------------------------------------------------------------------------------
# VARIABLES: globales
# ------------------------------------------------------------------------------
DATE=$(date +"%Y%m%d-%H%M")
DIR_MOUNT="/mnt/filer"
DIR_BACKUP="$DIR_MOUNT/backup"
LOG_FILE="/var/log/synchroUSB-${DATE}.log"

# ------------------------------------------------------------------------------
# FONCTION: Message et log
# ------------------------------------------------------------------------------
displayMessage() {
  echo "$*"
}

displayError() {
  echo -e "\r\e[0;31m* $* *\e[0m"
  exit 1
}

displayTitle() {
  displayMessage "------------------------------------------------------------------------------"
  displayMessage "$*"
  displayMessage "------------------------------------------------------------------------------"
}

# Parametres: MESSAGE COMMAND
displayAndExec() {
  local message=$1
  echo -n " [ Veuillez patienter ] $message"
  shift
  echo -e "\n\n>>> $*" >> $LOG_FILE 2>&1
  sh -c "$*" >> $LOG_FILE 2>&1
  local ret=$?
  if [ $ret -ne 0 ]; then
        echo -e "\r\e[0;31m [  ERROR  ]\e[0m $message"
  else
        echo -e "\r\e[0;32m [   OK    ]\e[0m $message"
  fi
return $ret
}

# ------------------------------------------------------------------------------
# FONCTION: Globales
# ------------------------------------------------------------------------------
function testMount {
## a remplacer par une connection mount
#####  /bin/ls $DIR_MOUNT > /dev/null
  /bin/mount |grep $DIR_MOUNT > /dev/null
  if [ ! $? -eq 0 ]; then
    displayError "Impossible de monter le repertoire distant."
    exit 1
  fi
}
function checkProcRsync {
  if /usr/bin/pgrep rsync 2>&1 > /dev/null; then
    displayError "Un processus rsync est deja en cours."
    exit 1
  fi
}
function synchro() {
  SOURCE="$1/"
  DESTINATION="$2"
  #LIST_FILE=$(/usr/bin/rsync -r --dry-run --ignore-existing --stats --human-readable ${SOURCE} ${DESTINATION} | grep -E 'Number of files transferred: ([0-9]+)' | grep -o -E '[0-9]+'); let FCNT+=5
  #/usr/bin/rsync -r --dry-run --ignore-existing --stats --human-readable ${SOURCE} ${DESTINATION} |pv -pteabl -s ${LIST_FILE} >/dev/null
  /usr/bin/rsync -avP --human-readable ${SOURCE} ${DESTINATION} 
}

# ------------------------------------------------------------------------------
# MAIN
# ------------------------------------------------------------------------------
#clear
echo
displayTitle "Script synchro de sa HOME"

testMount
checkProcRsync

# Repertoire de backup
[ -d $DIR_BACKUP ]|| mkdir -p $DIR_BACKUP
echo -e "\n\t [DEBUT] -- $(date)" > $LOG_FILE

## repertoire et fichier a rsync
displayAndExec "Synchro du repertoire Documents" "rsync -aP ${HOME}/Documents/ ${DIR_BACKUP}/Documents"
displayAndExec "Synchro du repertoire Images" "rsync -aP ${HOME}/Pictures/ ${DIR_BACKUP}/Pictures"
displayAndExec "Synchro du repertoire Musiques" "rsync -aP ${HOME}/Music/ ${DIR_BACKUP}/Music"
displayAndExec "Synchro du repertoire Videos" "rsync -aP ${HOME}/Videos/ ${DIR_BACKUP}/Videos"

echo -e "\n\t [ FIN ] -- $(date)" >> $LOG_FILE

## retention LOG
find /var/log -name "synchroUSB*.log" -mtime +5 -exec rm -f {} \;
echo
exit 0
