xbmc-client
===========

An ansible role to setup and configure XBMC/Kodi under Debian based distro's.

Requirements
------------

This role requires Ansible 1.6 or higher. Platform requirements are listed in the metadata file.

Overview
--------

List of tasks that will be performed under xbmc-client role:

1. Install ssh server to allow remote management.
2. Setup Linux HTPC user.
3. Configure LightDM to autlogin HTPC user and start XBMC/Kodi automatically in full screen mode.
4. Enable XBMC Internal Web Server.
5. Create Media Folders ( movies, tv, music and pictures ).

XBMC/Kodi can be configured to use Mysql Database.
Automounter can be configured to save files on external NFS storage.

Role Variables
--------------

Default vars scope with values (defaults/main.yml):

```yaml
xbmc_repo: 'ppa:team-xbmc/ppa'    # XBMC Ubuntu ppa.
media_path: /mnt/xbmc             # Location of xbmc media folders.

movies_folder: movies
tv_folder: tv
music_folder: music
pictures_folder: pictures

htpc_username: xbmc               # HTPC User that will run XBMC/Kodi
htpc_user_password: xbmc          # HTPC User Password
xbmc_enable_ubuntu_desktop: True  # Start XBMC as part of Ubuntu desktop

# Default xbmc host IP. Used by other roles.
xbmc_host: "{{ ansible_default_ipv4.address }}" 
```

Configure XBMC/Kodi to use Mysql Backend and NFS Mount

```yaml
# with Mysql Backend
xbmc_mysqldb_host:
xbmc_mysqldb_user:
xbmc_mysqldb_password:

# with external NFS NAS 
xbmc_external_nas:                
```

Helper variables aslo used in other roles (vars/main.yml):

```yaml
# When used together with other roles, make sure all services run as the same user.

deluged_user: "{{ htpc_username }}"
sabnzbd_user: "{{ htpc_username }}"
couchpotato_user: "{{ htpc_username }}"
sickbeard_user: "{{ htpc_username }}"
htpc_manager_user: "{{ htpc_username }}"
```


Dependencies
------------

This role is a part of `htpc-ansible` playbook that includes additional set of components required for HTPC automation.

The following list of roles can be used together with xbmc-client role:

- xbmc-mysql
- xbmc-nas
- sickbeard
- couchpotato
- subnzbd
- deluge
- htpc-manager
- tvheadend

Detailed info can be found following this link:

https://github.com/GR360RY/htpc-ansible


Example Playbook
----------------

Create HTPC user `foo`. Use local storage and sqlite database. Start XBMC session without Ubuntu Desktop:

```
    - hosts: xbmc-clients

      vars:
        htpc_username: foo
        htpc_user_password: bar
        xbmc_enable_ubuntu_desktop: False

      roles:
        - role: xbmc-client
```

Use MySQL Database for XBMC/Kodi media Library:

```
    - hosts: xbmc-clients
      sudo: True

      vars:
        xbmc_mysqldb_host: 10.0.0.1
        xbmc_mysqldb_user: xbmc
        xbmc_mysqldb_password: xbmc

      roles:
        - role: xbmc-client
```

Use external NFS storage for media: 

```
    - hosts: xbmc-clients
      sudo: True

      vars:
        xbmc_external_nas: 10.0.0.1
        media_path: /tank/Media

      roles:
        - role: xbmc-client
```



License
-------

BSD

Author Information
------------------

Gregory Shulov