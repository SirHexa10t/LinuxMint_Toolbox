#!/bin/bash

# source the nearby (file in same dir) basic installation shortcuts
source "$(dirname $0)/install_functions.sh"


#################################################################################### system and os utilities
sudo apt update
sudo apt install software-properties-common apt-transport-https curl wget ca-certificates gnupg2 -y

# swap is not supported in BTRFS.
# # set up swap (Always allocate a bit of memory for swapfile. Even if you have a lot of memory - it's useful when there's a memory leak, and some program access it regardless.)
# sudo fallocate -l 2G /swapfile
# sudo chmod 600 /swapfile  # only root should access swapfile
# sudo mkswap /swapfile  # mark as space
# # you need to have this in /etc/fstab: "/swapfile		none	swap	sw	0	0"
# end_messages+=("Check visually that swap space is available. Run: free -h")


# ppa-purge
sudo apt-get install ppa-purge  -y

# nala - apt, but prettier
sudo apt install nala -y

# .deb files handler
sudo apt install gdebi -y

# a terminal pane-arranger and session keeper
sudo apt install tmux -y

# a tool that simulates mouse/keypresses
# sudo apt install xdotool -y

# like nano but better. If you're not restricted to the terminal (and the data isn't, such as results from "man"), just use Xed.
# sudo apt install micro -y 

# manage gpg keyrings
sudo apt install dirmngr

# Encryption of personal data
sudo apt install keepassxc -y

# virtual machine manager
end_messages+=("QEMU setup isn't covered by this script because it's too hands-on, and includes a restart in the middle.")

# disk capacity check
sudo apt install f3 -y

# VPN (NordVPN)
# sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
# rm nordvpn-release*  # their online installation script is great, but (sometimes?) leaves behind this file.

# GUI config and session saver
sudo apt-get install dconf-editor

# # tool for monitoring system events
# sudo apt install inotify-tools -y

# GitKraken (Graphical Git manager)
install_deb_from_url "https://release.gitkraken.com/linux/gitkraken-amd64.deb"

# man-like package, explains packages shortly (example: tldr ls)
sudo apt install tldr -y
tldr -u  # update manuals

# TODO - remove?
# Connect via SMB (for NAS usage)
sudo apt-get install cifs-utils -y
# Connect via NFS (for NAS usage)
sudo apt install nfs-common -y

# visual appeal
sudo apt install cmatrix -y  # run "cmatrix" to display a matrix-like animation in your terminal
sudo apt install oneko -y # run "oneko" to have a kitten chase your mouse around

# TODO - install that graphical resource / device thing with split panes for terminal (forgot its name)

#################################################################################### Runtimes and SDKs
# Java Development Kit
sudo apt install openjdk-19-jdk -y
end_messages+=("Installed java, run 'java --version' to check that it's the right version")

# should already have a recent version of python (run "python3 --version" if you're unsure for some reason)
sudo apt install python3-pip -y

# python project dependencies manager
pip3 install poetry

# NodeJS 18
sudo apt update
# curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs
# sudo apt install gcc g++ make


# Yarn version 1
sudo npm install --global yarn


# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


#################################################################################### editors

# sublime-text
# sudo apt install sublime-text -y  # might already be installed  # TODO - maybe delete


# install VSCodium    # Don't install Visual Studio Code itself, it has Telemetry. Unless you're a .Net developer, then you'll probably need some proprietary features. 
wget https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg 
sudo mv pub.gpg /usr/share/keyrings/vscodium-archive-keyring.asc
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.asc ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update
sudo apt install codium -y # codium-insiders


# At least as of 2022-12-31, JetBrains Fleet isn't worth installing.
# It doesn't have the advanced caret options of their established IDEs, some different or missing keyboard shortcuts, no markdown preview, worse coloring and marking than VS Code's (for bash and txt)
## install JetBrains Fleet - general code editor  - for now only accessible through Toolbox
# install_targz_in_opt --url "https://download.jetbrains.com/toolbox" --app_name 'jetbrains-toolbox-1.27.2.13801' --app_location '/opt/jetbrains'  # install jetbrains "toolbox"


# install Krita (photoshop-like image editing)
sudo apt install krita -y

# install gimp (good paint replacement for quick edits)
# You should actually install from AppImage, for substantially better performance.
	# TODO - revise installations accordingly (investigate which other apps run faster through other installations)
sudo apt install gimp -y


#################################################################################### Creative Workspace

# Blender (3D modeling)
sudo apt install blender -y


#################################################################################### IDEs
# Get the direct-download link of JetBrains product by checking the "direct link" in an IDE's download page (such as:  https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=linux&code=PCC  )
# PyCharm (Python) - Professional/Community
install_targz_in_opt --url "https://download.jetbrains.com/python" --app_name 'pycharm-community-2022.3.2' --app_location '/opt/jetbrains' --inner_executable "bin/pycharm.sh"
sudo ln -s /opt/jetbrains/pycharm-community-2022.3.2/bin/pycharm.sh /usr/local/bin/pycharm

