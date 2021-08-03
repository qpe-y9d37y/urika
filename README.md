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

* At then end of the installation, you'll be asked to choose software to install, untick all boxes and click "Continue".

Setup the network and continue. If you need help to setup the network, check [HELP_netconf.md](HELP_netconf.md).

### Git Repository

Login as root and install git:
```
apt update
apt install git
```
Switch to urika user and clone the git repository:
```
su - urika
git clone https://github.com/qpe-y9d37y/urika.git ./Theatre/
```
Once done, switch back to root and launch the installation script:
```
exit
cd /home/urika/Theatre
./urika.sh
```

## Authors

* **Quentin Petit** - *Initial work*

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
