#!/bin/bash

########################################################################
# MIT License                             Copyright 2021 Quentin Petit #
# January 2021                             <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                               urika.sh                               #
#                                                                      #
# Current version: 0.4                                                 #
# Status: Work in progress                                             #
#                                                                      #
# This script purpose is to setup an entertainment system.             #
#                                                                      #
# Version history:                                                     #
# +----------+--------+------+---------------------------------------+ #
# |   Date   | Author | Vers | Comment                               | #
# +==========+========+======+=======================================+ #
# | 20210103 | QPE    | 0.1  | Starting development                  | #
# | 20210330 | QPE    | 0.2  | Simplified and better looking         | #
# | 20210726 | QPE    | 0.3  | Dl Molotov + permissions              | #
# | 20210803 | QPE    | 0.4  | Dest path is not empty error          | #
# +----------+--------+------+---------------------------------------+ #
########################################################################

#                                                                      #
#                               VARIABLES                              #
#                                                                      #

# Users and Groups.
URIKA_USR="urika"
URIKA_GRP="urika"

# Files and directories.
DIR_HOME="/home/urika"
DIR_URIKA="${DIR_HOME}/theatre"
DIR_LOG="${DIR_URIKA}/log"
FIL_LOG="${DIR_LOG}/$(basename ${0} | sed 's/.sh/.log/')"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               FUNCTIONS                              #
#                                                                      #

# Function to print usage.
function usage {
  echo "usage: $(basename $0) [-h]
  
Setup an entertainment system.
arguments:
 -h, --help  show this help message" > /dev/tty
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               BEGINNING                              #
#                                                                      #

# Print usage if requested.
if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  usage
  exit 0
fi

# Start logging.
if [[ ! -d ${DIR_LOG} ]]; then
  mkdir ${DIR_LOG}
fi
date > ${FIL_LOG}
exec 2>> ${FIL_LOG} 1>> ${FIL_LOG}
set -x

# Print status.
echo -n "Check prerequisites " > /dev/tty

# Check that script is launched by root.
if [[ $(whoami) != "root" ]]; then
  echo -e "[\e[91mKO\e[0m]" > /dev/tty
  echo -e "[\e[91mERR\e[0m] This script should be executed by root, good bye." > /dev/tty
  exit 1
fi

# Check network connection.
ping -c 1 8.8.8.8 > /dev/null
if [[ $? != 0 ]]; then
  echo -e "[\e[91mKO\e[0m]" > /dev/tty
  echo -e "[\e[91mERR\e[0m] Network not reachable, good bye." > /dev/tty
  exit 1
fi

# Check ${DIR_URIKA}.
if [[ ! -d ${DIR_URIKA} ]]; then
  echo -e "[\e[91mKO\e[0m]" > /dev/tty
  echo -e "[\e[91mERR\e[0m] ${DIR_URIKA} doesn't exist. Please read README.md." > /dev/tty
  exit 1
fi

# Check ${URIKA_USR} exists.
grep ${URIKA_USR} /etc/passwd
if [[ $? != "0" ]]; then
  echo -e "[\e[91mKO\e[0m]" > /dev/tty
  echo -e "[\e[91mERR\e[0m] ${URIKA_USR} doesn't exist. Please read README.md." > /dev/tty
  exit 1
fi

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty
echo -n "Sudo rights         " > /dev/tty

# Grant sudo rights to urika user.
echo "${URIKA_USR} ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/00-Urika

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty
echo -n "Install packages    " > /dev/tty

# Update the package list.
apt-get update

# Install required packages.
apt-get install -y sudo xorg openbox lightdm firefox-esr gnome-terminal zenity curl pulseaudio alsamixergui

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty
echo -n "Lightdm config      " > /dev/tty

# Create lightdm configuration directory.
mkdir /etc/lightdm

# Enable autologin.
cat > /etc/lightdm/lightdm.conf << EOM
[SeatDefaults]
autologin-user=${URIKA_USR}
user-session=openbox
EOM

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty
echo -n "Openbox config      " > /dev/tty

# Create openbox config directory.
mkdir -p ${DIR_HOME}/.config/openbox
chown -R ${URIKA_USR}:${URIKA_GRP} ${DIR_HOME}/.config
chmod 755 ${DIR_HOME}/.config ${DIR_HOME}/.config/openbox

# Create autostart script.
cat > ${DIR_HOME}/.config/openbox/autostart << EOM
#!/bin/bash
firefox --kiosk ${DIR_URIKA}/html/index.html &
EOM

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty
echo -n "File permissions    " > /dev/tty

# Set correct permissions for html directory.
chown -R ${URIKA_USR}:${URIKA_GRP} ${DIR_URIKA}/html
chmod 755 ${DIR_URIKA}/html
chmod 644 ${DIR_URIKA}/html/index.html

# Set correct permissions for bin directory.
chown -R ${URIKA_USR}:${URIKA_GRP} ${DIR_URIKA}/bin
chmod -R 755 ${DIR_URIKA}/bin

# Download Molotov and set correct permissions.
cd ${DIR_URIKA}/bin
wget https://desktop-auto-upgrade.molotov.tv/linux/4.4.4/molotov.AppImage
chown -R ${URIKA_USR}:${URIKA_GRP} ${DIR_URIKA}/bin/molotov.AppImage
chmod -R 755 ${DIR_URIKA}/bin/molotov.AppImage

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty
echo -n "App launcher        " > /dev/tty

# Create .desktop file for application launcher.
cat > /usr/share/applications/appurl.desktop << EOM
[Desktop Entry]
Name=TerminalURL
Exec=${DIR_URIKA}/bin/open_app.sh %u
Type=Application
NoDisplay=true
Categories=System;
MimeType=x-scheme-handler/app;
EOM

# Refresh mime types database.
update-desktop-database

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty
echo -n "Install Spotify     " > /dev/tty

# Add spotify GPG key.
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add - 

# Add spotify repository.
echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list

# Update the package list.
apt-get update

# Install spotify.
apt-get install -y spotify-client

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty
echo -n "Firefox config      " > /dev/tty

# Set Firefox homepage.
### user_pref("browser.startup.homepage", "${DIR_HOME}/html/index.html");
### ~/.mozilla/firefox/PROFILE_NAME.default/user.js
### /etc/skel/.mozilla/firefox/mwad0hks.default/prefs.js
if [[ -d ${DIR_HOME}/.mozilla ]]; then 
  cd ${DIR_HOME}/.mozilla/firefox/*.default && \
    echo "user_pref(\"browser.startup.homepage\", \"${DIR_HOME}/html/index.html\");" > user.js && \
    chown ${URIKA_USR}:${URIKA_GRP} user.js
fi

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty
echo -n "CLI aliases         " > /dev/tty

# Add CLI aliases.
cat >> ${DIR_HOME}/.bash_aliases << EOM
# ls alias
alias ll='ls -l'
EOM
chmod 644 ${DIR_HOME}/.bash_aliases
chown urika:urika ${DIR_HOME}/.

# Print status.
echo -e "[\e[92mOK\e[0m]" > /dev/tty

#                                                                      #
#                                  END                                 #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