# IntelliJ IDEA (Java , and some others) - Community
install_targz_in_opt --url "https://download.jetbrains.com/idea" --app_name 'ideaIC-2022.3.2' --app_location '/opt/jetbrains' --inner_executable "bin/idea.sh"
sudo ln -s /opt/jetbrains/ideaIC-2022.3.2/bin/idea.sh /usr/local/bin/intellij-idea

# Android Studio
sudo apt-add-repository ppa:maarten-fonville/android-studio -y
sudo apt update
sudo apt install android-studio -y


#################################################################################### Browsers
# Brave
install_with_gpg --app_name 'brave-browser-release' --apt_name 'brave-browser' --gpg_url 'https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg' --src "https://brave-browser-apt-release.s3.brave.com/ stable main"
end_messages+=("Create a desktop shortcut for Brave browser, sync your browser account and configure everything in it")

# TODO - try to use "install with gpg" too
# Libre Wolf
wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF
sudo apt update
sudo apt install librewolf -y
end_messages+=("Create a desktop shortcut for Librewolf browser, sync your browser account and configure everything in it. Also install adblocker and some other plugins")


#################################################################################### Remote Access / Share

# service for accessing this computer remotely
sudo apt install openssh-server -y

# Screen-sharing user-client (like TeamViewer) - RustDesk
install_deb_from_url "https://github.com/rustdesk/rustdesk/releases/download/1.1.9/rustdesk-1.1.9.deb"


#################################################################################### Handling Microsoft stuff

# links info display - use like this:  lnkinfo <path-to-lnk-file>
sudo apt install liblnk-utils -y

# installing OnlyOffice; https://helpcenter.onlyoffice.com/installation/desktop-install-ubuntu.aspx
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /etc/apt/trusted.gpg.d/
echo 'deb https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list
sudo apt-get update
sudo apt install onlyoffice-desktopeditors -y	 # requires accepting EULA manually

# Microsoft (Office) core fonts (should be provided with OnlyOffice, but probably won't be there in LibreOffice)
sudo apt install msttcorefonts -y

# Converter from CRLF to LF (line ends) - use like this:  dos2unix <filename>
sudo apt install dos2unix -y

# codecs and runtime support for various things
# sudo apt install ubuntu-restricted-extras -y  # needs agreeing manually. For now not necessarily needed; maybe install in the future

# tool for reading dynamic disks (NTFS disks that span into a single one, like RAID 0). reference: https://stackoverflow.com/questions/8427372/windows-spanned-disks-ldm-restoration-with-linux
sudo apt install ldmtool -y
end_messages+=("LDMTool installed. Run \"sudo ldmtool create all\" (put that in systemd to automate it), search dir /dev/mapper/ and mount with:  \"mount -t ntfs /dev/mapper/<volume_name>\".")

# ntfs-3g driver
sudo apt install ntfs-3g
echo "ntfs-3g" | sudo tee -a /etc/filesystems


#################################################################################### Handling Adobe stuff

# PDF tool. To merge pdf files together, run: "pdftk <files> cat output merged.pdf" where 'files' are filenames separated by spaces
sudo apt install pdftk -y

# PDF signing tool. Use like this: xournal <pdf_filepath>
sudo apt install xournal


#################################################################################### Android utilities
# Android screen recording (even screens that won't let you screenshot), also control from pc
# connect your device (with USB-debugging on), use file-transfer mode, and on the PC side run: "scrcpy -r nameyourfile.mp4" - it'll save all screen activity to your homedir
sudo apt install scrcpy -y


#################################################################################### Chatting/Social applications
# Signal
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop
rm signal-desktop-keyring.gpg
end_messages+=("Pin Signal to taskbar and connect it to your phone's account")

# Element (Matrix network. Has bridging capabilities including for Discord)
sudo apt install -y wget apt-transport-https
sudo wget -O /usr/share/keyrings/riot-im-archive-keyring.gpg https://packages.riot.im/debian/riot-im-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/riot-im-archive-keyring.gpg] https://packages.riot.im/debian/ default main" | sudo tee /etc/apt/sources.list.d/riot-im.list
sudo apt update
sudo apt install element-desktop -y

