#!/bin/bash

# source the nearby (file in same dir) basic installation shortcuts
source "$(dirname $0)/install_functions.sh"


#################################################################################### Service (Docker) Applications

# RustDesk Server
# instructions: https://rustdesk.com/docs/en/self-host/install/

RUST_SERVER_YML_DIR="$HOME/rustdesk-docker"
RUST_SERVER_YML_FILE="docker-compose.yml"
RUST_SERVER_YML_FILE_FULLPATH="$RUST_SERVER_YML_DIR/$RUST_SERVER_YML_FILE"

mkdir "$RUST_SERVER_YML_DIR"

read -r -d '' docker_yml << EOT
version: '3'

networks:
  rustdesk-net:
    external: false

services:
  hbbs:
    container_name: hbbs
    ports:
      - 21115:21115
      - 21116:21116
      - 21116:21116/udp
      - 21118:21118
    image: rustdesk/rustdesk-server:latest
    command: hbbs -r 127.0.0.1:21117
    volumes:
      - ./hbbs:/root
    networks:
      - rustdesk-net
    depends_on:
      - hbbr
    restart: unless-stopped

  hbbr:
    container_name: hbbr
    ports:
      - 21117:21117
      - 21119:21119
    image: rustdesk/rustdesk-server:latest
    command: hbbr
    volumes:
      - ./hbbr:/root
    networks:
      - rustdesk-net
    restart: unless-stopped
EOT

# paste into the yml file
echo "$docker_yml" > "$RUST_SERVER_YML_FILE_FULLPATH"

sudo docker-compose -f "$RUST_SERVER_YML_FILE_FULLPATH" up  # use -d to make the server run in the background

# run these in the docker container:
# ufw allow 21115:21119/tcp
# ufw allow 8000/tcp
# ufw allow 21116/udp
# sudo ufw enable

# wget https://raw.githubusercontent.com/dinger1986/rustdeskinstall/master/install.sh
# chmod +x install.sh
# ./install.sh

end_messages+=("started rustdesk server. Run: 'ip addr' to find your private IP, and put it in your RustDesk client at (ID 3 dots) > 'ID/Relay server' > 'ID Server' ")
end_messages+=("also, add a key for security (todo: instructions)")



print_end_messages
