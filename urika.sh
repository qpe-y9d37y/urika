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

# Create urika user.
useradd -m urika

# Update the package list.
apt-get update

# Install required packages.
apt-get install -y sudo xorg openbox lightdm firefox-esr gnome-terminal dialog curl

# Create lightdm configuration directory.
mkdir /etc/lightdm

# Enable autologin.
cat > /etc/lightdm/lightdm.conf << EOM
[SeatDefaults]
autologin-user=urika
user-session=openbox
EOM

# Create openbox config directory.
mkdir -p /home/urika/.config/openbox
chown -R urika:urika /home/urika/.config
chmod 755 /home/urika/.config /home/urika/.config/openbox

# Create autostart script.
cat > /home/urika/.config/openbox/autostart << EOM
#!/bin/bash
firefox --kiosk /home/urika/html/index.html &
EOM

# Copy html directory.
cp -r ./html /home/urika/
chown -R urika:urika /home/urika/html
chmod 755 /home/urika/html /home/urika/html/images /home/urika/html/icons
chmod 644 /home/urika/html/index.html /home/urika/html/images/* /home/urika/html/icons/*

# Create .desktop file for application launcher.
cat > /usr/share/applications/appurl.desktop << EOM
[Desktop Entry]
Name=TerminalURL
Exec=/home/urika/bin/open_app.sh %u
Type=Application
NoDisplay=true
Categories=System;
MimeType=x-scheme-handler/app;
EOM

# Refresh mime types database.
update-desktop-database

# Copy bin directory.
cp -r ./bin /home/urika/
chown -R urika:urika /home/urika/bin
chmod -R 755 /home/urika/bin

# Add spotify GPG key.
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add - 

# Add spotify repository.
echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list

# Update the package list.
apt-get update

# Install spotify
apt-get install -y spotify-client

#                                                                      #
#                                  END                                 #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