# Element bridge to Discord ( https://matrix.org/bridges/#discord ) specifically "matrix-appservice-discord"
# note: requires NodeJS 18 and Yarn version 1 / Classic
app_location='/opt/matrix_discord_bridge/'
app_dl_name='v3.1.0'
app_name='matrix-appservice-discord-3.1.0'
wget "https://github.com/matrix-org/matrix-appservice-discord/archive/refs/tags/$app_dl_name.tar.gz"
sudo mkdir -p "$app_location"
sudo tar xvzf "$app_dl_name.tar.gz" -C "$app_location"
rm "$app_dl_name.tar.gz"
cd "${app_location}${app_name}/"
sudo yarn  # grab dependencies
sudo cp config/config.sample.yaml config.yaml
# Using matrix.org arbitrarily. Lists of other domains: https://tatsumoto-ren.github.io/blog/list-of-matrix-servers.html , https://joinmatrix.org/servers/
sudo sed -i 's|domain: "localhost"|domain: "matrix.org"|g' config.yaml
sudo sed -i 's|homeserverUrl: "http://localhost:8008"|homeserverUrl: "http://matrix.org:8008"|g' config.yaml
sudo sed -i "s|adminMxid: '@admin:localhost'|adminMxid: '@matthew:matrix.org'|g" config.yaml
sudo node build/src/discordas.js -r -u "http://localhost:9005" -c config.yaml
cd "$HOME"


#################################################################################### games

# Steam
sudo add-apt-repository multiverse
sudo apt update -y
sudo apt install steam -y

#################################################################################### media encoding/handling

# video operations
sudo apt install ffmpeg -y

# screen video capture
# alternatives: SimpleScreenRecorder OBS (Open Broadcaster Software), EasyScreenCast (GNOME tool), vokoscreen, RecordMyDesktop
sudo apt install kazam -y
end_messages+=("Piper is installed. When using it, change the output format to mp4 or (preferrably) webm. The recording can be stopped via the task-menu icon")


# TODO - remove? Generally contemplating between  gmusicbrowser, amarok, or quodlibet.  quodlibet is (supposedly) able to play music from within archives, and browse entire playlist folders as one...
# TODO - go through:  https://alternativeto.net/software/foobar2000/?platform=linux
# music library
sudo add-apt-repository ppa:lazka/ppa
sudo apt-get update -y
sudo apt-get install quodlibet -y


#################################################################################### drivers

# Mouse (G502) Calibration program
sudo apt update
sudo apt install piper -y

end_messages+=("Piper is installed. Mouse profiler should have the configs: G7: Volume-Down , G8: Volume-Up , G-Shift: CTRL+ALT+T (launch terminal)")

# Keyboard profiling (corsair)
sudo apt install ckb-next -y


# # Application profile matching. Or more accurately: hardware (mainly mice) configuration service
# apt install ratbagd -y
# sudo systemctl daemon-reload  # might not be necessary
# sudo systemctl reload dbus.service  # might not be necessary
# sudo systemctl enable ratbagd.service  # might not be necessary
# sudo systemctl restart ratbagd.service  # might not be necessary - I added this just because the previous ones seem useless without restarting the service, no?

# nvidia driver - just install from the drivers manager. Installation of the "open" version of drivers failed for me...
# sudo apt update
# sudo apt install dirmngr ca-certificates software-properties-common gnupg gnupg2 apt-transport-https -y
# sudo gpg --no-default-keyring --keyring /usr/share/keyrings/graphic-drivers-ppa.gpg --keyserver keyserver.ubuntu.com --recv-keys 2388FF3BE10A76F638F80723FCAE110B1118213C
# echo "deb [signed-by=/usr/share/keyrings/graphic-drivers-ppa.gpg] https://ppa.launchpadcontent.net/graphics-drivers/ppa/ubuntu  $distro main" | sudo tee -a
# echo "deb-src [signed-by=/usr/share/keyrings/graphic-drivers-ppa.gpg] https://ppa.launchpadcontent.net/graphics-drivers/ppa/ubuntu  $distro main" | sudo tee -a 
# sudo apt update
# # ubuntu-drivers devices  # check the recommended drivers (installed by default in the following command)
# # following command is broken, as mentioned here: https://askubuntu.com/questions/1436601/ubuntu-drivers-unboundlocalerror-local-variable-version-referenced-before-as
#   # the fix is going to "/usr/lib/python3/dist-packages/UbuntuDrivers/detect.py" and replacing "version = int(package_name.split('-')[-1])" with "version = int(package_name.split('-')[-2])"
#     # i.e. place a -2 instead of -1
# sudo ubuntu-drivers autoinstall
# # old commands:
# # sudo apt list nvidia-driver-*
# #	choose one of the versions
# #sudo apt install -y nvidia-driver-510-server --no-install-recommends
# # sudo apt install -y nvidia-driver-520-open
# # sudo apt install nvidia-utils-520
# #sudo reboot
# #	validate: 
# #sudo nvidia-smi
end_messages+=("Nvidia driver isn't covered by this installation script (yet). Get it from the Driver Manager")


