### Description
This file represents a bash script ( Yes, in nix* the extension is just cosmetic )
that can install a `World of Warcraft` game server in the folder chosen.
The script is designed to install the `WoW` server on a fresh `Ubuntu`
system ( Tested on virtualBOX `14.04 LTS` OK ). To use this you must put it in a
folder of choice and make it executable using `sudo chmod +x config.sh`.

### Here are example commands currently available

```
  ./config.sh start <option>     --> Starts the installed mangos/realm server
  ./config.sh install            --> Installs the sever in the folder chosen
  ./config.sh drop-mangos        --> Removes the mangos database from the SQL server
  ./config.sh purge-mysql        --> Completely removes the SQL server installed in dependencies
  ./config.sh config <option>    --> Edits the server configuration according to the option provided
  ./config.sh desktop-sh         --> Creates titled terninals startup scripts on the desktop
  ./config.sh paths              --> Displays the private server paths used by the installation
```

### How the script works
It will ask you series of questions in the process for proxy, dependencies and so on.
The script is designed to be automatic, so there is no need to change anything manually !!!
After the installation finishes, it will say `Enjoy your DB`. Then you must extract the
client maps and vmaps as it's [shown here][ref-install] ( search for `maps`, `vmaps` on the page )

### How to run the server
After you are done with that process ( Which takes very long, so grab you
favorite movie and some popcorn ) you can start it like so:

``` ./config.sh start <option> ```

### Links and discussions
I made it universal, because I prefer my servers to be in `etc/var/srv/...` , but you might
not prefer them there. Currently only the Vanilla, TBC and WoTLK servers are done, the others are
just options that can available in the future

The discussion [topic you can find here][ref-script] about how the CMaNGOS server can be installed
in a fresh Ubuntu VirtualBox machine. Also, if you are searching for the markdown version of the
topic, [just look here][ref-vboxtut].

### Setup cMaNGOS accounts ( Executable terminal for MANGOS )
1. Create account `account create [username] [password]`
2. Setup expansion `account set addon [username] [0 to 3]`
 * [0] Classic ( No need to do anything )
 * [1] TBC
 * [2] WoTLK
 * [3] Cataclysm
3. Apply GM level `account set gmlevel [username] [0 to 3]`
 * [0] Player
 * [1] Moderator
 * [2] Game master
 * [3] Administrator
  
### Video tutorials
[![](https://img.youtube.com/vi/cmcnGXcxGAA/1.jpg)](http://www.youtube.com/watch?v=cmcnGXcxGAA "")
[![](https://img.youtube.com/vi/UbcHAtT80o4/2.jpg)](http://www.youtube.com/watch?v=UbcHAtT80o4 "")
[![](https://img.youtube.com/vi/X_W1LDx31AU/3.jpg)](http://www.youtube.com/watch?v=X_W1LDx31AU "")  
[![](https://img.youtube.com/vi/GiV5k3zrGYI/1.jpg)](http://www.youtube.com/watch?v=GiV5k3zrGYI "")
[![](https://img.youtube.com/vi/dHBljqAbxsQ/1.jpg)](http://www.youtube.com/watch?v=dHBljqAbxsQ "")
[![](https://img.youtube.com/vi/SGtRNFr1T3k/3.jpg)](http://www.youtube.com/watch?v=SGtRNFr1T3k "")  
[![](https://img.youtube.com/vi/FGVUdKDeMNk/3.jpg)](http://www.youtube.com/watch?v=FGVUdKDeMNk "")
[![](https://img.youtube.com/vi/O70R5csq2gg/3.jpg)](http://www.youtube.com/watch?v=O70R5csq2gg "")
[![](https://img.youtube.com/vi/-1iAuZVTiyk/3.jpg)](http://www.youtube.com/watch?v=-1iAuZVTiyk "")  

Have fun with my installation script ;)

[ref-install]: https://github.com/cmangos/issues/wiki/Installation-Instructions
[ref-vboxtut]: https://github.com/dvdvideo1234/UbuntuBatches/blob/master/MaNGOS/virtualbox.md
[ref-script]: https://forum.cmangos.net/t/how-to-use-a-script-to-install-mangos-server-under-ubuntu/49
