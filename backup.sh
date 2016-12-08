#!/bin/sh

#===============================================================================
# CREATION
# Date de creation      : 26/08/2016
# Auteur                : jdesesquelles
# Version               : V1.0
#===============================================================================
#
# Script Backup/sauvegarde sur /mnt/filer
#
#===============================================================================


# ------------------------------------------------------------------------------
# VARIABLES: globales
# ------------------------------------------------------------------------------
DATE=`date +"%Y%m%d-%H%M"`
DIR_DIST="/mnt/FLAN"
DIR_BACKUP="$DIR_DIST/backup_home"
LOG_FILE="${DIR_DIST}/backup_home-${DATE}.log"


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
  /bin/ls $DIR_DIST > /dev/null
  /bin/mount |grep $DIR_DIST > /dev/null
  if [ ! $? -eq 0 ]; then
    displayError "Impossible de monter le repertoire distant."
  fi
}
function checkProcRsync {
  if /usr/bin/pgrep rsync 2>&1 > /dev/null; then
    displayError "Un processus rsync est deja en cours."
  fi
}

# ------------------------------------------------------------------------------
# MAIN
# ------------------------------------------------------------------------------
#clear
echo
displayTitle "Script Backup/Sauvegarde de sa HOME"

testMount
checkProcRsync

# tag DATE
[ -d $DIR_BACKUP ]|| mkdir -p $DIR_BACKUP
echo $DATE > $LOG_FILE

## repertoire et fichier a rsync
displayAndExec "Copie du fichier .bashrc" "/bin/cat $HOME/.bashrc > $DIR_BACKUP/_bashrc"
displayAndExec "Copie du fichier smb.conf" "/bin/cat /etc/samba/smb.conf > $DIR_BACKUP/smb.conf"
displayAndExec "Copie du fichier crontab" "/usr/bin/crontab -l |grep -v ^#  > $DIR_BACKUP/crontab"
displayAndExec "Copie du fichier .adm" "cp $HOME/.adm $DIR_BACKUP/adm"
displayAndExec "Rsync du repertoire .clusterssh" "/usr/bin/rsync -avP $HOME/.clusterssh/ $DIR_BACKUP/_clusterssh"
displayAndExec "Rsync du repertoire .ssh" "/usr/bin/rsync -avP $HOME/.ssh/ $DIR_BACKUP/_ssh"
displayAndExec "Rsync du repertoire APPLIS" "/usr/bin/rsync -avP $HOME/APPLIS/ $DIR_BACKUP/APPLIS"
displayAndExec "Rsync du repertoire SCRIPTS" "/usr/bin/rsync -avP $HOME/SCRIPTS/ $DIR_BACKUP/SCRIPTS"
displayAndExec "Rsync du repertoire Documents" "/usr/bin/rsync -avP $HOME/Documents/ $DIR_BACKUP/Documents"

## retention LOG
find $DIR_DIST -name "backup_home*.log" -mtime +5 -exec rm -f {} \;
echo
exit 0
