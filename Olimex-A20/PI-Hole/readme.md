﻿**/etc/.pihole/**

This directory is a clone of the [pi-hole repo 283](https://github.com/pi-hole/pi-hole.git). During installation, the repository is cloned here so the files Pi-hole needs can be copied to your system.

**/etc/cron.d/**

- `pihole`: the cron file that runs scheduled tasks such as rotating and flushing the log files or downloading the latest updates from the blocklist sources

**/etc/dnsmasq.d/**

- `01-pihole.conf`: the config specific to Pi-hole that controls how dnsmasq functions
- `02-pihole-dhcp.conf`: the config file used when Pi-hole's DHCP server is active
- `04-pihole-static-dhcp.conf` : file of static DHCP leases

**/etc/lighttpd/**

- `lighttpd.conf`: this is used to configure the Web server to respond to black holed domains and return a 404 of a blank Webpage. It also contains X-Headers and a few other settings.
- `external.conf`: this is a user-created file that can be used to modify the Web server. These changes will persist through updates, unlike if you were to manually edit lighttpd.conf 

**/etc/pihole/**

This is where most of Pi-hole's config files exist. It contains:

- `adlists.list`: a custom user-defined list of blocklist URL's (public blocklists maintained by Pi-Hole users)
- `blacklist.txt`: a user-defined list of additional domains to block locally
- `dns-servers.conf` : The list of DNS servers that ship with Pi-Hole
- `gravity.list` : perhaps Pi-hole's most important file--it is a hosts file with all of the domains that are being blocked
- `install.log`: a log file generated during installation
- `list.\*\*.domain`: these are the raw block lists that are downloaded.
- `local.list`: this contains local list entries such as pi.hole so you can access the Web interface via name instead of IP.
- `logrotate`: this is the config file that controls how logrotate handles flushing the log file
- `macvendor.db`: a database of MAC addresses that relate the MAC address to a vendor (this file is updated when Pi-Hole is updated)
- `pihole-FTL.conf`: this is the config file that specifies local pihole-FTL options
- `pihole-FTL.db`: this is the long term Pi-Hole database, containing a record of queries and a network table of clients.
- `regex.list` : file of regex filters that are compiled with each pihole-FTL start or restart
- `setupVars.conf`: this file contains variables needed to effectively setup and configure Pi-hole
- `whitelist.txt`: a user-defined list of domains to be whitelisted locally. Adding domains to this list makes them "gravity proof."

There are also several files that track the release version in GitHub:

`   ``GitHubVersions` , `localbranches` , `localversions`

**/opt/pihole**

- individual [scripts 103](https://github.com/pi-hole/pi-hole/tree/master/advanced/Scripts) that are called by pihole 
- COL\_TABLE: used for showing colors in the output of scripts

**/usr/local/bin/**

- `pihole`: this is the command that lets you [control and configure your Pi-hole 273](https://discourse.pi-hole.net/t/the-pihole-command-with-examples/738) installation

**/run**

- `pihole-FTL.pid`: the process ID used by FTL
- `pihole-FTL.port` the port number used by FTL (defaults to 4711)

**/var/**

**/var/log**

- `pihole.log`: This is the log file that contains all of the DNS queries Pi-hole handles as well as the queries that were blocked. See [this post](https://discourse.pi-hole.net/t/how-do-i-watch-and-interpret-the-log-file/276) to learn how to interpret this file. This file is rotated every night at midnight.
- `pihole\_debug.log`: This is the log file generated by pihole -d. This is stored locally, but you also have the option to upload it to our secure server
- `pihole-FTL.log`: This is the log file that contains information handled by our [FTL engine 89](https://github.com/pi-hole/FTL). This file is rotated every night at midnight.

**/var/log/lighttpd/**

- access.log: this log contains entries from blocked domains (and the web interface). It is useful for [visualizing Pi-hole 107](https://jacobsalmela.com/2015/12/01/visualize-ads-blocked-in-real-time-using-pi-hole-and-logstalgia/).
- error.log: this log file contains errors lighttpd may run into

**/var/www/html**

**/var/www/html/admin**

- This folder contains all the files needed for the admin interface and is simply a clone of [the repo 128](https://github.com/pi-hole/AdminLTE).

**/var/www/html/pihole**

- This folder contains the blank HTML page that is delivered in place of advertisements.
- It also contains the blockpage if you try to directly visit a domain that is blocked
