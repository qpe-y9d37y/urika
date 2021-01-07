#!/bin/bash

########################################################################
# MIT License                             Copyright 2021 Quentin Petit #
# January 2021                             <qpe-y9d37y@protonmail.com> #
#                                                                      #
#                              netconf.sh                              #
#                                                                      #
# Current version: 0.1                                                 #
# Status: Work in progress                                             #
#                                                                      #
# This script purpose is to provide a simple wizard to configure a     #
# wired or wireless network interface on Debian.                       #
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

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               BEGINNING                              #
#                                                                      #

# Count the number of wired and wireless interfaces.
IF_COUNT=$(ip l | grep -v link | awk '{print $2}' | sed 's/.$//' | egrep "^en|^wl" | wc -l)

# Check if no interface is found.
if [[ ${IF_COUNT} == 0 ]]; then
  zenity --info --text="No wired nor wireless interface found, good bye."
  exit 404

# Check if only one interface is found.
elif [[ ${IF_COUNT} == 1 ]]; then
  IF_DEV=$(ip l | grep -v link | awk '{print $2}' | sed 's/.$//' | egrep "^en|^wl")
  zenity --question --text="Only one interface found: ${IF_DEV}. Do you want to proceed with this one?"
  if [[ $? != 0 ]]; then
    exit 0
  fi

# Choose interface if there is more than one.
else
  ANS_IFDEV=$(zenity --list --text="Which interface do you want to configure?" --radiolist \
    --column="Pick" --column="Interface" --column="Type" \
    $(for INTERFACE in $(ip l | grep -v link | awk '{print $2}' | sed 's/.$//' | egrep "^en|^wl"); do \
      echo -n "FALSE ${INTERFACE} "; \
      [[ ${INTERFACE} == wl* ]] && echo "wireless" || echo "ethernet"; \
    done))
  if [[ -n ${ANS_IFDEV} ]]; then
    IF_DEV=${ANS_IFDEV}
  else
    exit 0
  fi
fi

# Get SSID and password for wireless connection.
if [[ ${IF_DEV} == wl* ]]; then

  # Set interface to up state.
  ip link set dev ${IF_DEV} up

  # Choose SSID.
  ANS_SSID=$(zenity --list --text="To which SSID do you want to connect?" --radiolist \
    --column="Pick" --column="SSID" \
    $(iwlist ${IF_DEV} scan | grep "ESSID" | sed 's/^[[:space:]]*//;s/.$//' | cut -c 9-))
  if [[ $? != 0 ]]; then
    exit 0
  fi

  # Ask for password.
  SSID_PASSWD=$(zenity --password)
  if [[ -z ${SSID_PASSWD} ]]; then
    exit 0
  fi

  # Encrypt password.
  SSID_SECRET=$(wpa_passphrase "${ANS_SSID}" "${SSID_PASSWD}" | sed 's/^[[:space:]]*//' | grep "^psk")

  # Check if wireless configuration already exists.
  if [[ -f /etc/wpa_supplicant/wpa_supplicant.conf ]]; then
    zenity --question --text="Wireless configuration already exists, do you want to overwrite it?"
    if [[ $? != 0 ]]; then
      exit 0
    fi
  fi

  # Write wireless configuration.
  cat > /etc/wpa_supplicant/wpa_supplicant.conf << EOM
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

# Check if configuration exists for ${IF_DEV} in /etc/network/interfaces.
grep ${IF_DEV} /etc/network/interfaces >/dev/null 2>&1
if [[ $? == 0 ]]; then
  zenity --error --text="A configuration for ${IF_DEV} already exists in /etc/network/interfaces. Please remove it and try again."
  exit 1
fi

# Check if /etc/network/interfaces.d/ifcfg-${IF_DEV} exists.
if [[ -z ${ANS_WLOVERW} ]] && [[ -f /etc/network/interfaces.d/ifcfg-${IF_DEV} ]]; then
  zenity --question --text="A configuration already exists for ${IF_DEV}, do you want to overwrite it?"
  if [[ $? != 0 ]]; then
    exit 0
  fi
fi

# Make sure that interfaces configuration source to interfaces.d/*.
grep "^source /etc/network/interfaces.d/\*$" /etc/network/interfaces >/dev/null 2>&1
if [[ $? != 0 ]]; then
  echo "source /etc/network/interfaces.d/*" >> /etc/network/interfaces
fi

# Choose method.
ANS_METHOD=$(zenity --info --title="Method" --text="" \
  --ok-label="Cancel" --extra-button="DHCP" --extra-button="Manual")
case ${ANS_METHOD} in
  Manual )

    # Ask for static configuration.
    IP_FORM=$(zenity --forms --text="Static configuration:" --separator="," --add-entry="IP address" --add-entry="Netmask" --add-entry="Gateway")
    if [[ $? != 0 ]]; then
      exit 0
    fi
    IP_ADDR=$(echo ${IP_FORM} | cut -d',' -f1)
    NETMASK=$(echo ${IP_FORM} | cut -d',' -f2)
    GATEWAY=$(echo ${IP_FORM} | cut -d',' -f3)

    # Set static configuration.
    cat > /etc/network/interfaces.d/ifcfg-${IF_DEV} << EOM
auto ${IF_DEV}
iface ${IF_DEV} inet static
  address ${IP_ADDR}
  netmask ${NETMASK}
  gateway ${GATEWAY}
EOM

  ;;
  DHCP )

    # Set DHCP configuration.
    cat > /etc/network/interfaces.d/ifcfg-${IF_DEV} << EOM
auto ${IF_DEV}
iface ${IF_DEV} inet dhcp
EOM

  ;;
  * ) exit 0 ;;
esac

# Add link to wpa configuration if wireless.
if [[ ${IF_DEV} == wl* ]]; then
  echo "wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" >> /etc/network/interfaces.d/ifcfg-${IF_DEV}
fi

# Restart networking.
if [[ ${IF_DEV} == wl* ]]; then
  systemctl restart wpa_supplicant
fi
systemctl restart networking

#                                                                      #
#                                  END                                 #
#                                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
