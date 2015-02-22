xbmc-mysql
===========

An ansible role to setup and configure XBMC/Kodi Mysql Database under Debian based distro's. This role creates empty Music and Videos Databases with preconfigured media paths.


Requirements
------------

This role requires Ansible 1.6 or higher. Platform requirements are listed in the metadata file.

Role Variables
--------------

```yaml
xbmc_mysqldb_host: "{{ ansible_default_ipv4.address }}"
xbmc_mysqldb_user: xbmc
xbmc_mysqldb_password: xbmc


media_path:                 # Location of xbmc media folders.

movies_folder:
tv_folder:
music_folder:
```

Dependencies
------------

This role is a part of `htpc-ansible` playbook that includes additional set of components required for HTPC automation.

The following list of roles can be used together with xbmc-mysql role:

     - xbmc-client
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
-------------------------

```
- hosts: htpc-server

  vars:
    xbmc_mysqldb_user: xbmc
    xbmc_mysqldb_password: xbmc
    media_path: /mnt/xbmc

    movies_folder: movies
    tv_folder: tv
    music_folder: music

  roles:
    - role: xbmc-mysql
```

License
-------

BSD

Author Information
------------------

Gregory Shulov