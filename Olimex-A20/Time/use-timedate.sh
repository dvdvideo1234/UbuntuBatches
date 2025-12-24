#!/bin/bash

# GUI Clock right-click properties:
#Timezone: `Europe/Sofia`

# Set the correct time by region
timedatectl set-timezone Europe/Sofia
timedatectl set-local-rtc 0

# Extract the current time from google NTP
timedatectl set-ntp yes

# Force enable NTP
timedatectl set-ntp yes
