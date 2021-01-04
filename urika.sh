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
apt-get install sudo xorg openbox lightdm firefox

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
while true; do
  firefox --kiosk /home/urika/html/index.html &
done
EOM

# Create html directory
mkdir -p /home/urika/html/{images,icons}
chown -R urika:urika /home/urika/html
chmod -R 755 /home/urika/html

#                                                                      #
#                                  END                                 #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
