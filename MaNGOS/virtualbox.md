Hi forum, 

Today I will teach you how to install MaNGOS on Ubuntu virtual box.

As some of you may know I an supporting a MaNGOS WoW server installation bash
script on Ubuntu/Debian. I always do prefer running my WoW server on a virtual
machine, so everything can become easy as pie when you mes it up :D

The thing we will need:

1. [`Ubuntu 16.04 x32 or x64`][ref-1]
 This is so called `GUEST OS`

2. [`Oracle virtual box`][ref-2]
 Depending on your host. I am gonna install it for Windows my `HOST OS`

3. Oracle VB additions: `VirtualBox #VERSION# Oracle VM VirtualBox Extension Pack`
( Search the link in [`[2]`][ref-2] )

First download all the stuff above and save it to folder of choice ( I am gonna call it `INSTALL` ).
Go to your `INSTALL` folder and open the virtual box to install it. This is pretty straight forward,
though if you do not like where your virtual machine HDDs are stored, you can always change it by
`File -> Preferences -> [Left list] General -> Default Machine folder`. I prefer mine
in `F:\VirtualMachines`.

Now we need to install the extensions. Go to `File -> Preferences -> [Left list] Extensions ->`
`Extension packages -> The little arrow-down button`. It will prompt you to browse for your extension.
Give it the file downloaded file in point [`[3]`][ref-3], which matches the version of the application
you've downloaded in [`[2]`][ref-2]. It is bad to use outdated extensions on a newer VB application or
the other way around.

We are now done, so go ahead and create a virtual machine.
Name it whatever you like but keep it consistent ( I used `Ubuntu 16.04 WoW x64` ). The type must be
`Linux` and the version `Ubuntu x32 or x64` depending on point [`[1]`][ref-1] ). Click `Next`
This screen is used to set the memory:

```[Memory]```  
Press ( Ctrl + Shift + Esc ) to open the task manager and view how much RAM do you have free.
You can use the half of it. I had 16GB free, so I went for 8GB.

```[Hard disk]```  
Please use at least `15GB` as there are dependencies and additional software needed
for installing MaNGOS. Fully working and configured application tops at `13.5GB` with all
the dependencies, extensions, scrips and tables !

```[Hard disk file type]```
Make sure you always `*.VDI`, if you want to extend the virtual HDD in the future.
```[Storage of physical hard disk]```
If you use `Dynamically allocated` the virtual HDD grows in size as you install sutff in the `GUEST`
( In our case the Ubuntu ). The `Fixed size` will allocate the whole HDD on creation.

```[File location and size]```
This tells Oracle VB where to store your virtual HDD. It must be a valid file name.
I personally use the name, which I create my VMs with ( "Ubuntu 16.04 WoW x64" )
and the limit which the virtual HDD should never exceed.

Right click on the created machine and select `Settings` ( Ctrl+S )
  1. We are now going to configure the general settings, so click on `General`.
    * Tab `Advanced`
       > `Shared clipboard`: `Bidirectional`  
       > `Drag'n'drop`: `Bidirectional`  
  2. We are now going to configure the system, so click on `System`.
    * Tab `Motherboard`
       > Boot order: 1) `Optical`, 2) `HDD`  
       > Chipset: PIIX3  
       > Pointing device: USB tablet  
       > Extended features: Check only `I/O APIC`, `Hardware Clock in UTC Time`  
    * Tab `Processor`
       > `Processor`: Give it all CPUs available  
       > `Execution cap`: Never go all the way up to 100. I keep it at 70%  
       > Enable `PAE/NX` checked  
       > Enable `Nexted VT-x/AMD-V` checked if you have CPU virtualization acceleration  
    * Tab `Acceleration`: Check all the check-boxes and set interface to default.
  3. Configuring the `Display`
    * Tab `Screen`
       > Video memory: `128` or `64` `MB` is quite good  
       > Monitor count: How many monitors is it displayed in. I use one of my two.  
       > Do not mess with the other tabs :D
  4. Configuring the `Storage`.
       > Here you will have a storage tree with `IDE` and `SATA`.
       > Go ahead and delete the IDE controller `Right-click->Delete` or `Del`, then add a `CD`
       > drive to the `SATA` controller by clicking the `CD` icon with the green plus sign.
       > A prompt will appear for media selection. Click "Chose Disk" and insert the ISO
       > downloaded in [`[1]`][ref-1].
  5. Configuring the `Network`.
       > Set adapter one of the network tab to bridged if you have a second network
       > card and you want your server to run on it or NAT if you don't. I am gonna use
       > `Intel Pro 1000 MT Desktop (82540EM)` as the Ubuntu takes it without any drivers.
  6. Configuring the `Shared Folders`.
       > Click on the buttin with the `folder +` sign.  
       > An `Add Share` dialog will appear.  
       > In `Folder Path` drop down menu select `Other...`
       > Give it the location of your client. This becomes handy later.  

