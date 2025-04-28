#!/bin/bash
#mygrep script to mimc grep command
# usage: mygrep [-opt] pattern filename
help() {
    echo "Usage: $0 [-v] [-n] pattern filename"
    echo "Options:"
    echo "  -v      Invert match (show non-matching lines)"
    echo "  -n      Show line numbers"
    echo "  -h      Display this help message"
    exit 1
}
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    help
fi

# set variable for getopts
line_number=0
invert=0
while getopts ":vn" opt; do
    case $opt in
        v)
            invert=1
            ;;
        n)
            line_number=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            echo " use -h for help"
            exit 1
            ;;
     
    esac
done
shift $((OPTIND-1))
# set pattern and filename
pattern=$1
filename=$2
#checking arguments validation
if [ $# -lt 2 ]; then
    if [ -f "$pattern" ]; then
        echo "Error: Missing search pattern."
        echo "use -h for help" 
        exit 1
    else
        echo "Error: Missing filename."
        echo "use -h for help"
        exit 1
    fi
    echo "Error: Missing arguments."
    echo "use -h for help"
    exit 1
fi
# check if pattern is a file
if [ $# -eq 2 ]; then
    if [ ! -f "$filename" ]; then
        echo " file $filename not found"
        
    fi
fi
# use awk to search for pattern in file
if [ $invert -eq 1 ]; then
    if [ $line_number -eq 1 ]; then
        awk -v pattern="$pattern" 'BEGIN{IGNORECASE=1} !($0 ~ pattern) {print NR, $0}' "$filename"
    else
        awk -v pattern="$pattern" 'BEGIN{IGNORECASE=1} !($0 ~ pattern)' "$filename"
    fi
else
    if [ $line_number -eq 1 ]; then
        awk -v pattern="$pattern" 'BEGIN{IGNORECASE=1} ($0 ~ pattern) {print NR, $0}' "$filename"
    else
        awk -v pattern="$pattern" 'BEGIN{IGNORECASE=1} ($0 ~ pattern)' "$filename"
    fi
fi
# end of script
