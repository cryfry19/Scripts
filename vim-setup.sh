#!/bin/bash

# Beautify colors
GREEN="\e[32m"
RESET="\e[0m"

# Function to print a message with green color
print_green() {
    echo -e "${GREEN}$1${RESET}"
}

# Download the .vimrc file
curl -o ~/.vimrc https://raw.githubusercontent.com/tomnomnom/dotfiles/master/.vimrc

# Create necessary directories
sudo mkdir -p ~/.vim/bundle
cd ~/.vim/bundle

# Clone Vundle.vim and other plugins
plugins=(
    "https://github.com/VundleVim/Vundle.vim.git"
    "https://github.com/tpope/vim-fugitive.git"
    "https://github.com/sjl/gundo.vim.git"
    "https://github.com/godlygeek/tabular.git"
    "https://github.com/vim-airline/vim-airline.git"
    "https://github.com/vim-airline/vim-airline-themes.git"
    "https://github.com/altercation/vim-colors-solarized.git"
    "https://github.com/preservim/nerdtree.git"
    "https://bitbucket.org/TomNomNom/xoria256.vim"
    "https://github.com/fatih/vim-go.git"
    "https://github.com/rust-lang/rust.vim.git"
)

for plugin in "${plugins[@]}"; do
    repo_name=$(basename "$plugin" .git)
    if [ ! -d "$repo_name" ]; then
        git clone "$plugin"
        print_green "Cloned $repo_name"
    else
        echo "$repo_name already exists, skipping..."
    fi
done

# Create vimprev script
sudo sh -c "cat << EOF > /usr/local/bin/vimprev
#!/bin/bash
VIMENV=prev vim \$@
EOF"

sudo chmod +x /usr/local/bin/vimprev

# Display completion message
print_green "Vim setup and vimprev script creation completed!"
