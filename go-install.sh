#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Bash script to download the latest version of Go in linux

# Check if Go is already installed
if command -v go &>/dev/null; then
    installed_version=$(go version | cut -d ' ' -f 3 | cut -d '.' -f 1,2)
    latest_version=$(curl -s https://go.dev/VERSION?m=text)

    if [ "$installed_version" == "$latest_version" ]; then
        echo -e "${GREEN}Go is already installed and up to date (version $installed_version).${NC}"
    else
        echo -e "${YELLOW}Updating Go to the latest version...${NC}"
        wget https://go.dev/dl/$(curl -s https://go.dev/dl/ | grep -o 'go[0-9\.]*\.linux-amd64.tar.gz' | head -n 1)
        sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz
        rm go*.linux-amd64.tar.gz

        if ! grep -qxF 'export PATH=$PATH:/usr/local/go/bin' ~/.bashrc; then
            echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc
            echo -e "${GREEN}Go has been updated to version $latest_version and the PATH has been added to .bashrc.${NC}"
        else
            echo -e "${GREEN}Go has been updated to version $latest_version.${NC}"
        fi
    fi
else
    echo -e "${RED}Go is not installed. Installing the latest version...${NC}"
    latest_version=$(curl -s https://go.dev/VERSION?m=text)
    wget https://go.dev/dl/$(curl -s https://go.dev/dl/ | grep -o 'go[0-9\.]*\.linux-amd64.tar.gz' | head -n 1)
    sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz
    rm go*.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc
    echo -e "${GREEN}Go has been installed (version $latest_version) and the PATH has been added to .bashrc.${NC}"
fi

# Check if the .bashrc file exists and is readable
sudo apt install libshout-tools -y
if [ -f ~/.bashrc ] && [ -r ~/.bashrc ]; then
    source ~/.bashrc
    echo "${GREEN}Successfully sourced ~/.bashrc.${NC}"
else
    echo "${RED}Unable to source ~/.bashrc. File not found or not readable.${NC}"
fi
