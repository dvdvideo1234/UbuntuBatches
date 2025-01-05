### Hardware topology
![][ref-hw]

### Official [olimex image releases][ref-oimg]

### When HDD or SSD is available for automount
1. Install monitoring `sudo apt-get install -y gnome-disk-utility`
2. List all drives `sudo fdisk -l`
```
    Disk /dev/sda: 596.18 GiB, 640135028736 bytes, 1250263728 sectors
    Disk model: WDC WD6400BPVT-6
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 4096 bytes
    I/O size (minimum/optimal): 4096 bytes / 4096 bytes
    Disklabel type: dos
    Disk identifier: 0x0bba294c
```
3. Select storage disk and create EXT4 partition: `sudo fdisk /dev/sda`
4. Format the selected partition to EXT4: `sudo mkfs -t ext4 /dev/sda1`
5. Identify UUID: `sudo blkid | grep UUID=` or `ls -l /dev/disk/by-uuid` or `sudo lsblk`
  * Example `/dev/sda1: UUID="3aa73106-944c-4c66-809f-d2b99d9c863c" TYPE="ext4"`
7. Create directory: `/mnt/Disk` and edit mount options `sudo vim /etc/fstab`
  * Example `UUID=3aa73106-944c-4c66-809f-d2b99d9c863c /mnt/Disk ext4 auto,exec,nouser,rw,async,suid,nodev,nofail,x-gvfs-show 0 0`
8. Mount the drive: `sudo mount -t ext4 /dev/sda1 /mnt/Disk` or via `/etc/fstab` `sudo mount -a`

### Move the heavy-read folders such as `home` and `var`
This can be via the [`move-link.sh`][ref-mvsh] script.
1. Copy all the contents to the new location
  * Example `rsync -va /var /mnt/Disk`
2. Create a backup copy if it fails
  * Example: `mv /var /var.old`
3. Make symbolic link `ln -s /path/to/original /path/to/link`
  * Example ( `/var` ) `sudo ln -s /mnt/Disk/var  /var`
4. Required commands for easier maintaining. Beware for `etc`!
  * When you apply this on `etc`, the `sudo` command will fail!
```
sudo mv /var.old /var
sudo mv /var /var.old
sudo rsync -va /var /mnt/Disk
sudo ln -s /mnt/Disk/var  /var

lrwxrwxrwx   1 root root      14 Jul  6 20:00 home -> /mnt/Disk/home
lrwxrwxrwx   1 root root      13 Jul  6 19:59 tmp -> /mnt/Disk/tmp
lrwxrwxrwx   1 root root      13 Jul  6 19:58 srv -> /mnt/Disk/srv
lrwxrwxrwx   1 root root      13 Jul  6 19:53 var -> /mnt/Disk/var
lrwxrwxrwx   1 root root      20 Jul  7 10:11 etc/pihole -> /mnt/Disk/etc/pihole
```

### Fix for the internet not working
* Method 1: Use Network connection GUI
1. Open VNC to [network connection][ref-ip4] with [ETH][ref-eth] device
2. Edit: `sudo vim /etc/netplan/01-netcfg.yaml`
3. The example hardware device name is `eth0`
```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: yes
      gateway4: 192.168.0.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4, 1.1.1.1, 1.0.0.1]
```
3. Run `sudo netplan generate`
4. Run `sudo netplan apply`
  * `systemctl start systemd-resolved.service`
  * `systemctl enable systemd-resolved.service`
