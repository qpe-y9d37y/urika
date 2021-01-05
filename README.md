# urika: TV Entertainment System

## Introduction

## Setup

To setup the entertainment system you need a minimal debian 10 fresh installation (it might work on other debian-like distributions but hasn't been tested).

Setup the network and clone the git repository as root:
```
cd && git clone https://github.com/qpe-y9d37y/urika.git
```

If you're having difficulties to setup your network, download the zipped repository, unzip it and copy it on a USB stick. On the Debian computer plug your USB stick and do as root:
```
lsblk
```
You'll see your USB stick listed, for example:
```
sdb      179:0    0   3.7G  0 disk
`-sdb1   179:1    0   3.4G  0 part
```
Now, you can do:
```
mount /dev/sdb1 /mnt
cp /mnt/urika /root/
```

Finally launch the installer:
```
cd /root/urika/
./urika.sh
```

## Attribution

The images used as icons and background are under the Creative Commons license:

* [background.jpg](../master/html/images/background.jpg): [Moahim](https://commons.wikimedia.org/wiki/User:Moahim) [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/deed.en). Retrieved from: https://en.wikipedia.org/wiki/File:2019_-_Nationalpark_Jasmund_-_03.jpg

* [power.png](../master/html/icons/power.png): [GNOME Project](https://www.gnome.org/) [CC BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.en). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-system-shutdown.svg

* [settings.png](../master/html/icons/settings.png): [GNOME Project](https://www.gnome.org/) [CC BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.en). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-applications-utilities.svg

* [terminal.png](../master/html/icons/terminal.png): [GNOME Project](https://www.gnome.org/) [CC BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.en). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-utilities-terminal.svg

## Authors

* **Quentin Petit** - *Initial work*

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
