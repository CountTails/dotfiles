#! /bin/bash


SCRIPT_DIR=$HOME/.dotfiles

function wrapped_text {
    msg="=>  $*"
    edge=$(echo "$msg" | sed 's/./=/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}

function install_homebrew {
    
    wrapped_text "Preparing to install the homebrew package manager"

    if [ $(uname) = Darwin ] ; then
         xcode-select -p
         if [ $? -eq 0 ] ; then

            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            if [ $(uname -m) = x86_64 ] ; then
                eval "$(/usr/local/bin/brew shellenv)"
            elif [ $(uname -m) = arm64 ] ; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
                wrapped_text "Unsupported architecture ($uname -m). Unable to install the homebrew package manager"
                exit 1
            fi
         else
            wrapped_text "xcode command line tools are required to install homebrew.\nRun the following to install them:\n\n\t $ xcode-select --install\nRe-run the script after installation completes"
           exit 1 
         fi
    elif [ $(uname) = Linux ] ; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $(uname -m) != x86_64 ] ; then
             wrapped_text "Unsupported architecture ($uname -m). Unable to install the homebrew package manager"
             exit 1
        fi
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else 
        wrapped_text "Unrecognized OS detected. Unable to install the homebrew package manager"
        exit 1
    fi

    if [ $? -eq 0 ] ; then
        wrapped_text "Successfully installed the homebrew package manager"
    else 
        wrapped_text "Failed to install the homebrew package manager"
        exit 1
    fi
}

function set_up_links {

    wrapped_text "Setting up symlinks to the dofiles directory in the home directory"

    DOTFILES=(.gitconfig .ssh .vimrc .zprofile .zshrc )

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
        echo "Linked $SCRIPT_DIR/$file to $HOME/$file"
    done

    wrapped_text "Successfully linked dotfiles to the home directory"

}

function install_packages {
    wrapped_text "Installing packages listed in $SCRIPT_DIR/Brewfile"

    /bin/bash "$(brew bundle -v)"

    if [ $? -eq 0 ] ; then
        wrapped_text "All packages successfully installed Horray!!!"
    else
        wrapped_text "Not all packages were successfully installed! Continuing with setup."
    fi

}

function switch_shells {
    wrapped_text "Preparing to switch the default shell to ZSH"

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
            wrapped_text "Default shell successfully changed to ZSH"
        else 
            wrapped_text "The default shell could not be changes to ZSH"
            exit 1
        fi
    fi
}


function main {
    wrapped_text "Starting the setup script"
    install_homebrew
    set_up_links
    install_packages
    switch_shells
    wrapped_text "Setup script completed successfully. Happy coding!"
}

main
