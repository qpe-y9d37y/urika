# urika: TV Entertainment System

## Introduction

Urika is a small TV Entertainment System to be able to access streaming
services such as Netflix, Disney+ from a simplified interface. It can
run on old computers with low performances.

## Installation

### System Setup

To setup the entertainment system you need a minimal debian 10 fresh
installation (it might work on other debian-like distributions but
hasn't been tested). I let you install Debian the way you want but
except for two steps:

* When you're prompted to set a user account, enter "urika" as "Full name for the new user".

* At then end of the installation, you'll be asked to choose software to install, untick all boxes anc click "Continue".

### Network Setup

#### Wireless Network

To setup a WiFi connection, login as root and list the network interfaces:
```
ip l
```
The wireless interface's name starts with "wl" (for example `wlp4s0`).
In the following commands replace ${WL_IF} by your interface's name.
Set the wireless interface up:
```
ip link set dev ${WL_IF} up
```
Scan the network:
```
iwlist ${WL_IF} scan | grep "ESSID"
```
In the following commands replace ${SSID} by your WiFi network name.
Create and edit a WiFi configuration file:
```
vi /etc/wpa_supplicant/wpa_supplicant.conf
```
and add the following content:
```
network={
  proto=RSN
  key_mgmt=WPA-PSK
  group=CCMP
  pairwise=CCMP
  priority=10
  ssid="${SSID}"
```
Encrypt your password and include it in the configuration file:
```
wpa_passphrase "${ANS_SSID}" "${SSID_PWD}" | sed 's/^[[:space:]]*//' | grep "^psk" >> /etc/wpa_supplicant/wpa_supplicant.conf
```
Re-open the configuration file to add a `}` at the end of the file.
Now we need to edit the configuration of the interface:
```
vi /etc/network/interfaces.d/ifcfg-${WL_IF}
```
If you want to setup a DHCP connection, add:
```
auto ${WL_IF}
iface ${WL_IF} inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```
Or if you want a fix configuration, add instead (with ${IP_ADDR} the fix ip address, ${NETMASK} the netmask and ${GATEWAY} the gateway):
```
auto ${WL_IF}
iface ${WL_IF} inet static
  address ${IP_ADDR}
  netmask ${NETMASK}
  gateway ${GATEWAY}
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```
Now, restart the network:
```
systemctl restart wpa_supplicant
systemctl restart networking
```

#### Ethernet Network

To setup an ethernet connection, login as root and list the network interfaces:
```
ip l
```
The ethernet interface's name starts with "en" (for example `enp7s0`).
In the following commands replace ${EN_IF} by your interface's name.
Edit the configuration of the interface:
```
vi /etc/network/interfaces.d/ifcfg-${EN_IF}
```
If you want to setup a DHCP connection, add:
```
auto ${EN_IF}
iface ${EN_IF} inet dhcp
```
Or if you want a fix configuration, add instead (with ${IP_ADDR} the fix ip address, ${NETMASK} the netmask and ${GATEWAY} the gateway):
```
auto ${EN_IF}
iface ${EN_IF} inet static
  address ${IP_ADDR}
  netmask ${NETMASK}
  gateway ${GATEWAY}
```
Now, restart the network:
```
systemctl restart networking
```

### Git Repository

Login and root and install git:
```
apt update
apt install git
```
Switch to urika user and clone the git repository (don't forget the `.` after the url):
```
su - urika
git clone https://github.com/qpe-y9d37y/urika.git .
```
Once done, switch back to root and launch the installation script:
```
exit
cd /home/urika
chmod 755 urika.sh
./urika.sh
```

## Attribution

The following images by the [GNOME Project](https://www.gnome.org/) are under the Creative Commons license [CC BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.en):

* [power.png](../master/html/icons/power.png). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-system-shutdown.svg

* [settings.png](../master/html/icons/settings.png). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-applications-utilities.svg

* [volume.png](../master/html/icons/volume.png). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-audio-volume-high.svg

* [mute.png](../master/html/icons/mute.png). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-audio-volume-muted.svg

The following image is in the public domain (because it was created by the Image Science & Analysis Laboratory, of the NASA Johnson Space Center. NASA copyright policy states that "NASA material is not protected by copyright unless noted"):

* [background.jpg](../master/html/images/background.jpg): NASA/Kjell Lindgren. Retrieved from https://en.wikipedia.org/wiki/File:ISS-45_StoryOfWater,_Colors_Patiently_Swirl_-_Haditha_Dam_Lake.jpg

## Authors

* **Quentin Petit** - *Initial work*

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
