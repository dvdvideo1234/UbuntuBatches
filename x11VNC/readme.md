This script installs x11vnc in Ubuntu
```
The installation using this script is automatic and it's
done by placing it in a folder of choice, then running it
via "./config.sh" with one of the following parameters:

Type "sudo ./config.sh" [option] which is one of the following:
  "install <port>" Installs x11vnc from apt-get
  "remove"         Removes the x11vnc package and auto-start 
  "config"         Opens the configuration located in /etc/init/x11vnc.conf
  "start <port>"   Starts x11vnc ( change config.sh for your needs)
  "stop"           Stop x11vnc by killing the process
  "stats"          Views the common script variable paths
```
