#!/usr/bin/env bash


# Purpose: Automate waydroid installation
#          on focal, bullseye, hirsute, droidian
#          and ubports distributions.
# Author : Aditya Raj 



echo -e "Waydroid Installation"



echo -e "\n1. Prequesites"


# exit if not on supported distro else determine distro type
supported_desktop_distros="focal bullseye hirsute"
supported_mobile_distros="droidian ubports"
current_distro=$(lsb_release -sc) || { 
    echo -e "\nfailed to get distro name automatically.";
    read -p "please enter your distro name: " current_distro;
    }

if [[ $supported_desktop_distros =~  $current_distro ]]
then
current_distro_type="desktop"
elif [[ $supported_mobile_distros =~  $current_distro ]]
then
current_distro_type="mobile"
else
echo -e "\nsorry, $current_distro is not supported."
echo "supported distributions are $supported_desktop_distros $supported_mobile_distros"
exit
fi



# wayland session manager, exit if unsatisfied
if [[ $XDG_SESSION_TYPE != "wayland" ]]
then
echo "please switch to wayland windowing system."
exit
fi

#python3, lxc, curl
dependancies="python3 lxc curl"
echo "sudo apt-get -q install $dependancies"
# using apt isntall as it will install if not installed
# or will try to upgrade if already installed
sudo apt-get -q install $dependancies || { echo -e "\nfailed to install dependancies"; exit; }



echo -e "\n2. Unified Install"

sudo curl -# --proto '=https' --tlsv1.2 -Sf https://repo.waydro.id/waydroid.gpg --output /usr/share/keyrings/waydroid.gpg || { echo -e "\nfailed to fetch https://repo.waydro.id/waydroid.gpg using curl!"; exit; }
sudo echo "deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://repo.waydro.id/ $current_distro main" > /etc/apt/sources.list.d/waydroid.list
sudo apt-get -q update || { echo -e "\nfailed to update packages"; exit; }


echo -e "\n3. Desktop Install"
if [[ $current_distro_type == "desktop" ]];
then
sudo apt-get -q install waydroid || { echo -e "\nfailed to install waydroid"; exit; }
sudo waydroid init || { echo -e "\nfailed to initialize waydroid"; exit; }


echo -e "\n4. Creating Aliases "
waydroid_stop="alias waydroid-stop='sudo waydroid session stop && sudo waydroid container stop'"
waydroid_start="alias waydroid-start='waydroid-stop 2>/dev/null && sudo systemctl start waydroid-container && waydroid session start'"
waydroid_start_full="alias waydroid-start-full='waydroid-stop 2>/dev/null && sudo systemctl start waydroid-container && waydroid show-full-ui'"

grep "${waydroid_stop}" ~/.bashrc >/dev/null || echo "${waydroid_stop}" >> ~/.bashrc
grep "${waydroid_start}" ~/.bashrc >/dev/null || echo "${waydroid_start}" >> ~/.bashrc
grep "${waydroid_start_full}" ~/.bashrc >/dev/null || echo "${waydroid_start_full}" >> ~/.bashrc


echo -e "\n    waydroid-start        to launch apps/waydroid from app drawer"
echo      "    waydroid-start-full   to launch waydroid in full-screen"
echo      "    waydroid-stop         to stop waydroid"

echo -e "\n    Restart terminal/shell for these aliases to take effect.\n"


else
echo -e "\n3. Mobile Install"
sudo -s
apt update || { echo -e "\nfailed to update packages"; exit; }
apt install waydroid || { echo -e "\nfailed to install waydroid"; exit; }
waydroid init || { echo -e "\nfailed to initialize waydroid"; exit; }
start waydroid || { echo -e "\nfailed to start waydroid-container"; exit; }
fi



echo "Enjoy Waydroid!"