5. Restart `shutdown -r now` or shutdown `shutdown -h now`
* Method 2: Hardcode [resolve][ref-resolve] nameservers for session
1. Edit: `sudo vim /etc/resolv.conf` and add the following:
```
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
nameserver 1.0.0.1
```
2. This file is a symbolic link of the following:
```
olimex@a20-olinuxino:/etc$ ls -ltr res*.*
lrwxrwxrwx 1 root root 39 рту 24  2019 resolv.conf -> ../run/systemd/resolve/stub-resolv.conf
```
3. To [make it permanent][ref-resolv-man] copy to `resolv.conf.manually-configured`
4. Remove the file via `rm -f /etc/resolv.conf`
5. Make new link `ln -s /etc/resolv.conf.manually-configured /etc/resolv.conf`
### Installing samba and creating shared folder
1. Navigate to `cd ~` and create folder `Share`
2. Install the server: `yes y | sudo apt-get install samba`
3. Apply the [configuration file][ref-smb-conf]: `/etc/samba/smb.conf`
4. Restart the system: `shutdown -r now`
5. Controlling the server with these connand:
  * `sudo service smbd start`
  * `sudo service smbd stop`
  * `sudo service smbd restart`
6. Now transfering files in the LAN area with Lime2 is possible
7. Refresh the packet when it is buggy:
  * Example `sudo apt-get install --reinstall samba`

### Installing `dummy` display driver
1. Supported packages for your board: `sudo apt-cache search video-dummy`
```
xserver-xorg-video-dummy - X.Org X server -- dummy display driver
xserver-xorg-video-dummy-hwe-16.04 - Transitional package for xserver-xorg-video-dummy-hwe-16.04
```
2. Install display: `yes y | sudo apt-get install xserver-xorg-video-dummy`
3. Apply the [configuration file][ref-xorg-conf]: `sudo vim /etc/X11/xorg.conf`
4. Restart the system: `shutdown -r now` for the `XORG` server to start running
5. Now the dummy video server is running

### Install x11VNC
1. Install the server by utilizing the `x11VNC` [script][ref-x11-vnc]
2. Utilize [`TightVNC`][ref-tight-vnc] to connect to the server
3. In `Remote host` write `192.168.0.XXX:<PORT>`
  * The address `192.168.0.XXX` is the internal `<IP>` of the Lime2 board
  * The value of `<PORT>` is the port you have used to install x11VNC
  * The password will be stored automatically by the installer as `<PASSWORD>`
  * Dedicated `run` script will be automatically created for the specified `<PORT>`
4. Provide to the `VNC authentication` window the `<IP>:<PORT>` and `<PASSWORD>` then click OK
5. For connecting outside of the LAN area forward the `<PORT>` in your router to `<IP>` server
6. Now you are connected to the VNC server

### Install [Pi-hole][ref-pihole]
1. Fetch PPSs and check for broken one `sudo apt-get update`
  * Example `sudo vim /etc/apt/sources.list`
2. Upgrade the distro when needed `sudo apt-get upgrade`
3. Clone the repo `git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole`
4. Change `cd "Pi-hole/automated install/"`
5. Make it executable `sudo chmod +x basic-install.sh`
6. Run installer `sudo bash basic-install.sh`
7. Import [adlists][ref-adlists], [whitelists][ref-whitelist], [blacklists][ref-blacklist] and [regex][ref-regex]
8. If it does not start you probably have to [reset something][ref-reset]

### Install [ViewPower][ref-fsp]
1. Check architecture `file /sbin/init`
```
/sbin/init: symbolic link to /lib/systemd/systemd
olimex@a20-olinuxino:~/Documents/Pi-hole/automated install$ file  /lib/systemd/systemd
/lib/systemd/systemd: ELF 32-bit LSB shared object, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, BuildID[sha1]=3ca7712fe69ab99bb55585c35af762a2491fc856, for GNU/Linux 3.2.0, stripped
```
2. Pick [x32][ref-vpx32] or [x64][ref-vpx64] text version
3. Download `wget --no-check-certificate <VERSION>`
4. Extract `tar -xvf <VERSION>`
5. Execute `sudo ./<VERSION>`
  * When error occurs
    * `/lib/libc.so.6`
      1. `find / -name libc.so.6` > `/usr/lib/arm-linux-gnueabihf/libc.so.6`
      2. `sudo ln -s /usr/lib/arm-linux-gnueabihf/libc.so.6 /lib/libc.so.6`

