#!/bin/bash

# purpose : install waydroid on debian-based distributions
# author  : aditya raj <aditya2400raj@gmail.com>

# trap any errors and exit
trap "{ echo script failed. please try again. ; exit; }" ERR

echo -e "\nDarth Waydr"
echo -e "install waydroid on debain-based distributions\n"


echo -e "\nprerequisites"

# check distro
supported_distros=" focal bullseye hirsute "
fallback_distro="bullseye"
distro=$(lsb_release -sc)

if [[ "$supported_distros" != *" $distro "* ]]; then
	echo -e "\nwarning: unsupported distribution: $distro"
	echo "warning: using fallback distribution: $fallback_distro"
	distro=$fallback_distro
fi

# check if windowing system is wayland
if [[ $XDG_SESSION_TYPE != "wayland" ]]; then
	echo -e "\nerror: unsupported display server: $XDG_SESSION_TYPE"
	echo -e "please switch to wayland display server\n"
	exit
fi

# install dependencies
dependencies="python3 lxc ca-certificates wget"
sudo apt-get -q install $dependencies


echo -e "\nadd keyring and waydroid repo"

sudo wget https://repo.waydro.id/waydroid.gpg -O /usr/share/keyrings/waydroid.gpg
sudo sh -c "echo 'deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://repo.waydro.id/ $distro main' > /etc/apt/sources.list.d/waydroid.list"
sudo apt-get -q update


echo -e "\ninstall waydroid"
sudo apt-get -q install waydroid
sudo waydroid init
sudo systemctl start waydroid-container

echo -e "\nFinishing touches"
# detect vm and modify waydroid_base.prop
lscpu | grep "Hypervisor vendor" && \
	echo "modifying base prop to run inside virtual machine" && \
	sudo sed -i "s/ro.hardware.gralloc=gbm/#ro.hardware.gralloc=gbm\nro.hardware.gralloc=default/" /var/lib/waydroid/waydroid_base.prop && \
	sudo sed -i "s/ro.hardware.egl=mesa/#ro.hardware.egl=mesa\nro.hardware.egl=swiftshader/" /var/lib/waydroid/waydroid_base.prop
	

echo -e "\ninstallation finished"
echo "launch waydroid from apps menu"
echo -e "during first launch(and during first launches after reboot),\nit may take 2-3 minutes before anything appears on screen\n"


