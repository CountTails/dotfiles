# Some user functions that can be useful

# upgrade all formulas and casks
function brewupall() {
    for package in "$(brew outdated -q)"
    do
        brew upgrade -sv $package
    done;
    brew upgrade --greedy
}
