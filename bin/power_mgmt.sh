#!/bin/bash

########################################################################
# MIT License                             Copyright 2020 Quentin Petit #
# April 2020                               <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                             power_mgmt.sh                            #
#                                                                      #
# Current version: 2.0                                                 #
# Status: Stable                                                       #
#                                                                      #
# This script purpose it to manage the power of the urika server and   #
# client.                                                              #
#                                                                      #
# Version history:                                                     #
# +----------+--------+------+---------------------------------------+ #
# |   Date   | Author | Vers | Comment                               | #
# +==========+========+======+=======================================+ #
# | 20200420 | QPE    | 1.0  | First stable version                  | #
# | 20210106 | QPE    | 2.0  | New vers. /w zenity instead of dialog | #
# +----------+--------+------+---------------------------------------+ #
########################################################################

#                                                                      #
#                               VARIABLES                              #
#                                                                      #

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               FUNCTIONS                              #
#                                                                      #

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               BEGINNING                              #
#                                                                      #

# Ask if user wants to shutdown or restart.
ACTION=$(zenity --info \
  --title="Power Management" \
  --text="" \
  --ok-label="Cancel" \
  --extra-button="Restart" \
  --extra-button="Shutdown")

# Launch selected action.
case ${ACTION} in
  Restart ) sudo shutdown -r 0 ;;
  Shutdown ) sudo shutdown -h 0 ;;
  * ) exit 0 ;;
esac

#                                                                      #
#                                 END                                  #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
