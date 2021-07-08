#!/bin/bash

# GUI Clock right-click properties:
#Timezone: `Europe/Sofia`

sudo unlink /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Sofia /etc/localtime

stamp=$(date -d "$(curl -s --head http://google.com | grep ^Date: | sed 's/Date: //g')")
dtset=`date -d "${stamp}" +'%Y%m%d %H:%M:%S'`
sudo date --set="${dtset}"
