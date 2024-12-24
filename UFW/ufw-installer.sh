#!/bin/bash

SCRIPT_URL="https://raw.githubusercontent.com/KarinaBash/Auto-Installer/refs/heads/main/UFW/ufw.sh"
SCRIPT_NAME="ufw-manager.sh"
INSTALL_PATH="/usr/local/bin/ufw-manager"

echo -e "\\033[1m\\033[34mDownloading UFW management script...\\033[0m"
if wget -O $SCRIPT_NAME $SCRIPT_URL; then
    echo -e "\\033[1m\\033[32mSuccessfully downloaded the script.\\033[0m"
else
    echo -e "\\033[1m\\033[31mFailed to download the script.\\033[0m"
    exit 1
fi

echo -e "\\033[1m\\033[34mInstalling the script to $INSTALL_PATH...\\033[0m"
if sudo mv $SCRIPT_NAME $INSTALL_PATH; then
    echo -e "\\033[1m\\033[32mSuccessfully installed the script.\\033[0m"
else
    echo -e "\\033[1m\\033[31mFailed to install the script.\\033[0m"
    exit 1
fi

echo -e "\\033[1m\\033[34mSetting execute permissions...\\033[0m"
if sudo chmod +x $INSTALL_PATH; then
    echo -e "\\033[1m\\033[32mSuccessfully set execute permissions.\\033[0m"
else
    echo -e "\\033[1m\\033[31mFailed to set execute permissions.\\033[0m"
    exit 1
fi

echo -e "\\033[1m\\033[32mInstallation complete. You can now run the UFW management tool using 'ufw-manager' command.\\033[0m"
