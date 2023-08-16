#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Function to compare two version strings
compare_versions() {
    if [[ $1 == $2 ]]; then
        echo 0
        return
    fi

    local IFS=.
    local i ver1=($1) ver2=($2)
    for ((i = 0; i < ${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            echo 1
            return
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            echo 1
            return
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            echo -1
            return
        fi
    done
    echo 0
}

# Check if Go is installed
if command -v go &>/dev/null; then
    installed_version=$(go version | awk '{print $3}')
    latest_version=$(curl -s https://go.dev/VERSION?m=text | head -n 1)

    comparison=$(compare_versions "$installed_version" "$latest_version")

    if [[ $comparison -lt 0 ]]; then
        echo "Installed Go version is older. Updating to $latest_version."
        # Download and install the latest version of Go
        wget "https://go.dev/dl/$latest_version.linux-amd64.tar.gz" -O /tmp/go.tar.gz
        tar -C /usr/local -xzf /tmp/go.tar.gz
        rm /tmp/go.tar.gz
    else
        echo "Go is up to date."
    fi
else
    echo "Go is not installed. Installing..."
    # Download and install the latest version of Go
    latest_version=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
    wget "https://go.dev/dl/$latest_version.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
fi

# Add Go path to shell configuration
if [[ -n $BASH_VERSION ]]; then
    shellrc_path="$HOME/.bashrc"
elif [[ -n $ZSH_VERSION ]]; then
    shellrc_path="$HOME/.zshrc"
else
    echo "Unsupported shell."
    exit 1
fi

go_path_added=$(grep -c "export PATH=\$PATH:/usr/local/go/bin" "$shellrc_path")

if [[ $go_path_added -eq 0 ]]; then
    echo "export PATH=\$PATH:/usr/local/go/bin" >> "$shellrc_path"
    source "$shellrc_path"
    echo "Go path added to $shellrc_path."
else
    echo "Go path is already present in $shellrc_path."
fi

echo "Script completed."
