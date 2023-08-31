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

# find all markdown files in a given directory and create markdown links from them
function md_links() {
    find "$1" -type f -name "*.md" | while read -r file_path; do
        file_name=$(basename "$file_path" .md)
        formatted_title=$(echo "$file_name" | awk '{ for(i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); } 1' | sed -E "s/(^|-)\w/\U&/g; s/-/ /g")
        echo "[$formatted_title]($file_path)"
    done 
}

