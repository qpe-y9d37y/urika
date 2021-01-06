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
RES_LINK="/etc/X11/Xsession.d/45setoutput"
RES_SCRIPT="/home/urika/bin/setoutput.sh"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               FUNCTIONS                              #
#                                                                      #

# Function to manage screen resolution
function scresolution {
  # Zenity menu.
  ANS_SCRES=$(zenity --list \
    --text="" --radiolist \
    --column="Pick" --column="Option" \
    FALSE "Reset screen resolution" \
    FALSE "Change screen resolution")

  # Launch selected action.
  case ${ANS_SCRES} in
    "Reset screen resolution" )
      if [[ -L ${RES_LINK} ]]; then
        ${RES_LINK}
      else
        xrandr --auto
      fi
    ;;
    "Change screen resolution" )
      # Choose resolution with xrandr -q
      SCR_RES=$(zenity --list \
        --text="" --radiolist \
        --column="Pick" --column="Option" \
	FALSE Default \
        $(for RESOLUTION in \
          $(xrandr -q | grep -o "[[:digit:]]\{1,\}*x[[:digit:]]\{1,\}" | sort -n | uniq); \
        do echo "FALSE ${RESOLUTION}"; done))
      # If chosen resolution is default
      if [[ ${SCR_RES} == "Default" ]]; then
        # Remove symlink if it exists
        if [[ -L ${RES_LINK} ]]; then
          sudo rm ${RES_LINK}
        fi
        # Apply default resolution
        xrandr --auto
      # If chosen resolution is not default
      else
        # Set RES variable in ${RES_SCRIPT}
        sed -i "s/^RES.*$/RES=\"${SCR_RES}\"/" ${RES_SCRIPT}
        # Create symbolic link ${RES_LINK} -> ${RES_SCRIPT}
        if [[ ! -L ${RES_LINK} ]]; then
          sudo ln -s ${RES_SCRIPT} ${RES_LINK}
        elif [[ $(ls -l ${RES_LINK} | awk 'NF>1{print $NF}') == "${RES_SCRIPT}" ]]; then
          sudo ln -sf ${RES_SCRIPT} ${RES_LINK}
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

# Main menu
ANS_MAIN=$(zenity --list \
  --text="" --radiolist \
  --column="Pick" --column="Option" \
  FALSE "Update system" \
  FALSE "Screen resolution")

# Launch selected action.
case ${ANS_MAIN} in
  "Update system" ) sudo apt update && sudo apt -y upgrade ;;
  "Screen resolution" ) scresolution ;;
  * ) exit 0 ;;
esac

#                                                                      #
#                                 END                                  #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
