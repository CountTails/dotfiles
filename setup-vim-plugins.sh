#! /bin/bash

pluginDir=~/.vim

pluginNames=("auto-pairs" "rainbow")
pluginRepos=("https://github.com/jiangmiao/auto-pairs.git"
             "https://github.com/luochen1990/rainbow.git"
    )

prepare() {
    mkdir -p $pluginDir/autoload
    mkdir -p $pluginDir/plugin
}

cleanup() {
    rm -rf $pluginDir/autoload
    rm -rf $pluginDir/plugin
}

list() {
    echo "Vim plugins to be installed:"
    echo
    for index in "${!pluginNames[@]}"; do
        echo "    ${pluginNames[$index]} -> ${pluginRepos[$index]}"
    done
    echo
    echo "Total: ${#pluginNames[@]}"
}

uninstall() {
    echo "Uninstalling all plugins"
    echo
    for plugin in "${pluginNames[@]}"; do
        if [ -d $pluginDir/$plugin ] ; then
            rm -rf $pluginDir/$plugin
            echo "Uninstalled $plugin"
        fi
    done
    cleanup
    echo
    echo "Done"
}

install() {
    list
    prepare
    echo
    for index in "${!pluginNames[@]}" ; do
        echo "Downloading ${pluginNames[@]}"
        git clone ${pluginRepos[$index]} $pluginDir/${pluginNames[$index]}
        echo "Installing ${pluginNames[$index]}"
        cp -R $pluginDir/${pluginNames[$index]}/autoload/ $pluginDir/autoload/
        cp -R $pluginDir/${pluginNames[$index]}/plugin $pluginDir/plugin/
    done    
}

usage() {
    echo "usage: setup-vim-plugin.sh [COMMAND]"
    echo
    echo "    COMMAND [list|install|uninstall]"
}

main(){
    if [ $# -ne 1 ]; then
        usage
        exit 1
    else
        if [ "$1" == "list" ]; then
            list
            exit 0
        elif [ "$1" == "install" ]; then
            install
            exit 0
        elif [ "$1" == "uninstall" ]; then
            uninstall
            exit 0
        else
            usage
            exit 1
        fi
    fi
}

main $*
