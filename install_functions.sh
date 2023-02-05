#!/bin/bash


distro=jammy

end_messages=()



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


# use like so: install_targz_in_opt --url "https://download.jetbrains.com/python" --app_name 'pycharm-community-2022.2.3' --app_location '/opt/jetbrains' --inner_executable "bin/pycharm.sh"
function install_targz_in_opt () {
	app_name='' ; app_location='', inner_executable=''  # defaults, and clearing (in case they're set)
	while [[ $# -gt 0 ]]; do
		case "$1" in
		'--url')
			url="$2"
			shift 2
			continue
		;;
		'--app_name')
			app_name="$2"
			shift 2
			continue
		;;
		'--app_location')
			app_location="$2"
			shift 2
			continue
		;;
		'--inner_executable')
			inner_executable="$2"
			shift 2
			continue
		;;
		*)
			echo "I don't know how to handle $1"
			return
		;;
		esac
	done

	install_dir_full="${app_location}/${app_name}"

	becho "downloading: ${url}/${app_name}.tar.gz"
	wget "${url}/${app_name}.tar.gz"

	becho "extracting into: ${install_dir_full}/${app_name}"
	sudo mkdir -p "$install_dir_full"
	sudo tar xvzf "$app_name.tar.gz" -C "$install_dir_full" --strip-components=1  # strip out the folder that contains the data

	becho "Cleaning up downloaded tar file"
	rm "$app_name.tar.gz"  # clean up the tar.gz file

	# if provided an inner execution file
	if [ -n "$inner_executable" ]; then
	exe_path="${install_dir_full}/${inner_executable}"
	sudo chmod u+x "$exe_path"
	ln -s "$exe_path" "$HOME/Desktop/$app_name"  # Create a desktop shortcut for PyCharm
	fi
}



function install_deb_from_url () {
    pkg_name=$(echo "$1" | awk -F/ '{print $NF}')  # get the string after last '/'
    wget "$1" && sudo gdebi -n "./$pkg_name"  # download and install
    rm "$pkg_name"  # remove .deb file
    end_messages+=("Installed debian (.deb) package: $pkg_name. If you want to remove it, run: 'sudo dpkg -r $pkg_name'")
}


function print_end_messages () {
    echo "Installations finished. Your attention is needed for the following:"
    for i in "${end_messages[@]}"; do becho "$i" ; done
}

