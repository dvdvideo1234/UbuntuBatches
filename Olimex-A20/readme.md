### Hardware topology
![][ref-hw]

### Installing samba and creating shared folder
1. Navigate to `cd ~` and create folder `Share`
2. Install the server: `yes y | sudo apt-get install samba`
3. Apply the [configiration file][ref-smb-conf]: `/etc/samba/smb.conf`
4. Restart the system: `sutdown -r now`
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
  * The password will be stared automatically by the installer as `<PASSWORD>`
4. Provide to the `VNC autentication` window the `<IP>:<PORT>` and `<PASSWORD>` and click OK
5. For connecting outside of the LAN area forward the `<PORT>` in your router to `<IP>` server
6. Now you are connected to the VNC server

[ref-tight-vnc]: https://www.tightvnc.com/
[ref-x11-vnc]: https://github.com/dvdvideo1234/UbuntuBatches/tree/master/x11VNC
[ref-hw]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/hw.jpg
[ref-smb-conf]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/smb.conf
[ref-xorg-conf]: https://raw.githubusercontent.com/dvdvideo1234/UbuntuBatches/master/Olimex-A20/xorg.conf
