#### ** WIP - Not Complete but should be workable**

A headless install of kodi in a docker container, most useful for a mysql setup of kodi to allow library updates to be sent without the need for a player system to be permanently on.

Modified to be a script to run outside of docker for an LXC container (or a VM or bare metal)

## Usage

```
git clone https://github.com/thiscodedbox/docker-kodi-headless.git
./khead_nodocker.sh
```

Modify the variables in the bash script, only tested with Leia

Put your SQL settings into advancedsettings.xml
Grab your sources.xml from your machine you built your library with
if they're password'd shares (SMB for example) make a passwords.xml in the same folder in this format:

```
<passwords>
    <path>
        <from pathversion="1">smb://BigBOX/video/Movies/</from>
        <to pathversion="1">smb://user:pass@BigBOX/video/Movies/</to>
    </path>
    <path>
        <from pathversion="1">smb://BigBOX/video/TV Shows/</from>
        <to pathversion="1">smb://user:pass@BigBOX/video/TV Shows/</to>
    </path>
</passwords>
```

#### Tags
+ **Helix**
+ **Isengard**
+ **Jarvis**
+ **Krypton**
+ **Leia** : current default branch.


**No Parameters?!**

Designed for Ubuntu Bionic 18.04 LTS, only tested in an LXC container on Proxmox with the Ubuntu 18.04 LTS Template.

## Setting up the application

Mysql/mariadb settings are entered by editing the file advancedsettings.xml which is found in the userdata folder of your /config/.kodi mapping. Many other settings are within this file also.

The default user/password for the web interface and for apps like couchpotato etc to send updates is kodi/kodi.

If you intend to use this kodi instance to perform library tasks other than merely updating, eg. library cleaning etc, it is important to copy over the sources.xml from the host machine that you performed the initial library scan on to the userdata folder of this instance, otherwise database loss can and most likely will occur.

Rar integration with the Leia branch is now handled by an addon,
it is compiled with this build, but you will need to enable it, if required, in the settings section of the webui.

## Autostart Kodi

Per [RigacciOrg](https://github.com/RigacciOrg) in a comment, create this /etc/systemd/system/kodi.service unit file:
```
[Unit]
Description = Kodi Media Center

# if you don't need the MySQL DB backend, this should be sufficient
After = systemd-user-sessions.service network.target sound.target

# if you need the MySQL DB backend, use this block instead of the previous
# After = systemd-user-sessions.service network.target sound.target mysql.service
# Wants = mysql.service

[Service]
User = kodi
Group = kodi
Type = simple
ExecStart = /usr/bin/kodi-standalone
Restart = always
RestartSec = 15

[Install]
WantedBy = multi-user.target
```


To install, enable and run the service:
```
systemctl daemon-reload
systemctl enable kodi.service
systemctl start kodi.service
```
The kodi user was created witht the following commands:
```
adduser --disabled-password --gecos "User to run Kodi Media Center" kodi
adduser kodi audio
adduser kodi video
adduser kodi plugdev
adduser kodi input
```

## Credits
For inspiration, and most importantly, the headless patches without which none of this would have been possible. 

+ [Celedhrim](https://github.com/Celedhrim)
+ [sinopsysHK](https://github.com/sinopsysHK)
+ [wernerb](https://github.com/wernerb)
+ [linuxserver](https://github.com/linuxserver)
+ [RigacciOrg](https://github.com/RigacciOrg)

Various other members of the xbmc/kodi community for advice.

## (docker) Versions

+ **07.01.20:** Bump Leia to 18.5.
+ **23.06.19:** Bump Leia to 18.4.
+ **23.04.19:** Bump Leia to 18.2.
+ **09.03.19:** Build vfs.libarchive and vfs.rar addons.
+ **08.03.19:** Make Leia default branch, using patched "headless" build.
+ **30.01.19:** Bump Leia branch to release ppa.
+ **03.09.18:** Add back libnfs dependency.
+ **31.08.18:** Rebase to ubuntu bionic, use buildstage and add info about websockets port.
+ **04.01.18:** Deprecate cpu_core routine lack of scaling.
+ **14.12.17:** Fix continuation lines.
+ **17.11.17:** Bump Krypton to 17.6.
+ **24.10.17:** Bump Krypton to 17.5.
+ **22.08.17:** Bump Krypton to 17.4.
+ **25.05.17:** Bump Krypton to 17.3.
+ **23.05.17:** Bump Krypton to 17.2.
+ **23.04.17:** Refine cmake, use cmake ppa and take out uneeded bootstrap line.
+ **22.02.17:** Switch to using cmake build system.
+ **22.02.17:** Bump Krypton to 17.1.
+ **22.02.17:** Change default webui user/pw to kodi/kodi.
+ **05.02.17:** Move Krypton to default branch.
+ **20.09.16:** Add kodi-send and fix var cache samba permissions.
+ **10.09.16:** Add layer badge to README..
+ **02.09.16:** Rebase to alpine linux.
+ **13.03.16:** Make kodi 16 (jarvis) default installed version.
+ **21.08.15:** Initial Release.
