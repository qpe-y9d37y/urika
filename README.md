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

The following images used as icons are under the Creative Commons license:

* [power.png](../master/html/icons/power.png): [GNOME Project](https://www.gnome.org/) [CC BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.en). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-system-shutdown.svg

* [settings.png](../master/html/icons/settings.png): [GNOME Project](https://www.gnome.org/) [CC BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.en). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-applications-utilities.svg

* [terminal.png](../master/html/icons/terminal.png): [GNOME Project](https://www.gnome.org/) [CC BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.en). Retrieved from: https://commons.wikimedia.org/wiki/File:Gnome-utilities-terminal.svg

The following image used as background is in the public domain (because it was created by the Image Science & Analysis Laboratory, of the NASA Johnson Space Center. NASA copyright policy states that "NASA material is not protected by copyright unless noted"):

* [background.jpg](../master/html/images/background.jpg): NASA/Kjell Lindgren. Retrieved from https://en.wikipedia.org/wiki/File:ISS-45_StoryOfWater,_Colors_Patiently_Swirl_-_Haditha_Dam_Lake.jpg

## Authors

* **Quentin Petit** - *Initial work*

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
