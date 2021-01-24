Hi forum, 

#### Foreword and stuff
Today I will teach you how to install MaNGOS on Ubuntu virtual box.
As some of you may know I an supporting a MaNGOS WoW server installation bash
script on Ubuntu/Debian. I always do prefer running my WoW server on a virtual
machine, so everything can become easy as pie when you mes it up :D

#### The thing we will need:

1. [`Ubuntu x32 or x64`][ref-1]
 This is so called `GUEST OS`

2. [`Oracle virtual box`][ref-2]
 Depending on your host. I am gonna install it for Windows my `HOST OS`

3. Oracle VB additions: `VirtualBox #VERSION# Oracle VM VirtualBox Extension Pack`
( Search the link in [`[2]`][ref-2] )

#### Supported versions are found in the list below with the dedicated title ID.
1. ID `0` [`Vanilla`](https://en.wikipedia.org/wiki/World_of_Warcraft) with repo [found here](https://github.com/cmangos/mangos-classic) and [database here](https://github.com/cmangos/classic-db)
2. ID `1` [`TBC`](https://en.wikipedia.org/wiki/World_of_Warcraft:_The_Burning_Crusade) with repo [found here](https://github.com/cmangos/mangos-tbc) and [database here](https://github.com/cmangos/tbc-db)
3. ID `2` [`WotLK`](https://en.wikipedia.org/wiki/World_of_Warcraft:_Wrath_of_the_Lich_King) with repo [found here](https://github.com/cmangos/mangos-wotlk) and [database here](https://github.com/cmangos/wotlk-db)
4. ID `3` [`Cataclism`](https://en.wikipedia.org/wiki/World_of_Warcraft:_Cataclysm) with repo [found here](https://github.com/cmangos/mangos-cata) and [database here](https://github.com/cmangos/cata-db)
5. ID `4` [`Mists of Pandaria`](https://en.wikipedia.org/wiki/World_of_Warcraft:_Mists_of_Pandaria) with repo [found here](https://github.com/cmangos/mangos-mop) and [database here](https://github.com/cmangos/mop-db)
6. ID `5` [`Legion`](https://en.wikipedia.org/wiki/World_of_Warcraft:_Legion) with repo [found here](https://github.com/cmangos/mangos-legion) and [database here](https://github.com/cmangos/legion-db)

#### Unavailable options
1. `Cataclism` is not yet supported because it does not have database in the repo.
2. `Mists of Pandaria` does not have dedicated repositories and database.
3. `Legion` does not have dedicated repositories and database.

#### Prepare the software list
First download all the stuff above and save it to folder of choice ( I am gonna call it `INSTALL` ).
Go to your `INSTALL` folder and open the virtual box to install it. This is pretty straight forward,
though if you do not like where your virtual machine HDDs are stored, you can always change it by
`File -> Preferences -> [Left list] General -> Default Machine folder`. I prefer mine
in `F:\VirtualMachines`.

#### Install VB extensions
Now we need to install the extensions. Go to `File -> Preferences -> [Left list] Extensions ->`
`Extension packages -> The little arrow-down button`. It will prompt you to browse for your extension.
Give it the file downloaded file in point [`[3]`][ref-3], which matches the version of the application
you've downloaded in [`[2]`][ref-2]. It is bad to use outdated extensions on a newer VB application or
the other way around.

#### Creating the VM
We are now done, so go ahead and create a virtual machine.
Name it whatever you like but keep it consistent ( I used `Ubuntu WoW x64` ). The type must be
`Linux` and the version `Ubuntu x32 or x64` depending on point [`[1]`][ref-1] ). Click `Next`

#### `[Memory]`
Press ( `Ctrl + Shift + Esc` ) to open the task manager and view how much RAM do you have free.
You can use the half of it. I had 16GB free, so I went for 8GB.

#### `[Hard disk]`
Please use at least `15GB` as there are dependencies and additional software needed
for installing MaNGOS. Fully working and configured application tops at `13.5GB` with all
the dependencies, extensions, scrips and tables !

#### `[Hard disk file type]`
Make sure you always `*.VDI`, if you want to extend the virtual HDD in the future.

#### `[Storage of physical hard disk]`
If you use `Dynamically allocated` the virtual HDD grows in size as you install sutff in the `GUEST`
( In our case the Ubuntu ). The `Fixed size` will allocate the whole HDD on creation.

#### `[File location and size]`
This tells Oracle VB where to store your virtual HDD. It must be a valid file name.
I personally use the name, which I create my VMs with ( `Ubuntu WoW x64` )
and the limit which the virtual HDD should never exceed.

#### Configure VM settings
Right click on the created machine and select [`Settings`][ref-settings] ( `Ctrl+S` )
 1. We are now going to configure the general settings, so click on `General`.
    1. **Tab `Advanced`**
      * `Shared clipboard`: `Bidirectional`  
      * `Drag'n'drop`: `Bidirectional`  
 2. We are now going to configure the system, so click on `System`.
    1. **Tab `Motherboard`**
      * Boot order: 1) `Optical`, 2) `HDD`  
      * Chipset: PIIX3  
      * Pointing device: USB tablet  
      * Extended features: Check only `I/O APIC`, `Hardware Clock in UTC Time`  
    2. **Tab `Processor`**
      * `Processor(s)`: Give it CPU cores as many as power of two, but less than total ( I have `6` cores on my [`Phenom 1090T`][ref-phenom], so I went with `4` for the VM )
      * `Execution cap`: Keep the execution cap at `100%`. It always works better with less than the actual cores and topped execution cap.
      * Enable `PAE/NX` checked, to expose the PAE address to the VM.  
    3. **Tab `Acceleration`**
      * `Paravirtualization interface` Drop down, select `KVM` ( Kernel based VM )  
      * Enable `Nested VT-x/AMD-V` checked, if you have CPU VM acceleration ( I do have `AMD-V` )  
      * Enable `Nested paging` checked, if you have CPU VM acceleration ( I do have `AMD-V` )  
 3. Configuring the `Display`
    1. **Tab `Screen`**
      * Video memory: `128` or `64` `MB` is quite good as we are making a server after all . 
      * Monitor count: How many monitors is it displayed in. I use one of my two.  
      * Do not mess with the other tabs :D
 4. Configuring the `Storage`.
  * Here you will have a storage tree with `IDE` and `SATA`.
    Go ahead and delete the IDE controller `Right-click->Delete` or `Del`, then add a `CD`
    drive to the `SATA` controller by clicking the `CD` icon with the green plus sign.
    A prompt will appear for media selection. Click `Chose Disk` and insert the `ISO`
    downloaded in [`[1]`][ref-1].
 5. Configuring the `Network`.
  * Set adapter one of the network tab to bridged if you have a second network
    card and you want your server to run on it or NAT if you don't. Click on the little
    blue triangle that says `Advanced` and change `Adapter Type` to `Intel Pro 1000 MT Desktop (82540EM)`
    as the Ubuntu takes it without any drivers.  
 6. Configuring the `Shared Folders`.
  * Click on the button with the blue folder `+` sign.  
    An `Add Share` dialog will appear.  
    In `Folder Path` drop down menu select `Other...`
    Give it the location of your client. This becomes handy later.  

#### Changing the [software sources][ref-sources]
Now Click `OK` on the settings window to apply your changes to the Ubuntu VM.
Start it and follow the Ubuntu installation. until you install the Ubuntu OS
from the `CD` in [`[1]`][ref-1]. When you see the desktop showing for the first time,
open the [software sources](https://help.ubuntu.com/community/Repositories/Ubuntu)
and on `Download from` drop down menu chose `Main server` then `Reload`.

Open the terminal and type `sudo apt-get update`.

#### Install VB dependencies
I have a script for that purpose [which you can find here][ref-bvdeps].
Download [the script][ref-bvdeps] to your home folder and start it. It will install all
the `VB` dependencies for you. It will ask you for confirmation `Do you want to install dependencies [y/n]? y`.
Beware there will be restart needed if you chose to run the update manager
`Do you want to run force-update [y/n]? y`.

#### Install VB additions image virtual CD
Now install the VB addition CD provided by Oracle by clicking
`Devices->Insert Guest Addition CD Image...` and hit the `Run` button. Authorize it to proceed
and follow the console prompt. After the installation you will have bi-directional
copy-paste and all needed `VB` acceleration hardware support.

#### Installing MaNGOS from source
I have a script [dedicated to this here][ref-repo] ( View the readme.md for further questions ).
Download [the script][ref-repo] to your folder of choice ( I will call it `SEVER` ), mark it as
executable `sudo chmod +x config.sh` and run it. The title `TITLE` that you chose will be installed
in the `SERVER/TITLE`. directory. Now follow the console prompt and anwer the questions seen.
If you are not using a proxy, answer `Are you using a proxy [n or <proxy:port>] ?` with `n`.
After the installation is done, it will compile and install the `CMaNGOS` WoW server.
The next thing needed is extracting and installing the maps and vmaps yourself, so please follow
the continued MaNGOS project maps [installation procedure here][ref-maps].

#### Extracting client data
For the sake of the totorial I will use the `nix*` extraction procedure, but with a bit of trickery.
The script for extracting the maps is called `ExtractResources.sh` and it will probably fail in
[`GitBash`][ref-git-bash] and [`Cygwin`][ref-cygwin] if you compile the included map extraction tools under Ubuntu.
That's why I created a [`shared folder`][ref-sharef] with the client as separate drive for the Ubuntu to 
access when I configured the [`Shared Folders`][ref-sharef] option in the VM settings.
Now open a root GUI explorer via `sudo nautilus` in the terminal. This will open the `nautilus` explorer
with root privileges as the `VM` shared folder drive is owned by the root user. Now copy the map
extracting tools in the root folder of the client where `WoW.exe` is located and then start
`./ExtractResources.sh`. This will create a bunch of folders like `maps`, `vmaps`, `mmaps`, `dbc`,
`Cameras`, `Buildings`. Beware that `mmaps` and `vmaps` take very long to extract.
Copy these to `TITLE/run` when they are done extracting.

#### Applying data directory in the configuration
After you copy the server content, you must not forget to update the [mangos configuration][ref-mangosd-conf]
stored in in the `TITLE/run` under `mangosd.conf`. In this file you must search for `mangosd.conf/DataDir = "."`.
Update the value with the full path to the `run` folder including. You can extract this information by executing
`echo $PWD` inside the `run` folder in the terminal. When you obtain the path, you will have something similar
to this as for the sake of the tutorial I installed the server in the `Documents` folder of the dedicated user:
```
  DataDir = "/home/mangos/Documents/UbuntuBatches/MaNGOS/classic/run"
```

#### Assigning a network card (If available)
If you have additional network card like I do, go to your [VM settings][ref-settings] and change the
network type `Attached to` from `NAT` to `Bridged adapter`. This will expose your other network
card to the VM internally. For example I have two cards `Realtek RTL8111E` [integeated in the MB][ref-MB] and
[`Intel CT Desktop 1Gb PCIE x1`][ref-LAN]. The intel is my daily driver and the realtek I bridge to the VMs
I make, because the onboard LAN is more vulnerable to PoE fails in Bulgaria and may fry the [MB][ref-MB].

#### Open application dedicated ports
If you [have a router][ref-router], you have to open the ports in its [`application virtual server`][ref-vir-srv]
function somewhere in the settings. I have two routers sequentially attached to each other, so you need to open
the ports in these that are not configured in [DMZ][ref-dmz]. Besides general port forwarding you also need to open
dedicated port to the world itself . You can find such information in the [mangos world configuration file][ref-mangosd-conf].
This value must correspond to the [realm `port`][ref-world-port] [stored in the database][ref-world] ( def. `8085` ).
The game play realm port can be found in the [dedicated realm configuration file][ref-realmd-conf] ( def. `3724` ).
The executable `WoW.exe` needs the following ports provided below. You need to open the `TCP` and `UDP` routes:
```
  TCP: 1119-1120,(realmd.conf/RealmServerPort:3724),4000,6112-6114,(mangosd.conf/WorldServerPort=realmd.realmlist.port:8085)
  UDP: 1119-1120,(realmd.conf/RealmServerPort:3724),4000,6112-6114,(mangosd.conf/WorldServerPort=realmd.realmlist.port:8085)
```
#### Ubuntu firewall forwarding ( `ufw` Uncomplicated firewall )
If you have enabled the integrated [Ubuntu firewall][ref-ufw] ( invoked with the command [`ufw`][ref-ufw] in the
[terminal][ref-ubuntu-term] ), you must tell it to also pass the dedicated application ports for the `realm`
and `world` server hosting. We will only need `allow` and `deny` for the tutorial. You will have something like this:
```
Ubuntu@Server:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[18] 1119 (v6)                  ALLOW IN    Anywhere (v6)
[19] 1120 (v6)                  ALLOW IN    Anywhere (v6)
[20] 3724 (v6)                  ALLOW IN    Anywhere (v6)
[21] 4000 (v6)                  ALLOW IN    Anywhere (v6)
[22] 6112 (v6)                  ALLOW IN    Anywhere (v6)
[23] 6113 (v6)                  ALLOW IN    Anywhere (v6)
[24] 6114 (v6)                  ALLOW IN    Anywhere (v6)
[25] 8085 (v6)                  ALLOW IN    Anywhere (v6)
```
Displaying all your software firewall rules in the list above with their dedicated numbers. Beware if you need to
delete a rule, **you will need its number to delete one rule at a time, because the list order is sequential**!
1. For deleting a rule you type `sudo ufw delete 22` to delete rule number `22` `[22] 6112 (v6)`
2. For allow/deny a port you type `sudo ufw allow/deny 3724` to open or close `3724` on `TCP/UDP`
3. For allow/deny a port range you type `sudo ufw allow/deny 3724:3726/tcp` both one for `TCP` and one for `UDP`
4. If you need additional information for controlling your personal version of [`ufw`][ref-ufw] type `sudo ufw help`

#### Configure for `NAT`
If you are using a `NAT`, it is just like another router layer between the `GUEST` and the `HOST`. In virtual box, you
can find the option in the VM [`settings`][ref-settings], where the network setup options are located being `Settings -> Network ->
Adapter#` ( Usually `Adapter 1` to `Adapter 4` ). In the dedicated adapter number, I am using `Adapter 1` for my VM wired connection.
In the adapter dedicated settings change `Attached to:` to `NAT`. Click on the blue triangle `Advanced` to expand it. In the drop-down
menu `Adapter Type:` select `Intel Pro 1000 MT Desktop (82540EM)` ( The one we used when we created the VM ). Click on the
`Port Forwarding` button. It will open a window where you must enter your port list. Be aware that there is no option for port range
so you must enter a port two times both for `TCP` and `UDP`. The columns are described below what they do:
  * `Name      :` This is the application you will use the port for. I'll put `WoW`.
  * `Protocol  :` This is the application protocol. I will put one for `UDP` and one for `TCP`.
  * `Host IP   :` This is the IP of the `HOST` which runs the VM. Leave it blank.
  * `Host port :` This is the port on the `HOST` which runs the VM.
  * `Guest IP  :` This is the IP of the `GUEST` machine which runs the server. Leave it blank.
  * `Guest port:` This is the `GUEST` application internal port.

Now you are ready to configure the `NAT` port forwarding, so give it [the ports listed above][ref-port-list].
You can see how to configure the `NAT` forwarding in the table below for port `3724` which is used
for gameplay. Do the same thing for [all ports][ref-port-list].

| Name |Protocol|Host IP|Host port|Guest IP|Guest port|
|------|--------|-------|---------|--------|----------|
| WoW  |TCP     |       |3724     |        |3724      |
| WoW  |UDP     |       |3724     |        |3724      |

#### Realmlist setup in the database
If you bridged the network card like above, install the package `net-tools` using `sudo apt-get install net-tools`
and run `ifconfig` in the terminal. It will show you the IP address of your bridged card
assigned by your router. For example this is mine `inet 10.0.2.15`. You must set the `realmlist` `IP` to the one, where
the `TITLE` value is located in front of the data table. After you are done, restart the server.
If you have a [public IP address][ref-public] provided by your [ISP][ref-isp], you can directly store it in the database.
```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| classiccharacters  |
| classicmangos      |
| classicrealmd      |
| mysql              |
| performance_schema |
| sys                |
| tbccharacters      |
| tbcmangos          |
| tbcrealmd          |
| wotlkcharacters    |
| wotlkmangos        |
| wotlkrealmd        |
+--------------------+
```
Let's say you want to change the realmlist of `wotlk`.
I am only gonna change the IP address of the server for the tutorial's sake.
1. `use wotlkrealmd;`
2. `select * from realmlist;`
```
+----+--------+-----------+------+------+------------+----------+----------------------+------------+-------------+
| id | name   | address   | port | icon | realmflags | timezone | allowedSecurityLevel | population | realmbuilds |
+----+--------+-----------+------+------+------------+----------+----------------------+------------+-------------+
|  1 | MaNGOS | 127.0.0.1 | 8085 |    1 |          0 |        1 |                    0 |          0 |             |
+----+--------+-----------+------+------+------------+----------+----------------------+------------+-------------+
1 row in set (0.01 sec)
```
3. `update realmlist set address = '10.0.2.15' where id = 1;`
4. `commit;`

#### Starting the server
Start the server by using `./config start <option>`, where the <option>
parameter may be either `mangos` or `realm`. Run these in separate terminal
windows, but **_`NEVER`_** as root ! 

#### Connecting to the server
Go to the root of your client where `WoW.exe` is located and then go
to [`Data/enUS/realmlist.wtf`][ref-realm] and change it to whatever you
updated [in the previous step][ref-db-rlm-upd] ( ex. `10.0.2.15` ).
Start the client from `WoW.exe`, **_`NOT`_** `Launcher.exe` !

[ref-ubuntu-term]: https://ubuntu.com/tutorials/command-line-for-beginners#1-overview
[ref-ufw]: https://wiki.ubuntu.com/UncomplicatedFirewall
[ref-realmd-conf]: https://github.com/cmangos/mangos-wotlk/blob/master/src/realmd/realmd.conf.dist.in
[ref-mangosd-conf]: https://github.com/cmangos/mangos-wotlk/blob/master/src/mangosd/mangosd.conf.dist.in
[ref-world]: https://github.com/cmangos/issues/wiki/Realmlist
[ref-world-port]: https://github.com/cmangos/issues/wiki/Realmlist#port
[ref-isp]: https://en.wikipedia.org/wiki/Internet_service_provider
[ref-public]: https://www.showmyipaddress.eu/
[ref-1]: https://www.ubuntu.com/download/desktop
[ref-2]: https://www.virtualbox.org/wiki/Downloads
[ref-3]: https://www.virtualbox.org/wiki/Downloads
[ref-repo]: https://github.com/dvdvideo1234/UbuntuBatches/tree/master/MaNGOS
[ref-maps]: https://github.com/cmangos/issues/wiki/Installation-Instructions
[ref-settings]: https://www.virtualbox.org/manual/ch03.html#settings-system
[ref-sources]: https://help.ubuntu.com/community/Repositories/Ubuntu
[ref-bvdeps]: https://github.com/dvdvideo1234/UbuntuBatches/tree/master/VirtualBox
[ref-sharef]: https://www.virtualbox.org/manual/ch04.html#sharedfolders
[ref-LAN]: https://www.intel.com/content/www/us/en/products/network-io/ethernet/gigabit-adapters/ct-desktop.html
[ref-MB]: https://www.asrock.com/mb/AMD/970%20Extreme4/
[ref-realm]: https://www.wikihow.com/Set-a-Realmlist-for-World-of-Warcraft
[ref-db-rlm-upd]: https://github.com/dvdvideo1234/UbuntuBatches/wiki/MaNGOS#realmlist-setup-in-the-database
[ref-git-bash]: https://git-scm.com/downloads
[ref-cygwin]: https://www.cygwin.com/
[ref-router]: https://www.tp-link.com/us/business-networking/vpn-router/tl-r600vpn/
[ref-vir-srv]: http://screenshots.portforward.com/routers/TP-Link/TL-R600VPN/Virtual_Servers.htm
[ref-dmz]: https://en.wikipedia.org/wiki/DMZ_(computing)
[ref-port-list]: https://github.com/dvdvideo1234/UbuntuBatches/blob/master/MaNGOS/virtualbox.md#open-application-dedicated-ports
[ref-phenom]: http://www.cpu-world.com/CPUs/K10/AMD-Phenom%20II%20X6%201090T%20Black%20Edition%20-%20HDT90ZFBK6DGR%20(HDT90ZFBGRBOX).html
