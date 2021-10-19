# Desk Waydr
A bash script to install waydroid on supported desktop distributions(focal, bullseye and hirsute).


## Installation
Execute the command below to download the script and install waydroid-

```bash
wget -P ~/Downloads https://raw.githubusercontent.com/aditya24raj/desk_waydr/main/desk_waydr.sh && bash ~/Downloads/desk_waydr.sh
```

# Waydroid Aliases
The installer creates aliases to easily launch and stop waydroid.

Restart shell/terminal if you cannot access following aliases -

- waydroid-stop
  - to stop waydroid
  - alias for
    ```bash
    sudo waydroid session stop && sudo waydroid container stop
    ```
- waydroid-start
  - to launch apps/waydroid from app drawer
  - alias for
    ```bash
    waydroid-stop 2>/dev/null && sudo systemctl start waydroid-container && waydroid session start
    ```
- waydroid-start-full
  - to launch waydroid in full screen
  - alias for
    ```bash
    waydroid-stop 2>/dev/null && sudo systemctl start waydroid-container && waydroid show-full-ui
    ```
