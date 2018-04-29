## htpc-ansible

HTPC Server Automation with [Kodi](http://kodi.tv), [Deluge](http://deluge-torrent.org/) (Bittorent), [SABnzbd](http://sabnzbd.org/) (Usenet), [Radarr](https://radarr.video/), [Sickrage](https://sickrage.ca/), [Headphones](https://github.com/rembo10/headphones), [HTPC-Manager](https://github.com/Hellowlol/HTPC-Manager.git), [Tvheadend](https://tvheadend.org/) and [nzbToMedia](https://github.com/clinton-hall/nzbToMedia).

Using these roles:
  - [denics.htpc-common](https://github.com/denics/ansible-role-htpc-common)
  - [denics.htpc-nas](https://github.com/denics/htpc-ansible-htpc-nas)
  - [denics.htpc-kodi](https://github.com/denics/htpc-ansible-kodi)
  - [denics.deluge]
  - [denics.htpc-sickrage]
  - [denics.sabnzbd]
  - [denics.radarr]
  - [denics.headphones]
  - [denics.tvheadend]
  - [denics.nzbToMedia]
  - [denics.htpc-manager]

## Overview

This project is designed to deploy and configure HTPC software on Raspbian. It includes software roles, which can be set up on a single or multiple machines. All roles are customized with single configuration file, correctly deploying all the software.

All software packages are integrated together: 

* Download clients ( Deluge and Sabnzbd ) will be configured and integrated into Radarr, Sonarr and Headphones placing downloaded files into Movies, TV Shows and Music folders. 
* Kodi's will be configured with appropriate paths and new content will appear automatically in Kodi's Library. 
* Nzbtomedia will verify downloaded content and notify PVR software if to snatch another release in case the downloaded release is corrupted.
* HTPC Manager will be configured with all relevant API Keys and credentials to present a single web interface for managing Deluge, Sabnzbd, Sonarr, Radarr, Tvheadend and Kodi. 
* Media folders and downloads will be shared with LAN clients ( Windows, Linux and Mac ) over CIFS, NFS and AFP.

Downloads and Media folders layout if used with default variable values:

```
/htpc/media/             # Media path shared over NFS, CIFS and AFP
├── downloads               
│   ├── complete        # Complete Downloads for Deluge and Sabnzbd
│   └── Incomplete
│       ├── deluged     # Deluge Incomplete Downloads
│       ├── sabnzbd     # Sabnzbd Incomplete Downloads
│       └── process     # nzbtomedia processing folders
│           ├── movies
│           ├── music
|           └── tv_shows 
├── movies              # Movies path for Kodi and Couchpotato
├── music               # Music library path in Kodi
├── pictures            # Pictures path in Kodi
└── tv_shows            # TV Shows path for Kodi and Sickrage
```

Default Credentials, Settings, Paths and URLs:

* __Name Resolution__

    - Name resolution between services will be configured using ZeroConf/Bonjour.
    - HTPC will be resolvable with `hostname.lan`. Assuming the hostname of the HTPC is htpc, 
      HTPCManager will be accessible with http://htpc.lan/. To enable ZeroConf/Bonjour on Windows,
      install [Bonjour Print Services for Windows](https://support.apple.com/kb/DL999?viewlocale=en_US&locale=en_US)
      ( See customisation part to change this behaviour )
    

* __HTPC User__
    
    - All services will be run under `htpc` user identified with `htpc` password
    - Sudo access for `htpc` user will be enabled
    - SSH service will be configured to start automatically on boot

* __Media, Downloads and Network Shares__
    
    - All media and download folders will reside under `/htpc/media`
    - AFP and Samba read/write access will be available with `htpc/htpc` credentials
    - `/htpc/media` will be exported with NFS. NFS will "squash" all users to `htpc` uid

* __Kodi__ ( Server and Desktop Modes )
    
    - Kodi Web Service will be enabled on port __8080__ with user `kodi` and without a password
    - Kodi will be configured to use MySQL as a backend
    - Mysql user credentials for Kodi MySQL databases will be set to `kodi/kodi`
    - `movies`, `music` and `tv` folders will be configured with default scrappers in Kodi
    - Create hidden `/htpc/media/.kodi_client_setup` folder with `advancedsettings.xml` for configuring additional Kodi clients

* __Deluge__
    
    - Deluge-Web Daemon will be configured to listen on port __8112__
    - Deluge Daemon will be configured to listen on port __58846__
    - Default Deluge Web password will be set to `deluge`
    - `tv`, `music` and `movie` labels will be configured.
    - `nzbtomedia` postprocessing scripts will be configured for each label

* __Sabnzbd__

    - Sabnzbdplus will be configured to listen on port __9000__
    - Usenet setup will remain to be completed through configuration wizard
    - `movies`, `music` and `tv` categories will be configured
    - `nzbtomedia` postprocessing scripts will be configured for each category


* __Sickrage__ TODO 

    - Will be configured to listen on port __8081__
    - Deluge will be configured as download client
    - In "Search Providers", torrent trackers that do not require credentials will be configured
    - Sabnzbd will be configured as download client, but no Usenet "Search Providers" will be defined
    - Sickrage will sent "Rescan Library" command to Kodi on complete downloads

* __Couchpotato__ TODO

    - Will be configured to listen on port __5050__
    - Deluge will be configured as download client
    - In "Searcher", torrent trackers that do not require credentials will be configured
    - Sabnzbd will be configured as download client, but no Usenet "Searcher" will be defined
    - Couchpotato will sent "Rescan Library" command to Kodi on complete downloads

* __Radarr__

* __Sonarr__

* __Headphone__

* __HtpcManager__

    - Use Hellowlol HTPC-Manager Fork
    - Apache reverse proxy will be configured to serve HtpcManager on port 80
    - HtpcManager will be configured to listen on port __8085__


## Customizing the setup

### Install Requirements

```    
sudo apt-get -y install ansible git
```

### Clone the repository

```
git clone https://github.com/denics/htpc-ansible.git --recursive
cd htpc-ansible
```

### Edit Configuration

* Create custom configuration file:

```
cd custom
cp custom.yml.sample custom.yml
```

* Open `custom.yml` in your favorite editor and update variable values.
* Create a vault with your passwords:

```
ansible-vault create custom/vault.yml
```

* Run Ansible Playbook from your localhost:

__Server Mode:__

```
ansible-playbook -i inventory/server-headless -c local -K htpc-server.yml
```


## Development and Testing with Vagrant TODO

If you want to test out the configuration in VirtualMachine or contribute to htpc-ansible development, install requirements and follow the below guide:

### Requirements

* Install [Vagrant](http://www.vagrantup.com/)
* Install [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install [Ansible](http://docs.ansible.com/intro_installation.html)

### Deployment

Both __Server__ and __Desktop__ modes can be tested in Vagrant. Vagrantfile presents multimachine environment were only __Server__ VM will be started by default. To test __Desktop__ mode, run `vagrant up fullclient`.

```
 ~/dev/htpc-ansible ⮀ ⭠ master± ⮀ vagrant status
Current machine states:

headless                  not created (virtualbox)
fullclient                not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

* Start the VM

```
# Server
vagrant up headless --no-provision

#Desktop
vagrant up fullclient --no-provision
```

* Snapshot the machine.

```
vagrant snapshot save before_provisioning
```

* Deploying htpc-ansible

```
vagrant provision
```

* Reverting snapshot

In case you want to redeploy from scratch - simply revert the snapshot back to
the machine with desktop installed.

```
vagrant snapshot restore before_provisioning
```

#### Testing and configuring WEB services

Vagrant boxes are configured to have bridged eth1 interface.
All the web services can be tested and configured as following:

* Server Mode [http://htpc-server-vm.local/](http://htpc-server-vm.local/)
* Desktop Mode [http://htpc-vm.local/](http://htpc-vm.local/)

