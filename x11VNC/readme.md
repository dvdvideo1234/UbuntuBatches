### Description
This script installs [x11vnc][ref-proj] server for [Ubuntu][ref-ubuntu]

### Utilizing
The installation using this script is automatic and it's
done by placing it in a folder of choice, then running it
via `./config.sh` with one of the following parameters:
  * `install <port>` Installs `x11vnc` from `apt-get`
  * `remove`         Removes the `x11vnc` package and `auto-start`
  * `config`         Opens the configuration located in `/etc/init/x11vnc.conf`
  * `start <port>`   Starts `x11vnc` using the port provided
  * `stop`           Stop `x11vnc` by killing the process
  * `stats`          Views the common script variable paths
  
**None: Type `./config.sh <option>` which is one of the following**  
**Note: Do not put `sudo` in front of the bash script!**

[ref-proj]: https://github.com/LibVNC/x11vnc
[ref-ubuntu]: https://ubuntu.com/
