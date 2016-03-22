#!/bin/sh

# Update apt sources.list to use local mirror
if [ ! -e "/etc/apt/apt.conf.d/10broken_proxy" ]; then
	sudo cp /vagrant/scripts/vagrant_10broken_proxy /etc/apt/apt.conf.d/10broken_proxy
fi

if [ ! -d "/opt/apt-select" ]; then
	sudo apt-get update
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git 'python(3?)-bs4$'
	sudo git clone https://github.com/GR360RY/apt-select.git /opt/apt-select
	cd /opt/apt-select
	sudo ./apt-select.py -t 3 -m one-week-behind
	if [ -e "/opt/apt-select/sources.list" ]; then
		sudo mv /etc/apt/sources.list /etc/apt/sources.list.backup
		sudo mv /opt/apt-select/sources.list /etc/apt/sources.list
		sudo apt-get update
	fi
fi
