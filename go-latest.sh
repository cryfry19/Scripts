#!/bin/bash

# Bash script to download the latest version of Go in linux

# Check if Go is already installed
if command -v go &>/dev/null; then
    installed_version=$(go version | cut -d ' ' -f 3 | cut -d '.' -f 1,2)
    latest_version=$(curl -s https://go.dev/VERSION?m=text)

    if [ "$installed_version" == "$latest_version" ]; then
        echo "Go is already installed and up to date (version $installed_version)."
    else
        echo "Updating Go to the latest version..."
        wget https://go.dev/dl/$(curl -s https://go.dev/dl/ | grep -o 'go[0-9\.]*\.linux-amd64.tar.gz' | head -n 1)
        sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz
        rm go*.linux-amd64.tar.gz

        if ! grep -qxF 'export PATH=$PATH:/usr/local/go/bin' ~/.bashrc; then
            echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc
            source ~/.bashrc
            echo "Go has been updated to version $latest_version, and the PATH has been added to .bashrc."
        else
            echo "Go has been updated to version $latest_version."
        fi
    fi
else
    echo "Go is not installed. Installing the latest version..."
    latest_version=$(curl -s https://go.dev/VERSION?m=text)
    wget https://go.dev/dl/$(curl -s https://go.dev/dl/ | grep -o 'go[0-9\.]*\.linux-amd64.tar.gz' | head -n 1)
    sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz
    rm go*.linux-amd64.tar.gz

    echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc
    source ~/.bashrc
    echo "Go has been installed (version $latest_version) and the PATH has been added to .bashrc."
fi