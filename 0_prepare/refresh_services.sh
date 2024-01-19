#!/usr/bin/env bash

full_script_path=$(readlink -f ${BASH_SOURCE[0]})
script_dir=$(dirname ${full_script_path})


# Install systemd service files
printf "● Installing systemd definitions for hashicorp services ... \n"
cp -f ./systemd/*.service /etc/systemd/system

printf "● Adding hashicorp services to ahavi annoncements ... \n"
cp ./avahi/*.service /etc/avahi/services/

sed -i -e 's/#deny-interfaces=eth1/deny-interfaces=docker0,lo/g' /etc/avahi/avahi-daemon.conf
systemctl daemon-reload
systemctl restart avahi-daemon.service
systemctl restart dbus-org.freedesktop.Avahi
