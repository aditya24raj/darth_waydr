#!/usr/bin/env bash


# purpose: install waydroid on focal, bullseye and hirsute
# author: aditya raj 


echo -e "\nDarth Waydr"
echo "installs waydroid on focal, bullseye and hirsute"


echo -e "\nPrerequisites"

# check distro
supported_distros="focal/bullseye/hirsute"
distro=$(lsb_release -sc)
if [[ "$supported_distros" != *"$distro"* ]]; then
    echo "expected $supported_distros, found $distro" && exit
fi

# check cpu architecture
arch=$(dpkg --print-architecture)
if [[ "arm64 amd64" != *"$arch"* ]]; then
    echo "expected arm64/amd64, found $arch" && exit
fi

# check if windowing system is wayland
if [[ $XDG_SESSION_TYPE != "wayland" ]]; then
    echo "expected wayland, found $XDG_SESSION_TYPE" && exit
fi

# install dependencies
dependencies="python3 lxc curl wget"
sudo apt-get -q install $dependancies || exit


echo -e "\nUnified install"
sudo wget --secure-protocol=TLSv1_2 --https-only \
https://repo.waydro.id/waydroid.gpg -O /usr/share/keyrings/waydroid.gpg &&
echo "deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://repo.waydro.id/ $distro main" | \
sudo tee /etc/apt/sources.list.d/waydroid.list >/dev/null &&
sudo apt-get -q update || exit


echo -e "\nDesktop install"
sudo apt-get -q install waydroid && sudo waydroid init || exit


echo -e "\nRepo packages install"
repo_url="https://repo.waydro.id/erfan/$distro/"
download_path="$HOME/Downloads/waydroid_packages"

case "$arch" in
    arm64)
        # on arm64 paltform reject packages containing amd64 and waydroid.
        # not rejecting "all" as a few package don't have arm64 specific
        # package and have to use "all" tagged packages
        reject_list="*amd64*,*waydroid*,index.html*"
        ;;
    amd64)
        # on amd64 platform reject arm64 packages and "all" packages
        # as all packages have amd64 sepecific packages
        # reject "all" packages will also reject waydroid packages
        # so no need to add waydroid specifically
        reject_list="*arm64*,*all*,index.html*"
        ;;
esac

# download packages
wget --no-verbose --show-progress --no-directories --timestamping \
--directory-prefix $download_path \
--secure-protocol=TLSv1_2 --https-only  --recursive \
--reject=${reject_list} --no-parent  "$repo_url" || exit

# install pacakages
cd $download_path
sudo dpkg -i *.deb || sudo apt-get -q install -f || exit


echo -e "\n4. Creating Aliases "
waydroid_stop="\nalias waydroid-stop='sudo waydroid session stop && sudo waydroid container stop'"
waydroid_start="alias waydroid-start='waydroid-stop 2>/dev/null && sudo systemctl start waydroid-container && waydroid session start'"
waydroid_start_full="alias waydroid-start-full='waydroid-stop 2>/dev/null && sudo systemctl start waydroid-container && waydroid show-full-ui'\n"

grep "${waydroid_stop}" ~/.bashrc >/dev/null || echo -e "${waydroid_stop}" >> ~/.bashrc
grep "${waydroid_start}" ~/.bashrc >/dev/null || echo -e "${waydroid_start}" >> ~/.bashrc
grep "${waydroid_start_full}" ~/.bashrc >/dev/null || echo -e "${waydroid_start_full}" >> ~/.bashrc


echo -e "\n    waydroid-start        to launch apps/waydroid from app drawer"
echo      "    waydroid-start-full   to launch waydroid in full-screen"
echo      "    waydroid-stop         to stop waydroid"

echo -e "\n    Restart shell/terminal if you cannot access aliases.\n"

# installation complete
echo "enjoy waydroid"


















    
