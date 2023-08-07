# BunnyFetch
Script to automatically Fetch BunnyCDN Edge Server IP and whitelist them to iptables Firewall

## What this Script do?

This script will : 
1. Create BunnyFetch Directory if it's not present.
2. Create a text file containing list of IP to be saved on local server
3. Fetch IP list from : "https://api.bunny.net/system/edgeserverlist/plain".
4. Create a Temporary file to save the fetched IPs.
5. Add and Remove IP from the Firewall and check for duplicates
6. Create a LOG file.

## Script Usage

To use this script, you can place it in the BunnyFetch directory and grant execute permissions:
```
chmod +x BunnyFetch.sh
```

Then, you can run the script from within the same directory:
```
./BunnyFetch.sh
```

You can still add the cron job to run the script periodically in the same way as before, but with the updated script path and log file path:
```
crontab -e
```

Add the following line to run the script every hour:
```
0 * * * * /bin/bash /path/to/your/BunnyFetch/BunnyFetch.sh >> /path/to/your/BunnyFetch/firewall_update_cron.log 2>&1
```

## Disclaimer

The script only tested for `Almalinux 6` with `iptables`
.
