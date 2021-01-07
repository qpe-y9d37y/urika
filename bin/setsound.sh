#!/bin/bash

########################################################################
# MIT License                             Copyright 2021 Quentin Petit #
# January 2021                             <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                             setsound.sh                              #
#                                                                      #
# Current version: 0.1                                                 #
# Status: Work in progress                                             #
#                                                                      #
# This script purpose it to set sound volume.                          #
#                                                                      #
# Version history:                                                     #
# +----------+--------+------+---------------------------------------+ #
# |   Date   | Author | Vers | Comment                               | #
# +==========+========+======+=======================================+ #
# | 20210107 | QPE    | 0.1  | Starting development                  | #
# +----------+--------+------+---------------------------------------+ #
########################################################################

#                                                                      #
#                               VARIABLES                              #
#                                                                      #

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               FUNCTIONS                              #
#                                                                      #

# Function to print usage.
function usage {
  echo "usage: $(basename $0) [VOL] [-h]
  
Set volume.

arguments:
 VOL         volume to set in percentage
 -h, --help  show this help message"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               BEGINNING                              #
#                                                                      #

# Check if usage is requested.
if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  usage
  exit 0
fi

# Check current volume.
VOL_NOW=$(amixer -c 0 get Master | grep "$(amixer -c 0 get Master | grep "Playback channels" | awk 'NF>1{print $NF}'):" | awk '{print $4}' | sed 's/^.//;s/.\{2\}$//')

# Check if volume level is provided.
if [[ -n $1 ]]; then
  VALUE=$1
else
  # Ask for volume.
  VALUE=$(zenity --scale --text="Set volume." --value=${VOL_NOW})
fi

# Set volume.
amixer -c 0 set Master ${VALUE}%

#                                                                      #
#                                 END                                  #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
