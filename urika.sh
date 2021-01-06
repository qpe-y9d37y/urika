#!/bin/bash

########################################################################
# MIT License                             Copyright 2021 Quentin Petit #
# January 2021                             <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                               urika.sh                               #
#                                                                      #
# Current version: 0.1                                                 #
# Status: Work in progress                                             #
#                                                                      #
# This script purpose is to setup an entertainment system.             #
#                                                                      #
# Version history:                                                     #
# +----------+--------+------+---------------------------------------+ #
# |   Date   | Author | Vers | Comment                               | #
# +==========+========+======+=======================================+ #
# | 20210103 | QPE    | 0.1  | Starting development                  | #
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

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               FUNCTIONS                              #
#                                                                      #

# Function to print usage.
function usage {
  echo "usage: $(basename $0) [-h]
  
Setup an entertainment system.

arguments:
 -h, --help  show this help message"
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

# Check that script is launched by root.
if [[ $(whoami) != "root" ]]; then
  echo "This script should be executed by root, good bye." && exit 1
fi

# Check network connection.
ping -c 1 8.8.8.8 > /dev/null
if [[ $? == 0 ]]; then
  echo "Network reachable"
else
  echo "Network not reachable"

  # Ask if cfg network with script.
  echo "Do you want to configure the network?"
  select ANS_NETCFG in "Yes" "No"; do
    case ${ANS_NETCFG} in
      No ) echo "Cannot continue without reachable network, good bye" && exit 0 ;;
      Yes )
        ./util/deb_netconf.sh
	break
      ;;
    esac
  done
fi

# Create urika group and user.
groupadd ${URIKA_GRP}
useradd -m -d ${DIR_HOME} -g ${URIKA_GRP} ${URIKA_USR}

# Grant sudo rights to urika user.
echo "${URIKA_USR} ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/00-Urika

# Update the package list.
apt-get update

# Install required packages.
apt-get install -y sudo xorg openbox lightdm firefox-esr gnome-terminal dialog curl

# Create lightdm configuration directory.
mkdir /etc/lightdm

# Enable autologin.
cat > /etc/lightdm/lightdm.conf << EOM
[SeatDefaults]
autologin-user=${URIKA_USR}
user-session=openbox
EOM

# Create openbox config directory.
mkdir -p ${DIR_HOME}/.config/openbox
chown -R ${URIKA_USR}:${URIKA_GRP} ${DIR_HOME}/.config
chmod 755 ${DIR_HOME}/.config ${DIR_HOME}/.config/openbox

# Create autostart script.
cat > ${DIR_HOME}/.config/openbox/autostart << EOM
#!/bin/bash
firefox --kiosk ${DIR_HOME}/html/index.html &
EOM

# Copy html directory.
cp -r ./html ${DIR_HOME}/
chown -R ${URIKA_USR}:${URIKA_GRP} ${DIR_HOME}/html
chmod 755 ${DIR_HOME}/html ${DIR_HOME}/html/images ${DIR_HOME}/html/icons
chmod 644 ${DIR_HOME}/html/index.html ${DIR_HOME}/html/images/* ${DIR_HOME}/html/icons/*

# Create .desktop file for application launcher.
cat > /usr/share/applications/appurl.desktop << EOM
[Desktop Entry]
Name=TerminalURL
Exec=${DIR_HOME}/bin/open_app.sh %u
Type=Application
NoDisplay=true
Categories=System;
MimeType=x-scheme-handler/app;
EOM

# Refresh mime types database.
update-desktop-database

# Copy bin directory.
cp -r ./bin ${DIR_HOME}/
chown -R ${URIKA_USR}:${URIKA_GRP} ${DIR_HOME}/bin
chmod -R 755 ${DIR_HOME}/bin

# Add spotify GPG key.
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add - 

# Add spotify repository.
echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list

# Update the package list.
apt-get update

# Install spotify.
apt-get install -y spotify-client

# Copy spotify icon.
cp /usr/share/spotify/icons/spotify-linux-128.png ${DIR_HOME}/html/icons/spotify.png
chown ${URIKA_USR}:${URIKA_GRP} ${DIR_HOME}/html/icons/spotify.png

# Set Firefox homepage.
### user_pref("browser.startup.homepage", "${DIR_HOME}/html/index.html");
### ~/.mozilla/firefox/PROFILE_NAME.default/user.js
### /etc/skel/.mozilla/firefox/mwad0hks.default/prefs.js
if [[ -d ${DIR_HOME}/.mozilla ]]; then 
  cd ${DIR_HOME}/.mozilla/firefox/*.default && \
    echo "user_pref(\"browser.startup.homepage\", \"${DIR_HOME}/html/index.html\");" > user.js && \
    chown ${URIKA_USR}:${URIKA_GRP} user.js
fi

#                                                                      #
#                                  END                                 #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