Now Click `OK` on the settings window to apply your changes to the Ubuntu VM.
Start it and follow the Ubuntu installation. until you install the Ubuntu OS
from the `CD` in [`[1]`][ref-1]. When you see the desktop showing for the first time,
open the [software sources](https://help.ubuntu.com/community/Repositories/Ubuntu)
and on `Download from` drop down menu chose `Main server` then `Reload`.

Open the terminal and type `sudo apt-get update`.

After this you must install `VB` dependencies. I also have
a script for that purpose [which you can find here](https://github.com/dvdvideo1234/UbuntuBatches/tree/master/VirtualBox).

Download the script to your home folder and start it. It will install all
the `VB` dependencies `Do you want to install dependencies [y/n]? y`.
Beware there will be restart needed if you chose to run the update manager
`Do you want to run force-update [y/n]? y`.

Now install the VB addition CD provided by Oracle by clicking
`Devices->Insert Guest Addition CD Image...` and hit the `Run` button. Authorize it to proceed
and follow the console prompt. After the installation you will have bi-directional
copy-paste and all needed `VB` acceleration hardware support.

We are finally here to install MaNGOS from source.
I have a script [dedicated to this here][ref-repo] ( View the readme.md for further questions ):

Download the script to your folder of choice ( I will call it `SEVER` ), mark it as
executable `sudo chmod +x config.sh` and run it. The title `TITLE` that you chose will be installed
in the `SERVER/TITLE`. directory. Now follow the console prompt and anwer the questions seen.
If you are not using a proxy, answer `Are you using a proxy [n or <proxy:port>] ?` with `n`

After the installation is done. It will compile and install the `CMaNGOS` WoW server.
and you must extract and install the maps and vmaps yourself, so please follow
the continued MaNGOS project maps [installation procedure here][ref-maps]. For the totorial
I will use the `nix*` extraction procedre, but with a bit of trickery. The script for extracting
the maps is called `ExtractResources.sh` and it will brobably fail in `GitBash` and `Cygwin`.
That's why I created the shared folder with the client as separate drive for the Ubuntu to 
access when I configured the `Shared Folders` option. Now open `root nautilus` via `suto nautilus`.
This will open the nautilus explorer with root privileves as the `VM` shared folder dravie is owned
by the root user. Now copy the map extracting tools in the roor folder of of thle client where
`WoW.exe` is located and start `./ExtractResources.sh`. This will create a bunch of folders like
`maps`, `vmaps`, `mmaps`, `dbc`, `Cameras`, `Buildings`. Beware that `mmaps` and `vmaps` take very
long to extract. Copy these to `TITLE/run` when they are done extracting.

[ref-1]: https://www.ubuntu.com/download/desktop
[ref-2]: https://www.virtualbox.org/wiki/Downloads
[ref-3]: https://www.virtualbox.org/wiki/Downloads
[ref-repo]: https://github.com/dvdvideo1234/UbuntuBatches/tree/master/MaNGOS
[ref-maps]: https://github.com/cmangos/issues/wiki/Installation-Instructions