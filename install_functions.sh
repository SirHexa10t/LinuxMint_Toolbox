#!/bin/bash


distro=`cat /etc/*release | grep UBUNTU_CODENAME | cut -d '=' -f 2`  # For Linux Mint 21(.1) the result is "jammy"

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

# TODO - test? (not sure if already tested)
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
			recho "${FUNCNAME[0]} doesn't know how to handle arg: '$1'"
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


# arg 1: Deb's full URL
function install_deb_from_url () {
    pkg_name=$(echo "$1" | awk -F/ '{print $NF}')  # get the string after last '/'
    wget "$1" && sudo gdebi -n "./$pkg_name"  # download and install
    rm "$pkg_name"  # remove .deb file
    end_messages+=("Installed debian (.deb) package: $pkg_name. If you want to remove it, run: 'sudo dpkg -r $pkg_name'")
}

#TODO - test
# args: --app_name <app-name> ;  --gpg_url <gpg-url> ;  --src (example: )
# use like so: install_with_gpg --app_name 'vscode' --apt_name 'code' --gpg_url 'https://packages.microsoft.com/keys/microsoft.asc' --src "https://packages.microsoft.com/repos/vscode stable main"
function install_with_gpg () {
	app_name='' ; gpg_url=''; src=''; apt_name=''  # defaults, and clearing (in case they're set)
	while [[ $# -gt 0 ]]; do
		case "$1" in
		'--app_name')
			app_name="$2"
			shift 2
			continue
		;;
		'--apt_name')
			apt_name="$2"
			shift 2
			continue
		;;
		'--gpg_url')
			gpg_url="$2"
			shift 2
			continue
		;;
		'--src')
			src="$2"
			shift 2
			continue
		;;
		*)
			recho "${FUNCNAME[0]} doesn't know how to handle arg: '$1'"
			return
		;;
		esac
	done

	# TODO - check if there's any reason to *not* use dearmor
	# TODO - check how to uninstall a gpg key
	# gpg file could be written into a file in:
	#   /etc/apt/trusted.gpg.d/  - gpg key storage. apt trusts all packages signed with these key
	#	/usr/share/keyrings/  - gpg keyrings (collections of gpg keys) storage. Other applications than apt use it
	# repository source is alway written into a file in /etc/apt/sources.list.d/

	# TODO - use a consistent format for the source file (in /etc/apt/sources.list.d/)

	if [[ "$gpg_url" == *.asc ]]; then
		gpg_file="$app_name.gpg"
		curl "$gpg_url" | gpg --dearmor > "$gpg_file"
		sudo install -o root -g root -m 644 "$gpg_file" /etc/apt/trusted.gpg.d/
		sudo sh -c "echo \"deb [arch=amd64] ${src}\" > /etc/apt/sources.list.d/$app_name.list"
		rm "$gpg_file"
	elif [[ "$gpg_url" == *.gpg ]]; then
		gpg_filename=$(echo "$gpg_url" | awk -F/ '{print $NF}')  # get the string after last '/'
		gpg_file="/usr/share/keyrings/${gpg_filename}"
		sudo curl -fsSLo "${gpg_file}" "$gpg_url"
		echo "deb [signed-by=${gpg_file} arch=amd64] ${src}" | sudo tee "/etc/apt/sources.list.d/$app_name.list"  # write into file and print to terminal
	else
		recho "${FUNCNAME[0]} can't handle $gpg_url"
		return
	fi
		
	sudo apt update
	sudo apt install "$apt_name" -y
	end_messages+=("Added gpg for '$app_name', and attempted to install: '$apt_name'")
}

function print_end_messages () {
    echo "Installations finished. Your attention is needed for the following:"
    for i in "${end_messages[@]}"; do becho "$i" ; done
}

