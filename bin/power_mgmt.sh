#!/bin/bash

########################################################################
# MIT License                             Copyright 2020 Quentin Petit #
# April 2020                               <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                             power_mgmt.sh                            #
#                                                                      #
# Current version: 1.0                                                 #
# Status: Stable                                                       #
#                                                                      #
# This script purpose it to manage the power of the urika server and   #
# client.                                                              #
#                                                                      #
# Version history:                                                     #
# +----------+------------+------+-----------------------------------+ #
# |   Date   |   Author   | Vers | Comment                           | #
# +==========+============+======+===================================+ #
# | 20200420 | Quentin P. | 1.0  | First stable version              | #
# +----------+------------+------+-----------------------------------+ #
#                                                                      #
########################################################################

#                                                                      #
#                               VARIABLES                              #
#                                                                      #

# Files and directories.
INPUT=/tmp/menu.sh.$$

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               FUNCTIONS                              #
#                                                                      #



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               BEGINNING                              #
#                                                                      #

# Launch dialog menu.
dialog --clear --title "Power Management" \
  --menu "Select your choice:" 15 50 2 \
  1 "Restart Urika" \
  2 "Shutdown Urika" 2>"${INPUT}"

# Register choice.
ITEM=$(<"${INPUT}")

# Launch selected action.
case ${ITEM} in
  1) sudo shutdown -r now;;
  2) sudo shutdown -h now;;
esac

#                                                                      #
#                                 END                                  #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
