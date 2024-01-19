#!/usr/bin/env bash

full_script_path=$(readlink -f ${BASH_SOURCE[0]})
script_dir=$(dirname ${full_script_path})


# Install systemd service files
printf "● Installing systemd definitions for hashicorp services ... \n"
cp -f ./systemd/*.service /etc/systemd/system

printf "● Adding hashicorp services to ahavi annoncements ... \n"
cp ./avahi/*.service /etc/avahi/services/

systemctl daemon-reload
systemctl restart dbus-org.freedesktop.Avahi
