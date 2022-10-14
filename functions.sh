# Some user functions that can be useful

# upgrade all formulas and casks
function brewupall() {
    packages=($(echo $(brew outdated -q) | tr "," "\n"))
    for package in $packages
    do
        # Attempt to build from source; otherwise grab the binary
        brew upgrade -sv $package || brew upgrade $package
    done;
    # upgrade any other packages (like casks)
    brew upgrade --greedy
}
