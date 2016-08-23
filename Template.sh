#!/bin/sh

#===============================================================================
# CREATION
# Date de creation      : 08/09/87
# Auteur                : jdesesquelles
# Version               : V1.0
#===============================================================================
#
# Commentaire complet du script.
#
#===============================================================================


# ------------------------------------------------------------------------------
# VARIABLES: globales
# ------------------------------------------------------------------------------
DATE=`date +"%Y%m%d"`
HOME_PATH=${HOME}
LOG_FILE="${HOME_PATH}/template-$DATE.log"
BIN_PATH="/usr/bin"
FILE_1="/tmp/test1.txt"
FILE_2="/tmp/test2.txt"
ARG_NBR="$#"
ARG_1="$1"
ARG_2="$2"


# ------------------------------------------------------------------------------
# FONCTION: Message et log
# ------------------------------------------------------------------------------
displayMessage() {
  echo "$*"
}

displayError() {
  echo -e "\r\e[0;31m* $* *\e[0m"
#  exit 1
}

displayTitle() {
  displayMessage "------------------------------------------------------------------------------"
  displayMessage "$*"
  displayMessage "------------------------------------------------------------------------------"
}

# Parametres: MESSAGE COMMAND
displayAndExec() {
  local message=$1
  echo -n "[En cours] $message"
  shift
  echo ">>> $*" >> $LOG_FILE 2>&1
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
# FUNCTION: test root
# ------------------------------------------------------------------------------
function testRoot() {
#if [ "$(id -u)" != "0" ]; then
if [ "$(id -u)" = "0" ]; then
#        displayError "Vous n'etes pas root."
        displayError "Merci de ne pas utiliser de droit root."
        exit 1
fi
}


# ------------------------------------------------------------------------------
# FUNCTION: Test bin
# ------------------------------------------------------------------------------
function testBin() {
if [ ! -d "$BIN_PATH" ];then
        displayError "Repertoire: \"$BIN_PATH\" introuvable."
        exit 1
fi
}


# ------------------------------------------------------------------------------
# FUNCTION: Test file + source
# ------------------------------------------------------------------------------
function testFile() {
if [[ ! -e "$1" ]]; then
        displayError "Fichier: \"$(basename $1)\" absent."
        exit 1
fi
}

function sourceFile() {
testFile $1
source $1
}


# ------------------------------------------------------------------------------
# FUNCTION: Usage
# ------------------------------------------------------------------------------
function usage() {
#if [ -z "$ARG_1" ] || [ -z "$ARG_2" ]; then
if [ "$ARG_NBR" -ne 2 ]; then
        echo -e "\r\e[0;31m* Argument(s) manquant *\e[0m"
        echo
        echo "Info:"
        echo -e "\tScript pour bla bla bla..."
        echo
        echo "Usage:"
        echo -e "\t$(basename $0) -p <product_id> -g <g0r0c0>"
        echo
        exit 1
fi
}


# ------------------------------------------------------------------------------
# FUNCTION: Choix (ALL)
# ------------------------------------------------------------------------------
function allProduct() {
displayAndExec "pause 5s" "sleep 5"
displayAndExec "pause 4s" "sleep 4"
displayAndExec "pause 3s" "sleep 3"
displayAndExec "pause 2s" "sleep 2"
displayAndExec "pause 1s" "sleep 1"
}


# ------------------------------------------------------------------------------
# FUNCTION: Choix (LIST)
# ------------------------------------------------------------------------------
function productChoice() {
sleep 1
}


# ------------------------------------------------------------------------------
# FUNCTION: Menu
# ------------------------------------------------------------------------------
main() {
#clear
echo
displayTitle "Ceci est un Titre"
echo -e "Selection de parmi le menu suivant:"
echo -e "\tALL  : choix1"
echo -e "\tLIST : choix2"
echo
echo -e -n "Entrez votre choix [ ALL | LIST ] : "
read METHOD

case $METHOD in
  ALL|all )
    allProduct
  ;;
  LIST|list )
    productChoice
  ;;
  * )
    displayError "reponse incorrect"
#    main
  ;;
esac
}

# ------------------------------------------------------------------------------
# START
# ------------------------------------------------------------------------------
#---
usage
testRoot
testBin
testFile $FILE_1
#---
main
exit 0
