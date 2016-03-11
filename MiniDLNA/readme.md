This script is based on the commands from this tutorial:

http://www.htpcbeginner.com/install-minidlna-on-ubuntu-ultimate-guide/

'''
The installation using this script is automatic and it's
done by placing it in a folder of choice, then running it
via "./config.sh" with one of the following parameters:

Type "./config.sh" for options:
  "install" Installs miniDLNA after compiling it from the source
  "update"  Updates the miniDLNA installation
  "remove"  Removes the miniDLNA package and auto-start 
  "config"  Opens the configuration located in /.minidlna
  "stats"   Views the common script variable paths
  
( For example "./config.sh install" starts the installation)
  
The user can chose whenever to install the dependencies needed by
answering a question [y or n]. Then it asks for a proxy ( if needed ),
automatically creates a hidden ".minidlna" installation configuration folder,
where the compiled sources are downloaded using "git clone" ( trough the proxy if given ).
Later on if configures, the sources for compilation,
creates a configuration file and installs the package.

Auto-start deamon control script is automatically generated inside the file
"minidlna" and copied inside /etc/init.d/minidlna
  
Controlling the DLNA is done via the following commands:

sudo service minidlna start
sudo service minidlna stop
sudo service minidlna restart
sudo service minidlna status
sudo service minidlna rescan

If the service does not start on "restart" or "reload", be persistent,
run the command again until you get a different Process ID !
'''
