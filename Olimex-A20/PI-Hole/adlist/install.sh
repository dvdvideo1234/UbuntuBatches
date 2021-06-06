#!/bin/bash

arGravity=()

# Suspicious Lists (https://firebog.net/)

https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts
https://v.firebog.net/hosts/static/w3kbl.txt
https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt
https://someonewhocares.org/hosts/zero/hosts
https://raw.githubusercontent.com/VeleSila/yhosts/master/hosts
https://winhelp2002.mvps.org/hosts.txt
https://v.firebog.net/hosts/neohostsbasic.txt
https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt
https://paulgb.github.io/BarbBlock/blacklists/hosts-file.txt

# Advertising Lists (https://firebog.net/)

https://adaway.org/hosts.txt
https://v.firebog.net/hosts/AdguardDNS.txt
https://v.firebog.net/hosts/Admiral.txt
https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
https://v.firebog.net/hosts/Easylist.txt
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts
https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts
https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts

# Tracking & Telemetry Lists (https://firebog.net/)

https://v.firebog.net/hosts/Easyprivacy.txt
https://v.firebog.net/hosts/Prigent-Ads.txt
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts
https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt
https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt
https://hostfiles.frogeye.fr/multiparty-trackers-hosts.txt
https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt
https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt

# Malicious Lists (https://firebog.net/)

https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt
https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
https://v.firebog.net/hosts/Prigent-Crypto.txt
https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt
https://phishing.army/download/phishing_army_blocklist_extended.txt
https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt
https://v.firebog.net/hosts/Shalla-mal.txt
https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts
https://urlhaus.abuse.ch/downloads/hostfile/
https://v.firebog.net/hosts/Prigent-Malware.txt
https://raw.githubusercontent.com/HorusTeknoloji/TR-PhishingList/master/url-lists.txt

# Other Lists (https://firebog.net/)

https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser
https://raw.githubusercontent.com/chadmayfield/my-pihole-blocklists/master/lists/pi_blocklist_porn_all.list
https://raw.githubusercontent.com/chadmayfield/my-pihole-blocklists/master/lists/pi_blocklist_porn_top1m.list
https://raw.githubusercontent.com/anudeepND/blacklist/master/facebook.txt

# https://gist.github.com/rgstephens/e17f5730e9d172ce9725060b99375c03

https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://mirror1.malwaredomains.com/files/justdomains
http://sysctl.org/cameleon/hosts
https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
https://hosts-file.net/ad_servers.txt
https://hosts-file.net/grm.txt
https://reddestdream.github.io/Projects/MinimalHosts/etc/MinimalHostsBlocker/minimalhosts
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/KADhosts/hosts
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/add.Spam/hosts
https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
https://hosts-file.net/exp.txt
https://hosts-file.net/emd.txt
https://hosts-file.net/psh.txt
https://mirror.cedia.org.ec/malwaredomains/immortal_domains.txt
https://www.malwaredomainlist.com/hostslist/hosts.txt
https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt
https://v.firebog.net/hosts/Prigent-Malware.txt
https://v.firebog.net/hosts/Prigent-Phishing.txt
https://phishing.army/download/phishing_army_blocklist_extended.txt
https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt
https://v.firebog.net/hosts/Shalla-mal.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/data/add.Risk/hosts
https://www.squidblacklist.org/downloads/dg-malicious.acl
https://gitlab.com/curben/urlhaus-filter/raw/master/urlhaus-filter-hosts.txt
https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt
https://raw.githubusercontent.com/HorusTeknoloji/TR-PhishingList/master/url-lists.txt
https://github.com/chadmayfield/pihole-blocklists/raw/master/lists/pi_blocklist_porn_all.list
https://raw.githubusercontent.com/chadmayfield/pihole-blocklists/master/lists/pi_blocklist_porn_top1m.list
https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser

# https://github.com/JavanXD/ya-pihole-list/blob/master/adlists.list.updater

https://justdomains.github.io/blocklists/lists/easylist-justdomains.txt
https://justdomains.github.io/blocklists/lists/easyprivacy-justdomains.txt
https://justdomains.github.io/blocklists/lists/adguarddns-justdomains.txt
https://justdomains.github.io/blocklists/lists/nocoin-justdomains.txt
https://raw.githubusercontent.com/dfederlein/dnsbl-dfed/master/spotifyads.txt
https://raw.githubusercontent.com/hectorm/hmirror/master/data/spam404.com/list.txt
https://raw.githubusercontent.com/hectorm/hmirror/master/data/adaway.org/list.txt
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/Phishing-Angriffe
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/spam.mails
https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/dnscrypt/spy.txt
https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/MobileFilter/sections/adservers.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
https://urlhaus.abuse.ch/downloads/hostfile/
https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt
https://dbl.oisd.nl/
