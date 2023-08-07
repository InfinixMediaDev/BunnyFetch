# BunnyFetch
Script to automatically Fetch BunnyCDN Edge Server IP and whitelist them to iptables Firewall

This script will : 
1. Create BunnyFetch Directory if it's not present.
2. Create a text file containing list of IP to be saved on local server
3. Fetch IP list from : "https://api.bunny.net/system/edgeserverlist/plain".
4. Create a Temporary file to save the fetched IPs.
5. Add and Remove IP from the Firewall and check for duplicates
6. Create a LOG file.
