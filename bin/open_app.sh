#!/bin/bash

########################################################################
# MIT License                             Copyright 2021 Quentin Petit #
# January 2021                             <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                              open_app.sh                             #
#                                                                      #
# Current version: 0.1                                                 #
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
# +----------+--------+------+---------------------------------------+ #
########################################################################

#                                                                      #
#                               VARIABLES                              #
#                                                                      #

# App to launch.
APP=${1#app://}

# Files and directories.
DIR_HOME="/home/urika"

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
  molotov ) ${DIR_HOME}/bin/molotov & ;;
  power ) gnome-terminal -- bash -c "${DIR_HOME}/bin/power_mgmt.sh" ;;
  settings ) gnome-terminal -- bash -c "${DIR_HOME}/bin/settings.sh" ;;
  * ) nohup "${APP}" &>/dev/null & ;;
esac

#                                                                      #
#                                 END                                  #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
