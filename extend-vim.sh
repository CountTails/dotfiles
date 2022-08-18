#! /bin/bash

pluginDir=~/.vim

pluginNames=("auto-pairs" "rainbow" "lightline.vim")
pluginRepos=("https://github.com/jiangmiao/auto-pairs.git"
             "https://github.com/luochen1990/rainbow.git"
             "https://github.com/itchyny/lightline.vim.git"
         )

themeNames=("deus")
themeRepos=("https://github.com/ajmwagar/vim-deus.git")

prepare() {
    mkdir -p $pluginDir/autoload
    mkdir -p $pluginDir/plugin
    mkdir -p $pluginDir/colors
}

cleanup() {
    rm -rf $pluginDir/autoload
    rm -rf $pluginDir/plugin
    rm -rf $pluginDir/colors
}

list() {
    echo "Vim plugins to be installed:"
    echo
    echo "    Functional"
    for index in "${!pluginNames[@]}"; do
        echo "        ${pluginNames[$index]} -> ${pluginRepos[$index]}"
    done
    echo
    
    echo "    Aesthetical"
    for index in "${themeNames[@]}"; do
        echo "        ${themeNames[$index]} -> ${themeRepos[$index]}"
    done
    echo
}

uninstall() {
    echo "Uninstalling all plugins"
    echo
    for plugin in "${pluginNames[@]}"; do
        if [ -d $pluginDir/$plugin ] ; then
            rm -rf $pluginDir/$plugin
            echo "    Uninstalled $plugin"
        fi
    done
    for theme in "${themeNames[@]}"; do
        if [ -d $pluginDir/$theme ] ; then
            rm -rf $pluginDir/$theme
            echo "    Uninstalled $theme"
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
        echo "    Downloading ${pluginNames[$index]}"
        git clone --quiet ${pluginRepos[$index]} $pluginDir/${pluginNames[$index]}
        echo "    Installing ${pluginNames[$index]}"
        cp -R $pluginDir/${pluginNames[$index]}/autoload/ $pluginDir/autoload/
        cp -R $pluginDir/${pluginNames[$index]}/plugin $pluginDir/plugin/
    done

    for index in "${!themeNames[@]}" ; do
        echo "    Downloading ${themeNames[$index]}"
        git clone --quiet ${themeRepos[$index]} $pluginDir/${themeNames[$index]}
        echo "    Installing ${themeNames[$index]}"
        cp -R $pluginDir/${themeNames[$index]}/colors/ $pluginDir/colors/
    done     
}

usage() {
    echo "usage: extend-vim.sh [COMMAND]"
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
