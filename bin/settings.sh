#!/bin/bash

########################################################################
# MIT License                             Copyright 2021 Quentin Petit #
# January 2021                             <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                              settings.sh                             #
#                                                                      #
# Current version: 0.1                                                 #
# Status: Work in progress                                             #
#                                                                      #
# This script purpose it to access to some basic settings from the     #
# urika interface.                                                     #
#                                                                      #
# Version history:                                                     #
# +----------+--------+------+---------------------------------------+ #
# |   Date   | Author | Vers | Comment                               | #
# +==========+========+======+=======================================+ #
# | 20210105 | QPE    | 0.1  | Starting development                  | #
# +----------+--------+------+---------------------------------------+ #
########################################################################

#                                                                      #
#                               VARIABLES                              #
#                                                                      #

# Files and directories.
INPUT=/tmp/menu.sh.$$
RES_LINK="/etc/X11/Xsession.d/45setoutput"
RES_SCRIPT="/home/urika/bin/setoutput.sh"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               FUNCTIONS                              #
#                                                                      #

# Function to manage screen resolution
function scresolution {
  # Dialog menu.
  dialog --clear --title "Settings" \
    --menu "Select your choice:" 15 50 1 \
    1 "Reset screen resolution" \
    2 "Change screen resolution" 2>"${INPUT}"

  # Register choice.
  ITEM=$(<"${INPUT}")

  # Launch selected action.
  case ${ITEM} in
    1)
      if [[ -L ${RES_LINK} ]]; then
        ${RES_LINK}
      else
        xrandr --auto
      fi
    ;;
    2)
      # Choose resolution with xrandr -q
      # If chosen resolution is default
      if [[ ${SCR_RES} == "Default" ]]; then
        # Remove symlink if it exists
        if [[ -L ${RES_LINK} ]]; then
          rm ${RES_LINK}
        fi
        # Apply default resolution
        xrandr --auto
      # If chosen resolution is not default
      else
        # Set RES variable in ${RES_SCRIPT}
        sed -i "s/^RES.*$/RES=\"${SCR_RES}\"/" ${RES_SCRIPT}
        # Create symbolic link ${RES_LINK} -> ${RES_SCRIPT}
        if [[ ! -L ${RES_LINK} ]]; then
          ln -s ${RES_SCRIPT} ${RES_LINK}
        elif [[ $(ls -l ${RES_LINK} | awk 'NF>1{print $NF}') == "${RES_SCRIPT}" ]]; then
          ln -sf ${RES_SCRIPT} ${RES_LINK}
        fi
        # Set selected resolution
        ${RES_LINK}
      fi
    ;;
  esac
    
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               BEGINNING                              #
#                                                                      #

# Launch dialog menu.
dialog --clear --title "Settings" \
  --menu "Select your choice:" 15 50 1 \
  1 "Update Urika" \
  2 "Screen resolution" 2>"${INPUT}"

# Register choice.
ITEM=$(<"${INPUT}")

# Launch selected action.
case ${ITEM} in
  1) sudo apt update && sudo apt upgrade ;;
  2) scresolution ;;
esac

#                                                                      #
#                                 END                                  #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
