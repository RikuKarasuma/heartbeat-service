
Tests the internet connection by pinging googles DNS.
Each time it fails, it increments a file counter.
After 4 consecutive failures (4 mins), a reboot is 
executed.

This is to mitigate flakey updates to certain linux
VPN clients which don't interact well with inhouse
wireguard implementations. Which has caused severe
resolve.conf conflicts in the past.

