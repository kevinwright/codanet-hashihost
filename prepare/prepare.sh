#!/usr/bin/env bash

E_NOTROOT=87 # Non-root exit error.

if [ "${UID:-$(id -u)}" -ne "$ROOT_UID" ]; then
    echo 'Error: root privileges are needed to run this script'
    exit $E_NOTROOT
fi

# Install pre-requisites


sudo apt-get -y update
sudo apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  wget \
  gnupg

# Clean out old docker packages

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
  sudo apt-get -y remove $pkg
done

install -m 0755 -d /etc/apt/keyrings

arch=$(dpkg --print-architecture) #e.g. amd64
release=$(. /etc/os-release && echo "$VERSION_CODENAME") #e.g. bookworm
#alt form: $(lsb_release -cs)

# Set up official docker repository
wget -O- https://download.docker.com/linux/debian/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$arch signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $release stable" > \
  /etc/apt/sources.list.d/docker.list

# Set up official hashicorp repository
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
chmod a+r /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $release main" > \
  /etc/apt/sources.list.d/hashicorp.list


# Set up official httpie repository
wget -O- https://packages.httpie.io/deb/KEY.gpg | \
  gpg --dearmor -o /usr/share/keyrings/httpie.gpg
chmod a+r /usr/share/keyrings/httpie.gpg

echo "deb [arch=$arch signed-by=/usr/share/keyrings/httpie.gpg] https://packages.httpie.io/deb ./" > \
  /etc/apt/sources.list.d/httpie.list

# Update and install all the things

sudo apt-get -y update

sudo apt-get -y install \
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
user1000=$(id -nu 1000)
usermod -a -G sudo $user1000
echo '$USER ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/sudo-without-password
echo "auth sufficient pam_succeed_if.so use_uid user ingroup sudo" >> /etc/pam.d/su

# Install systemd service files
cp ./systemd/*.service /etc/systemd/system

# Install avahi-daemon service files
cp ./avahi/*.service /etc/avahi/services/system
systemctl restart dbus-org.freedesktop.Avahi

# Docker name resolution before hitting the lan
docker_ip=$(ip -4 addr show docker0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
echo "prepend domain-name-servers $docker_ip;" >> /etc/dhcp/dhclient.conf
