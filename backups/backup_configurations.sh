#!/bin/bash

# Run this file through terminal - you need to provide root password while it's running.
# Copies over the necessary "important" files to this file's location, then archives them


this_file="$(realpath "$BASH_SOURCE")" 
this_folder="$(dirname "$this_file")"

backup_date="$(date +%F_%H_%M)"
backup_base_dir="$(readlink -f -- "$this_folder/$backup_date")"
archive_name="$this_folder/$backup_date.tar.gz"
errors_log="$this_folder/${backup_date}_errors.log"

if [ ! -t 0 ]; then
    errors_log="$this_folder/${backup_date}_DID_NOT_RUN_error.log"
    echo "Failed to start. This script needs to run on terminal so it can ask for root privileges" >> "$errors_log"
    exit 1
fi

exec 2> >(tee $errors_log >&2)  # set errors into a log and also print them

# arg 1: file to copy 
function store_file () {
    echo "copying over: $1"
    local full_saved_path="${backup_base_dir}$1"
    local save_folder="$(dirname "$full_saved_path")"
    # sudo-copy (with preserved access and ownership). Some of the files are protected from copy, so might as well just use sudo on all of them
    mkdir -p "$save_folder" && sudo cp -a "$1" "$full_saved_path"
}


echo "copying into new folder: $backup_base_dir"
echo "========================================="

files_to_copy_over=(
    "$HOME/bashrc_utility_files/"
    "$HOME/styles/"
    "$HOME/Templates/"
    "$HOME/.cinnamon/"
    "$HOME/.config/"
    "$HOME/.gitkraken/"
    "$HOME/.local/"
    "$HOME/.bash_logout"
    "/etc/default/grub"
    "/etc/libvirt/"
    "/etc/systemd/"
    "/etc/X11/"
    "/etc/fstab"
)

for file in ${files_to_copy_over[@]}; do
    store_file "$file"
done


echo "archiving and removing folder."
echo "=============================="

sudo tar -C "$this_folder" -cvf "$archive_name" -z "$(basename "$backup_base_dir")" \
    && sudo chown $(id -u):$(id -g) "$archive_name" \
    && sudo rm -rf "$backup_base_dir"


echo "Checking errors log"
echo "==================="

if [[ -f "$errors_log" ]]; then
    if [[ -s "$errors_log" ]]; then
        echo "ERRORS ENCOUNTERED (showing contents of \"$errors_log\"): "
        cat "$errors_log"
    else
        echo "Errors log is empty -- deleting it."
        sudo rm -rf "$errors_log"
    fi
else
    echo "There's no error log."
fi
