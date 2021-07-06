### Hardware topology
![][ref-hw]

### Fix for the internet not working
0. Open VNC to [network connection][ref-ip4] with [ETH][ref-eth] device
1. Edit: `sudo vim /etc/netplan/01-netcfg.yaml`
```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0: # The harware ETH device name stays here
      dhcp4: true
```
2. Run `sudo netplan generate`
3. Run `sudo netplan apply`
4. Restart the system: `sutdown -r now`

### Installing samba and creating shared folder
1. Navigate to `cd ~` and create folder `Share`
2. Install the server: `yes y | sudo apt-get install samba`
3. Apply the [configiration file][ref-smb-conf]: `/etc/samba/smb.conf`
4. Restart the system: `shutdown -r now`
5. Controlling the server with these connand:
  * `sudo service smbd start`
  * `sudo service smbd stop`
  * `sudo service smbd restart`
6. Now transfering files in the LAN area with Lime2 is possible

### Installing `dummy` display driver
1. Supported packages for your board: `sudo apt-cache search video-dummy`
```
xserver-xorg-video-dummy - X.Org X server -- dummy display driver
xserver-xorg-video-dummy-hwe-16.04 - Transitional package for xserver-xorg-video-dummy-hwe-16.04
```
2. Install display: `yes y | sudo apt-get install xserver-xorg-video-dummy`
3. Apply the [configiration file][ref-xorg-conf]: `sudo vim /etc/X11/xorg.conf`
4. Restart the system: `sutdown -r now` for the `XORG` server to start running
5. Now the dummy video server is running

### Install x11VNC
1. Install the server by utilizing the `x11VNC` [script][ref-x11-vnc]
2. Utilize [`TightVNC`][ref-tight-vnc] to connect to the server
3. In `Remote host` write `192.168.0.XXX:<PORT>`
  * The address `192.168.0.XXX` is the internal `<IP>` of the Lime2 board
  * The value of `<PORT>` is the port you have used to install x11VNC
  * The password will be stored automatically by the installer as `<PASSWORD>`
  * Dedicated `run` script will be automatically created for the specified `<PORT>`
4. Provide to the `VNC autentication` window the `<IP>:<PORT>` and `<PASSWORD>` then click OK
5. For connecting outside of the LAN area forward the `<PORT>` in your router to `<IP>` server
6. Now you are connected to the VNC server

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
3. Select storage disk and create NTFS partition: `sudo fdisk /dev/sda`
4. Format the selected partition to NTFS: `sudo mkfs.ntfs -f -Q /dev/sda1`
5. Identify UUID: `sudo blkid | grep UUID=` or `ls -l /dev/disk/by-uuid` or `sudo lsblk`
  * Example `/dev/sda1: UUID="<UUID>" PTTYPE="dos" PARTUUID="..."`
6. Obtain user ID: `sudo grep ^"$USER" /etc/group`
  * Example `<USER>:x:1000:`
7. Create directory: `/mnt/Disk` and edit mount options `sudo vim /etc/fstab`
  * Example `/dev/disk/by-uuid/689DAE640F0A2A91 /mnt/Disk auto rw,user,uid=1000,suid,nodev,nofail,exec,x-gvfs-show 0 0`
8. Mount ( auto ) the drive: `sudo mount -t ntfs /dev/sda1 /mnt/Disk` or via `/etc/fstab` `sudo mount -a`

### Move the heavy-read folders such as `home` and `var`
This can be done by utilizing the [`move-link.sh`][ref-mvsh] script.
1. Created data folder with the same name somewhere else
2. Copy all the contents to the new location
3. Make symbolic link `ln -s /path/to/original /path/to/link`
  * Example (/etc/var ) `ln -s /mnt/Disk/var  /etc/var`
  * Example (/etc/home) `ln -s /mnt/Disk/home /etc/home`

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

