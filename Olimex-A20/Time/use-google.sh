#!/bin/bash

# GUI Clock right-click properties:
#Timezone: `Europe/Sofia`

# Set the correct time by region
sudo unlink /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Sofia /etc/localtime

# Extract the current time from google NTP
stamp=$(date -d "$(curl -s --head http://google.com | grep ^Date: | sed 's/Date: //g')")
dtset=`date -d "${stamp}" +'%Y%m%d %H:%M:%S'`
sudo date --set="${dtset}"
