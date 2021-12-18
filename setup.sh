#! /bin/bash


SCRIPT_DIR=$HOME/.dotfiles

function print_welcome_banner {
    echo "================================================================================="
    echo "Starting the setup script"
    echo "================================================================================="
}

function install_homebrew {
    echo "================================================================================="
    echo "Installing the homebrew package manager for $(uname)"
    echo "================================================================================="

    if [ $(uname) = Darwin ] ; then
         xcode-select --install
         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
         eval "$(/opt/homebrew/bin/brew shellenv)"
         echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $SCRIPT_DIR/.zshrc
    elif [ $(uname) = Linux ] ; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $SCRIPT_DIR/.zshrc
    else 
        echo "=========================================================================================="
        echo "Unrecognized OS detected. Unable to install the homebrew package manager"
        echo "=========================================================================================="
        exit 1
    fi

    if [ $? -eq 0 ] ; then
        echo "=========================================================================================="
        echo "Successfully installed the homebrew package manager"
        echo "=========================================================================================="
    else 
        echo "=========================================================================================="
        echo "Failed to install the homebrew package manager"
        echo "=========================================================================================="
        exit 1
    fi
}

function set_up_links {

    echo "================================================================================="
    echo "Setting up symlinks to the dofiles directory in the home directory"
    echo "================================================================================="

    DOTFILES=(.gitconfig .ssh .vimrc .vscode .zprofile .zshrc)

    for file in "${DOTFILES[@]}"
    do
        if [ -f $HOME/$file ] ; then
            rm -f $HOME/$file  
        elif [ -d $HOME/$file ] ; then
            rm -rf $HOME/$file
        fi
    done

    for file in  "${DOTFILES[@]}"
    do
        ln -s $SCRIPT_DIR/$file $HOME/$file
    done

    echo "================================================================================="
    echo "Successfully linked dotfiles to the home directory"
    echo "================================================================================="

}

function install_packages {
    echo "================================================================================="
    echo "Installing packages listed in $SCRIPT_DIR/Brewfile"
    echo "================================================================================="

    /bin/bash "$(brew bundle)"

    if [ $? -eq 0 ] ; then
        echo "=========================================================================================="
        echo "All packages successfully installed Horray!!!"
        echo "=========================================================================================="
    else
        echo "=========================================================================================="
        echo "Not all packages were successfully installed! Continuing with setup."
        echo "=========================================================================================="
    fi

}

function switch_shells {
    echo "================================================================================="
    echo "Preparing to switch the default shell to ZSH"
    echo "================================================================================="

    if [ "$SHELL" == "/bin/zsh" ] ; then
        echo "The default shell is already ZSH. Horray!!!"
    else
        cat /etc/shells | grep zsh
        
        if [ $? -ne 0 ] ; then
            echo "ZSH does not appear to be a valid login shell"
            echo "Will try to add ZSH to /etc/shells"
            brew install zsh
            echo "$(which zsh)" | sudo tee -a /etc/shells
        fi
        
        chsh -s "$(which zsh)"

        if [ $? -eq 0 ] ; then
            echo "======================================================================================"
            echo "Default shell successfully changed to ZSH"
            echo "======================================================================================"
        else 
            echo "======================================================================================"
            echo "The default shell could not be changes to ZSH"
            echo "======================================================================================"
            exit 1
        fi
    fi
}

function print_exit_banner {
    echo "================================================================================="
    echo "Setup script completed successfully. Happy coding!"
    echo "================================================================================="
    exit 0
}

function main {
    print_welcome_banner
    install_homebrew
    set_up_links
    install_packages
    switch_shells
    print_exit_banner
}

main
