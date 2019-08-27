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
1. ID `0` [Vanilla](https://en.wikipedia.org/wiki/World_of_Warcraft) with repo [found here](https://github.com/cmangos/mangos-classic) and [database here](https://github.com/cmangos/classic-db)
2. ID `1` [TBC](https://en.wikipedia.org/wiki/World_of_Warcraft:_The_Burning_Crusade) with repo [found here](https://github.com/cmangos/mangos-tbc) and [database here](https://github.com/cmangos/tbc-db)
3. ID `2` [WotLK](https://en.wikipedia.org/wiki/World_of_Warcraft:_Wrath_of_the_Lich_King) with repo [found here](https://github.com/cmangos/mangos-wotlk) and [database here](https://github.com/cmangos/wotlk-db)
4. ID `3` [Cataclism](https://en.wikipedia.org/wiki/World_of_Warcraft:_Cataclysm) with repo [found here](https://github.com/cmangos/mangos-cata) and [database here](https://github.com/cmangos/cata-db)

#### Cataclism is not yet suported because it does not have database in the repo!

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
Press ( Ctrl + Shift + Esc ) to open the task manager and view how much RAM do you have free.
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
I personally use the name, which I create my VMs with ( "Ubuntu WoW x64" )
and the limit which the virtual HDD should never exceed.

#### Configure VM settings
Right click on the created machine and select [`Settings`][ref-settings] ( Ctrl+S )
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
      * `Processor`: Give it all CPUs available  
      * `Execution cap`: Never go all the way up to 100. I keep it at 70%  
      * Enable `PAE/NX` checked  
      * Enable `Nexted VT-x/AMD-V` checked if you have CPU virtualization acceleration  
    3. **Tab `Acceleration`**
      * Check all the check-boxes and set interface to default.
 3. Configuring the `Display`
    1. **Tab `Screen`**
      * Video memory: `128` or `64` `MB` is quite good  
      * Monitor count: How many monitors is it displayed in. I use one of my two.  
      * Do not mess with the other tabs :D
 4. Configuring the `Storage`.
  * Here you will have a storage tree with `IDE` and `SATA`.
    Go ahead and delete the IDE controller `Right-click->Delete` or `Del`, then add a `CD`
    drive to the `SATA` controller by clicking the `CD` icon with the green plus sign.
    A prompt will appear for media selection. Click "Chose Disk" and insert the ISO
    downloaded in [`[1]`][ref-1].
 5. Configuring the `Network`.
  * Set adapter one of the network tab to bridged if you have a second network
    card and you want your server to run on it or NAT if you don't. Click on the little
    blue triangle that sais `Advanced` and change `Adapter Type` to `Intel Pro 1000 MT Desktop (82540EM)`
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
If you are not using a proxy, answer `Are you using a proxy [n or <proxy:port>] ?` with `n`
After the installation is done. It will compile and install the `CMaNGOS` WoW server.
and you must extract and install the maps and vmaps yourself, so please follow
the continued MaNGOS project maps [installation procedure here][ref-maps].

#### Extractiong client data
For the sake of the totorial I will use the `nix*` extraction procedre, but with a bit of trickery.
The script for extracting the maps is called `ExtractResources.sh` and it will probably fail in
`GitBash` and `Cygwin` if you compile the included map extraction tools under Ubuntu.
That's why I created a [`shared folder`][ref-sharef] with the client as separate drive for the Ubuntu to 
access when I configured the [`Shared Folders`][ref-sharef] option in the VM settings.
Now open a root GUI explorer via `suto nautilus` in the terminal. This will open the nautilus explorer
with root privileges as the `VM` shared folder drive is owned by the root user. Now copy the map
extracting tools in the root folder of of thle client where `WoW.exe` is located and start
`./ExtractResources.sh`. This will create a bunch of folders like `maps`, `vmaps`, `mmaps`, `dbc`,
`Cameras`, `Buildings`. Beware that `mmaps` and `vmaps` take very long to extract.
Copy these to `TITLE/run` when they are done extracting.

#### Assigning a network card (If available)
If you nave additional network card like I do, go to your [VM settings][ref-settings] and change the
network type `Attached to` from `NAT` to `Bridged adapter`. This will expose your other network
card to the VM internally. For example I have two cards `Realtek RTL8111E` [integeated in the MB][ref-MB] and
[`Intel CT Desktop 1Gb PCIE x1`][ref-LAN]. The intel is my daily driver and the realtek I bridbe to the VMs
I make, because the onboard LAN is more vulnerable to PoE fails in Bulgaria and may fry the [MB][ref-MB].

#### Realmlist setup in the database
If you are using `NAT`, just skip this step, otherwise if you bridged the network
card like above, install the package `net-tools` using `sudo apt-get install net-tools`
and run `ifconfig` in the terminal. It will show you the IP address of your bridged card
assigned by your router. For example this is mine `inet 10.0.2.15`. You must set the ralmlist IP to that IP, where
the `TITLE` value is located in front of the data table. After you are done, restart the server.
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
windows, but `NEVER` as root ! 

#### Connecting to the server
Go to the root of your client where `WoW.exe` is located and then go
to [`Data/enUS/realmlist.wtf`][ref-realm] and change it to whatever you
updated [in the previous step][ref-db-rlm-upd] ( ex. `10.0.2.15` ).
Start the client from `WoW.exe`, not `Launcher.exe` !

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
