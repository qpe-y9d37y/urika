#!/bin/bash

########################################################################
# MIT License                             Copyright 2021 Quentin Petit #
# January 2021                             <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                            deb_netconf.sh                            #
#                                                                      #
# Current version: 0.1                                                 #
# Status: Work in progress                                             #
#                                                                      #
# This script purpose is to configure a network interface on Debian.   #
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

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               FUNCTIONS                              #
#                                                                      #

# Function to print usage.
function usage {
  echo "usage: $(basename $0) [-h]

Configure a network interface on Debian.

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

# Count the number of wired and wireless interfaces.
IF_COUNT=$(ip l | grep -v link | awk '{print $2}' | sed 's/.$//' | egrep "^en|^wl" | wc -l)

# Check if no interface is found.
if [[ ${IF_COUNT} == 0 ]]; then
  echo "No wired nor wireless interface found, good bye."
  exit 404

# Check if only one interface is found.
elif [[ ${IF_COUNT} == 1 ]]; then
  IF_DEV=$(ip l | grep -v link | awk '{print $2}' | sed 's/.$//' | egrep "^en|^wl")
  echo "Only one interface found: ${IF_DEV}"
  # Ask confirmation.
  echo "Do you want to proceed with this one?"
  select ANS_ONEIF in "Yes" "No"; do
    case ${ANS_ONEIF} in
      Yes ) break ;;
      No ) echo "Good bye then" && exit 0 ;;
    esac
  done

# Choose interface if there is more than one.
else
  echo "Which interface do you want to configure?"
  select ANS_IFDEV in $(ip l | grep -v link | awk '{print $2}' | sed 's/.$//' | egrep "^en|^wl") "Cancel"; do
    case ${ANS_IFDEV} in
      Cancel ) echo "Good bye then" && exit 0 ;;
      * ) IF_DEV=${ANS_IFDEV} && break ;;
    esac
  done
fi

# Get SSID and password for wireless connection.
if [[ ${IF_DEV} == wl* ]]; then

  # Set interface to up state.
  ip link set dev ${IF_DEV} up

  # Choose SSID.
  echo "To which SSID do you want to connect?"
  select ANS_SSID in $(iwlist ${IF_DEV} scan | grep "ESSID" | sed 's/^[[:space:]]*//;s/.$//' | cut -c 9-) "Cancel"; do
    case ${ANS_SSID} in
      Cancel ) echo "Good bye then" && exit 0 ;;
      * ) break ;;
    esac
  done

  # Ask for password.
  echo -n "Password: "
  read -s SSID_PWD
  echo

  # Encrypt password.
  SSID_SECRET=$(wpa_passphrase "${ANS_SSID}" "${SSID_PWD}" | sed 's/^[[:space:]]*//' | grep "^psk")

  # Write wireless configuration
  cat >> /etc/wpa_supplicant/wpa_supplicant.conf << EOM
network={
  proto=RSN
  key_mgmt=WPA-PSK
  group=CCMP
  pairwise=CCMP
  priority=10
  ssid="${ANS_SSID}"
  ${SSID_SECRET}
}
EOM

fi

# Choose method.
echo "DHCP or Manual?"
select ANS_METHOD in "DHCP" "Manual" "Cancel"; do
  case ${ANS_METHOD} in
    Cancel ) echo "Good bye then" && exit 0 ;;
    Manual )

      # Ask for static configuration.
      echo -n "IP address? " && read IP_ADDR
      echo -n "Netmask? " && read NETMASK
      echo -n "Gateway? " && read GATEWAY

      # Set static configuration.
      cat >> /etc/network/interfaces << EOM

auto ${IF_DEV}
iface ${IF_DEV} inet static
  address ${IP_ADDR}
  netmask ${NETMASK}
  gateway ${GATEWAY}
EOM

    ;;
    DHCP )

      # Set DHCP configuration.
      cat >> /etc/network/interfaces << EOM

auto ${IF_DEV}
iface ${IF_DEV} inet dhcp
EOM

    ;;
  esac
done

# Add link to wpa configuration if wireless.
if [[ ${IF_DEV} == wl* ]]; then
  echo "wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" >> /etc/network/interfaces
fi

#                                                                      #
#                                  END                                 #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
