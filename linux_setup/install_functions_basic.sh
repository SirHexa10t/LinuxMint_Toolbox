#!/bin/bash


# The following colors are in bright colors, assuming you're a man of culture who uses a dark terminal. If not, remove the "\033[1m" prefix in those functions
# echoes in red. Just an aesthetic thing.
function recho () {
	echo -e "\033[1m\033[31m${@}\033[0m"
}
# echoes in green. Just an aesthetic thing.
function gecho () {
	echo -e "\033[1m\033[32m${@}\033[0m"
}
# echoes in blue. Just an aesthetic thing.
function becho () {
	echo -e "\033[1m\033[34m${@}\033[0m"
}
# echo into error output
function errcho () {
    recho "$@" >&2
}

# adds y/n prompt. Call like this:  if prompt_yn "<prompt q>?"; then echo "<starting-process msg>"; else echo "<cancellation msg>" && return ; fi
function _prompt_yn() {   
    response=""
    # keep prompting the user until they provide a valid response
    while [ "$response" != "y" ] && [ "$response" != "n" ]; do
        # prompt the user for a yes/no response
        read -p "$1 [Y/n] " response
        case "$response" in
            y|Y ) return 0 ;;  # if the response is "y", return a boolean value indicating success
            n|N ) return 1 ;;  # if the response is "n", return a boolean value indicating failure
            *) echo "just type y or n" ;;  # if the response is anything else, print an error message and continue prompting
        esac
    done
}