# Unigine "superposition" benchmark ( https://benchmark.unigine.com/superposition )
# app_location="/opt/unigine/"  # leave the installation at HOME until you figure out how to move the launcher it adds to START menu
app_dl_name='Unigine_Superposition-1.1.run'
wget  "https://assets.unigine.com/d/${app_dl_name}"
chmod u+x "$app_dl_name"
"./${app_dl_name}"  # they always extract to $HOME
sudo rm ${app_dl_name}  # cleanup
# sudo mkdir -p "$app_location"
# sudo mv Unigine* "$app_location"  # putting it where it *should* be
end_messages+=("Downloaded Unigine Superposition-1.1 ; Check in their site if that's indeed the latest version (see via their download link)")



#################################################################################### Docker
sudo apt update
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $distro stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# cat /etc/apt/sources.list.d/docker.list
sudo chmod a+r /etc/apt/keyrings/docker.gpg  # make sure umask is correct
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose -y


# Docker GUI manager. This installs Docker Desktop, but there's also Portainer and Rancher
install_deb_from_url "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.16.2-amd64.deb"


# -------------------------------------------------------------------------------- debloat system
# sudo apt-get remove --purge libreoffice* -y

sudo apt-get clean
sudo apt-get autoremove




# -------------------------------------------------------------------------------- ended installations


print_end_messages


# TODO - qbittorrent


# https://alternativeto.net/  # you can lookup windows-program alternatives here

# Flatpak and AppImage are generally faster than snap / apt. Source: https://www.youtube.com/watch?v=OftD86RgAcc
#     There are exceptions. KdenLive renders much faster through apt/dnf.

# TODO - install zsh, use it for shell instead of /bin/bash
#   install extension "ohmyzsh":  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# TODO - maybe install Nix package manager
#   sh <(curl -L https://nixos.org/nix/install) --daemon
#   echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"  # run commands easier and search for packages locally with "nix search nixpkgs <pkg>"
#     alternatively use the webpage: https://search.nixos.org/packages  - it contains installation commands for packages too

# TODO - tiling window managers
#   "awesome" - highly customizable and works great if you know LUA
#   qtile
#   i3 is easy to get into


# TODO - add ranger
# trash-cli / rm-trash  -  trash gives you cli for handling recycle bin , rm-trash is rm (same api) but to recycle bin rather than immediate delete
# midnight commander ("mc")- alternative to ranger
# TODO - if you need a lot of disk-space centered file management: ncdu or gdu

# autojump - use by typing "j <abbreviations>" to jump to your desired location; it'll find your desired path. (destinations are weighted by their usage)
  # very similar to zoxide (use z instead of j). Need to see which is better


# TODO - install doas ?

# speedtest-cli - run "speedtest" to check internet speeds

# Rust applications
# TODO - install exa ? (ls, but more colorful)
# TODO - install "bat" ? (cat, but colorized)
# Similarly there's RipGrep replacing grep, FD replacing find, procs instead of ps.

# magick - image format converter
# gifgen - turn videos to gifs

# Terminal gui-like
# bpytop (general overview like htop, but more graphical and covers a bit more facets)
  # btm (bottom) - like top, but has usage graphs. Type "?" while running to see command-keys
# eDEX-UI - hacker-style terminal file-browser
# mapscii - world map in ascii; has zoom in/out functionality


# most - adds color to "man" command. Requires: export PAGER=most

# wikit - get wikipedia definition of a word

# joplin - markdown text editor
  # marktext - handles markdown text (specially)
  # Obsidian - handles markdown too, but also does a lot more; organizes your files into categories for you
  # NeoVim - vim-styled editor  # run "vimtutor" to learn vim in 30m
  #   NvChad - basically VSCode on NeoVim
  #   LunarVIM - similar to NvChad


# ardour - audio editing
# obs - video editing
# Blender - 3D editor and animation creator
  # FreeCAD - create 3D models
# QGIS - map creation / editor
# Inkscape - Adobe Illustrator replacement


# OpenRGB - custom RGB lighting management

# Gaming:
# Goverlay - stats overlay on top of games (Like Afterburner+RivaRuner do) + performance result graphs
# WINE - windows emulator
# Lutris - a program that could help you run some problematic games on WINE 
# Proton (flatpack: ProtonUp-Qt) - valve's virtualization layer with combalibility features for WINE. You can download several versions of libraries, for support of different games


# internet-service clients:
# mailspring - email client
# Fluent RSS Reader - get rss from your news sites
# LBRY - get subscription-content from various video sites


# if you're on KDE (sometimes not required):
# KDE Connect - phone-desktop connection (wireless) - send files over, use phone interface for input
# kate - text editor
# mpv, aka celluloid - media player
# FireDragon - browser based on LibreWolf  # install ublock origin on it  # configure it - prevent WebRTC from leaking local IP addresses
# Okular (viewing PDFs)

# Flatpack: Grub Customizer - a GUI editor for GRUB (choose default Boot mode of your OS, menu options, waiting time)
