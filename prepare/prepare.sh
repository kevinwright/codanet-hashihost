#!/usr/bin/env bash

full_script_path=$(readlink -f ${BASH_SOURCE[0]})
script_dir=$(dirname ${full_script_path})

printf "\n"
printf "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n"
printf "┃ Performing this machine for Hashicorp ┃\n"
printf "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
printf "\n"


E_NOTROOT=87 # Non-root exit error.

printf "● Ensuring we're root ... "

if [ "${UID:-$(id -u)}" -eq 0 ]; then
  printf "✅\n"
else
  printf "❌\n"
  printf '\t Error: root privileges are needed to run this script\n'
  exit $E_NOTROOT
fi


# Install pre-requisites
printf "● Apt-update and install pre-requisites\n"

apt-get -y update
apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  wget \
  gnupg

# Clean out old docker packages
printf "● Removing any legacy docker packages\n"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
  apt-get -y remove $pkg
done

install -m 0755 -d /etc/apt/keyrings

printf "● Determining environment ... "
arch=$(dpkg --print-architecture) #e.g. amd64
release=$(. /etc/os-release && echo "$VERSION_CODENAME") #e.g. bookworm
#alt form: $(lsb_release -cs)
printf "architecture=$arch, release=$release\n"

# Set up official docker repository
printf "● Adding official docker repository ... \n"
wget -O- https://download.docker.com/linux/debian/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$arch signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $release stable" > \
  /etc/apt/sources.list.d/docker.list

# Set up official hashicorp repository
printf "● Adding official hashicorp repository ... \n"
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
chmod a+r /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $release main" > \
  /etc/apt/sources.list.d/hashicorp.list

# Set up official httpie repository
printf "● Adding official httpie repository ... \n"
wget -O- https://packages.httpie.io/deb/KEY.gpg | \
  gpg --dearmor -o /usr/share/keyrings/httpie.gpg
chmod a+r /usr/share/keyrings/httpie.gpg

echo "deb [arch=$arch signed-by=/usr/share/keyrings/httpie.gpg] https://packages.httpie.io/deb ./" > \
  /etc/apt/sources.list.d/httpie.list

# Update and install all the things
printf "● apt-get update and install all the things ... \n"

apt-get -y update

apt-get -y install \
  unzip \
  tree \
  redis-tools \
  jq \
  tmux \
  httpie \
  uuid-runtime \
  avahi-daemon \
  avahi-utils \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  nomad \
  consul \
  consul-template \
  vault \
  terraform

# Groups and passwordless sudo
printf "● Enabling sudo without a password ... "

user1000=$(id -nu 1000)
RESULT=$?
if [ $RESULT -eq 0 ]; then
  usermod -a -G sudo $user1000
  echo '$USER ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo-without-password
  echo "auth sufficient pam_succeed_if.so use_uid user ingroup sudo" >> /etc/pam.d/su
  printf "✅\n"
else
  printf "❗️ No user exists with id 1000\n"
fi

# Install systemd service files
printf "● Installing systemd definitions for hashicorp services ... \n"
cp ./systemd/*.service /etc/systemd/system

# Install avahi-daemon service files
printf "● Adding hashicorp services to ahavi annoncements ... \n"
cp ./avahi/*.service /etc/avahi/services/
systemctl restart dbus-org.freedesktop.Avahi

# Docker name resolution before hitting the lan
printf "● Adding local docker service to internal name resolution ... \n"
docker_ip=$(ip -4 addr show docker0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
echo "prepend domain-name-servers $docker_ip;" >> /etc/dhcp/dhclient.conf

printf "\n"
printf "\n"
printf "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n"
printf "┃ Preparation is now complete                   ┃\n"
printf "┃                                               ┃\n"
printf "┃ Be sure to run this on all other applicable   ┃\n"
printf "┃ hosts before enabling services, so avahi      ┃\n"
printf "┃ announcements are available for auto-config   ┃\n"
printf "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
printf "\n"
printf "\n"

$script_dir/show_net.sh
printf "\n"
printf "\n"
$script_dir/show_peers.sh
printf "\n"
