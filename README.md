# Waydroid-Installer
A bash script to automate waydroid installation on supported distros.

Though tested only on 'hirsute', but probably should also work on other waydroid supported distros(focal, bullseye, droidian and ubports).

## Installation
### Method 1
Copy and execute this-
```bash
curl -# --proto '=https' --tlsv1.2 -Sf https://raw.githubusercontent.com/aditya24raj/install_waydroid/main/install_waydroid.sh | bash
```
### or Method 2
1. Download install_waydroid.sh from the repo
```bash
curl -# --proto '=https' --tlsv1.2 -Sf https://raw.githubusercontent.com/aditya24raj/install_waydroid/main/install_waydroid.sh > install_waydroid.sh
```
2. chmod +x install_waydroid.sh
3. ./install_waydroid.sh

## Launch or Stop Waydroid
The installer creates aliases to easily launch and stop waydroid.

Restart shell/terminal if you cannot access following aliases -

- waydroid-start
  - to launch apps/waydroid from app drawer
- waydroid-start-full
  - to launch waydroid in full screen
- waydroid-stop
  - to stop waydroid



## Gallery
installation script running on hirsute
![install_waydroid.sh running in dark purple ubuntu terminal](https://github.com/aditya24raj/install_waydroid/blob/main/install_waydroid.png?raw=true)