### When [ViewPower][ref-fsp] fails try [general software][ref-nut-tur]:
1. Install via: `sudo apt-get install nut nut-client nut-server`
2. Check usb via: `lsusb`
3. Scan USB bus via: `sudo nut-scanner -U`
4. Edit the configuration like used in the main folder
6. Check confuguration `sudo cat upsmon.conf upsd.conf ups.conf nut.conf upsd.users`

### Run [i386][ref-i386] binaries in Arm7 with [Box86][ref-box86]
This is done for migrating [UPS monitoring software][ref-ups]
Viewing the following info will decide whenever [i386][ref-ups-x32] or [x64][ref-ups-x64]
1. View the type of CPU `cat /proc/cpuinfo`
2. View other useful info: `uname -a`
3. View architecture: `dpkg --print-architecture`
4. View bits: `getconf LONG_BIT`
5. View kernal config:
```
olimex@a20-olinuxino:~$ file /usr/bin/ld
olimex@a20-olinuxino:/usr/bin$ file arm-linux-gnueabihf-ld.bfd
arm-linux-gnueabihf-ld.bfd: ELF 32-bit LSB shared object, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter
/lib/ld-linux-armhf.so.3, BuildID[sha1]=406e7704e457810576aeffacd33a0ffe5775e244, for GNU/Linux 3.2.0, stripped
```
6. When LONG_BIT is `32` install Box86 by using [i386][ref-box86-install] script.

### Synchronizing the image clock
0. Execute current directory [time.sh][ref-time] in the terminal.

[ref-tight-vnc]: https://www.tightvnc.com/
[ref-x11-vnc]: https://github.com/dvdvideo1234/UbuntuBatches/tree/master/x11VNC
[ref-hw]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/Pics/hw.jpg
[ref-smb-conf]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/Conf/smb.conf
[ref-xorg-conf]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/Conf/xorg.conf
[ref-eth]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/Pics/eth.jpg
[ref-ip4]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/Pics/ip4.jpg
[ref-time]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/Scripts/time.sh
[ref-mvsh]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/Scripts/move-link.sh
[ref-pihole]: https://pi-hole.net/
[ref-i386]: https://pimylifeup.com/raspberry-pi-x86/
[ref-fsp]: https://energy.fsp-europe.com/software/
[ref-ups-x32]: https://www.power-software-download.com/viewpower/installViewPowerHTML_Linux_text_i386.tar.gz
[ref-ups-x64]: https://www.power-software-download.com/viewpower/installViewPowerHTML_Linux_text_x86_64.tar.gz
[ref-box86]: https://github.com/ptitSeb/box86
[ref-box86-install]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/Scripts/i386-support.sh
[ref-resolve]: https://man7.org/linux/man-pages/man5/resolv.conf.5.html
[ref-oimg]: http://images.olimex.com/release/
[ref-adlists]: https://github.com/dvdvideo1234/UbuntuBatches/blob/master/Olimex-A20/PI-Hole/adlist
[ref-blacklist]: https://github.com/dvdvideo1234/UbuntuBatches/blob/master/Olimex-A20/PI-Hole/blacklist
[ref-whitelist]: https://github.com/dvdvideo1234/UbuntuBatches/blob/master/Olimex-A20/PI-Hole/whitelist
[ref-regex]: https://github.com/dvdvideo1234/UbuntuBatches/blob/master/Olimex-A20/PI-Hole/regex
[ref-reset]: https://github.com/dvdvideo1234/UbuntuBatches/blob/master/Olimex-A20/PI-Hole/reset.sh
[ref-resolv-man]: https://github.com/dvdvideo1234/UbuntuBatches/blob/master/Olimex-A20/Scripts/resolv-perm.sh
[ref-nut-tur]: https://www.youtube.com/watch?v=vyBP7wpN72c
