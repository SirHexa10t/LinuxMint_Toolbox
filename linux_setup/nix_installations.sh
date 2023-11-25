#!/bin/bash

# args:
# -f : don't ask, just install


# source the nearby (file in same dir) basic installation shortcuts
source "$(dirname $0)/install_functions_basic.sh"

SKIP_PROMPTS=''
[[ "$@" =~ ^"-f"$ ]] && SKIP_PROMPTS='true'

function get_approval () {
    if [ -n "$SKIP_PROMPTS" ] || _prompt_yn "$@" ;
    then return 0
    else return 1
    fi
}


#################################################################################### system and os utilities

if [ -z "$(which nix)"]; then  # if nix isn't installed
    if get_approval "Can I install the Nix package manager in your system?"; then
        sh <(curl -L https://nixos.org/nix/install) --daemon  # install multi-user
        [ "$?" -eq "1" ] && { sh <(curl -L https://nixos.org/nix/install) --no-daemon ; }  # if it failed (possibly because of lack-of-support for selinux) install single-user
    
        # configure nix
        mkdir "$HOME/.config/nix"
        echo "experimental-features = nix-command flakes" | tee -a "${HOME}/.config/nix/nix.conf" >/dev/null 2>&1 || true  # insert this line / definition, even if the file doesn't exist
    else
        recho "If you won't allow me to install Nix package manager, the rest of this script is pointless. Quitting..."
        return
    fi
fi

. "$HOME/.nix-profile/etc/profile.d/nix.sh"  # TODO - this is the path for single-user. Check for multi. And put in PATH.
nix-channel --update

if get_approval "Would you like to install TimeShift (BTRFS snapshotting/"restore-point" for your filesystem)?"; then
    nix-env -iA nixpkgs.timeshift
fi


# example:
# nix-env -i obs-studio


