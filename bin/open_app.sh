#!/bin/bash
 
APP=${1#app://}
case ${APP} in
  molotov ) /home/urika/bin/molotov ;;
  * ) nohup "${APP}" &>/dev/null & ;;
esac
