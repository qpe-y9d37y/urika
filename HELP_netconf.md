# Network Setup

## Wireless Network

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
## Ethernet Network

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
