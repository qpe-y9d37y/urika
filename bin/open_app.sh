#!/bin/bash

########################################################################
# MIT License                             Copyright 2021 Quentin Petit #
# January 2021                             <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                              open_app.sh                             #
#                                                                      #
# Current version: 0.2                                                 #
# Status: Work in progress                                             #
#                                                                      #
# This script purpose it to manage the power of the urika server and   #
# client.                                                              #
#                                                                      #
# Version history:                                                     #
# +----------+--------+------+---------------------------------------+ #
# |   Date   | Author | Vers | Comment                               | #
# +==========+========+======+=======================================+ #
# | 20210104 | QPE    | 0.1  | Starting development                  | #
# | 20210803 | QPE    | 0.2  | Adding DIR_URIKA var                  | #
# +----------+--------+------+---------------------------------------+ #
########################################################################

#                                                                      #
#                               VARIABLES                              #
#                                                                      #

# App to launch.
APP=${1#app://}

# Files and directories.
DIR_HOME="/home/urika"
DIR_URIKA="${DIR_HOME}/Theater"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               FUNCTIONS                              #
#                                                                      #



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               BEGINNING                              #
#                                                                      #

# Launch app.
case ${APP} in
  molotov ) ${DIR_URIKA}/bin/molotov.AppImage --no-sandbox & ;;
  mute ) ${DIR_URIKA}/bin/setsound.sh 0 ;;
  power ) ${DIR_URIKA}/bin/power_mgmt.sh & ;;
  settings ) gnome-terminal -- bash -c "${DIR_URIKA}/bin/settings.sh" ;;
  volume ) ${DIR_URIKA}/bin/setsound.sh ;;
  * ) nohup "${APP}" &>/dev/null & ;;
esac

#                                                                      #
#                                 END                                  #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
