#!/bin/bash
 
APP=${1#app://}
case ${APP} in
  molotov ) /home/urika/bin/molotov ;;
  power ) gnome-terminal -- bash -c "/home/urika/bin/power_mgmt.sh"
  settings ) gnome-terminal -- bash -c "/home/urika/bin/settings.sh"
  * ) nohup "${APP}" &>/dev/null & ;;
esac
