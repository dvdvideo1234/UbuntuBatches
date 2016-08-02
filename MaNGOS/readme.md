This file represent a bash script ( Yes, un nix* the extension is just cosmetic )
that can install a "World of Worcraft:Wrath of The Lich King" game server in the folder chosen.
The scrip is designed to install the WoW server on a fresh Ubuntu system ( Tested on 14.04 LTS OK )
To use this you must put it in a folder of choise and make it executable using

``` sudo chmod +x config.sh ```

Then run it in the terminal to install it by typing:

``` sudo ./config.sh install ```

It will ask you series of questions in the process for proxy, dependancies and so on.
The script is designed to be automatic, so there is no need to change anything manually !!!
After the instalation finishes, it will say "Enjoy your UDB". Then you must eztract the
client maps and vmaps as it is shown here: https://github.com/cmangos/issues/wiki/Installation-Instructions

After you are done with that process ( Which takes very long, so grab you
favorite movie and some popcorn ) you can start it like so:

``` sudo ./config.sh start ```

I made it universal, because I prefer my servers to be in ``` /srv/.. ``` , but you might
not prefer them there. Currently only the WoTLK server is done, the other are just options
that must be available in the future

Have fun with my installation script ;)
