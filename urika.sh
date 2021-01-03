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
# This script purpose is to set up an entertainment system.            #
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

#usage () {
#}

wlan_setup () {
  # Discover wireless interface
  IF_WLAN=$(ip l | grep -v link | awk '{print $2}' | sed 's/.$//' | grep "^w")

  # Confirm interface
  echo "Set interface ${IF_WLAN}?"
  select ANS_IFWLAN in "Yes" "No"; do
    case ${ANS_IFWLAN} in
      Yes ) break ;;
      No )
        # Choose interface
	select ANS_IFCHOICE in $(ip l | grep -v link | awk '{print $2}' | sed 's/.$//' | grep -v 'lo'); do
	  IF_WLAN=${ANS_IFCHOICE}
	  break
	done
      ;;
    esac
  done

  echo "Interface ${IF_CHOICE} will be configured"

  # Write wireless configuration
#  cat > /etc/wpa_supplicant/wpa_supplicant.conf << EOM
#network={
#  proto=RSN
#  key_mgmt=WPA-PSK
#  group=CCMP
#  pairwise=CCMP
#  priority=10
#  ssid="FRITZ!Box 7560 ZY"
#  psk="00510058006391613756"
#}
#EOM
#
#  # Write wireless interface configuration
#  cat >> /etc/network/interfaces << EOM
#
#auto ${IF_WLAN}
#iface ${IF_WLAN} inet dhcp
#wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
#EOM
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                                                      #
#                               BEGINNING                              #
#                                                                      #

# Check network connection
#ping -c 1 8.8.8.8 > /dev/null
ping -c 1 xx8.8.8.8 > /dev/null
if [[ $? == 0 ]]; then
  echo "Network reachable"
else
  echo "Network not reachable"
  # Ask if cfg network with script
  echo "Do you want to configure the network?"
  select ANS_NETCFG in "Yes" "No"; do
    case ${ANS_NETCFG} in
      No ) echo "Cannot continue without reachable network, good bye" && exit 0 ;;
      Yes ) 
	# Ask which kind of network
        echo "Wireless or ethernet?"
	select ANS_NETTYPE in "Wireless" "Ethernet"; do
	  case ${ANS_NETTYPE} in
	    Wireless ) wlan_setup ;;
	    Ethernet ) echo "Sorry not available yet" && exit 0 ;;
	  esac
        done
	;;
    esac
  done
fi
