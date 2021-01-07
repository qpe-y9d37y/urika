# urika: TV Entertainment System

## Introduction

Urika is a small TV Entertainment System to be able to access streaming services such as Netflix, Disney+ from a simplified interface. It can run on old computers with low performances.

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

The icons for the different services and applications are protected by copyright so I prefer not to include them in the repository.
You can download them and put them in the `/home/urika/html/icons` directory.

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
