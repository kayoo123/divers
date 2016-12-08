#!/bin/sh

#===============================================================================
# CREATION
# Date de creation      : 26/08/2016
# Auteur                : jdesesquelles
# Version               : V1.0
#===============================================================================
#
# Script Synchro home sur NAS
#
#===============================================================================


# ------------------------------------------------------------------------------
# VARIABLES: globales
# ------------------------------------------------------------------------------
DATE=`date +"%Y%m%d-%H%M"`
NAS_ADDR="192.168.0.49"
NAS_USER="nas-users"
NAS_CREDENTIALS=""
DIR_MOUNT="/mnt/FLAN"
LOG_FILE="/var/log/synchroNAS-${DATE}.log"


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
  echo -n " [En cours] $message"
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
function synchro () {
  SOURCE="$1/"
  DESTINATION="$2"
  LIST_FILE=$(/usr/bin/rsync -r --dry-run --ignore-existing --stats --human-readable -e ssh ${SOURCE} ${DESTINATION} | grep -E 'Number of files transferred: ([0-9]+)' | grep -o -E '[0-9]+'); let FCNT+=5
  /usr/bin/rsync -r --dry-run --ignore-existing --stats --human-readable -e ssh ${SOURCE} ${DESTINATION} |pv -pteabl -s ${LIST_FILE} >/dev/null
}

# ------------------------------------------------------------------------------
# MAIN
# ------------------------------------------------------------------------------
#clear
echo
displayTitle "Script synchro de sa HOME"

testMount
checkProcRsync

# tag DATE
[ -d $DIR_BACKUP ]|| mkdir -p $DIR_BACKUP
echo $DATE > $LOG_FILE

## repertoire et fichier a rsync
displayAndExec "Synchro du repertoire Documents" "synchro ${HOME}/Documents ${DIR_MOUNT}/Documents"
displayAndExec "Synchro du repertoire Images" "synchro ${HOME}/Images ${DIR_MOUNT}/Images"
displayAndExec "Synchro du repertoire Musiques" "synchro ${HOME}/Musiques ${DIR_MOUNT}/Musiques"
displayAndExec "Synchro du repertoire Videos" "synchro ${HOME}/Videos ${DIR_MOUNT}/Videos"

## retention LOG
find /var/log -name "synchroNAS*.log" -mtime +5 -exec rm -f {} \;
echo
exit 0
