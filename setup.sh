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

    if [ "$(uname)" == "Darwin" ] then
         xcode-select --install
         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    elif [ "$(uname)" == "Linux" ] then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else 
        echo "=========================================================================================="
        echo "Unrecognized OS detected. Unable to install the homebrew package manager"
        echo "=========================================================================================="
        exit(1)
    fi

    if [ $? -eq 0 ] then
        echo "=========================================================================================="
        echo "Successfully installed the homebrew package manager"
        echo "=========================================================================================="
    else 
        echo "=========================================================================================="
        echo "Failed to install the homebrew package manager"
        echo "=========================================================================================="
        exit(1)
    fi
}

function set_up_links {

    echo "================================================================================="
    echo "Setting up symlinks to the dofiles directory in the home directory"
    echo "================================================================================="

    DOTFILES=(.gitconfig .ssh/ .vimrc .vscode/ .zprofile .zshrc)

    for file in "${DOTFILES[@]}"
    do
        if [ -f $HOME/$file ] then
            rm -f $HOME/$file  
        elif [ -d $HOME/$file ] then
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
    echo "Installing packages listed in $SCRIPTDIR/Brewfile"
    echo "================================================================================="

    /bin/bash "$(brew bundle)"

    if [ $? -eq 0 ] then
        echo "=========================================================================================="
        echo "All packages successfully installed"
        echo "=========================================================================================="
    else
        echo "=========================================================================================="
        echo "Something went wrong installing packages"
        echo "=========================================================================================="
        exit(1)
    fi

}

function switch_shells {
    echo "================================================================================="
    echo "Preparing to switch the default shell to ZSH"
    echo "================================================================================="

    if [ "$SHELL" == "/bin/zsh" ] then
        echo "The default shell is already ZSH. Horray!!!"
    else then
        chsh "$(which zsh)"

        if [ $? -eq 0 ] then
            echo "======================================================================================"
            echo "Default shell successfully changed to ZSH"
            echo "======================================================================================"
        else then
            echo "======================================================================================"
            echo "The default shell could not be changes to ZSH"
            echo "======================================================================================"
            exit(1)
        fi
    fi
}

function print_exit_banner {
    echo "================================================================================="
    echo "Setup script complete. Happy coding!"
    echo "================================================================================="
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
