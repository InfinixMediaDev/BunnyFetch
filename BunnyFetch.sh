#!/bin/bash

# Set up variables
URL="https://api.bunny.net/system/edgeserverlist/plain"
DIRECTORY_PATH="$(dirname "$(readlink -f "$0")")"
LOCAL_IP_FILE="$DIRECTORY_PATH/local_ips.txt"
IPTABLES_CMD="iptables"
LOG_FILE="$DIRECTORY_PATH/firewall_update.log"

# Create BunnyFetch subdirectory if it doesn't exist
mkdir -p "$DIRECTORY_PATH/BunnyFetch"

# Fetch IPs from the URL
curl -s "$URL" > /tmp/fetched_ips.txt

# Compare with the saved IPs
if ! cmp -s "$LOCAL_IP_FILE" /tmp/fetched_ips.txt; then
    # Extract new and removed IPs
    new_ips=$(comm -13 <(sort "$LOCAL_IP_FILE") <(sort /tmp/fetched_ips.txt))
    removed_ips=$(comm -13 <(sort /tmp/fetched_ips.txt) <(sort "$LOCAL_IP_FILE"))

    # Add new IPs to iptables rules
    added_count=0
    for ip in $new_ips; do
        # Check if the rule already exists
        if ! $IPTABLES_CMD -C INPUT -s "$ip" -j ACCEPT &> /dev/null; then
            $IPTABLES_CMD -A INPUT -s "$ip" -j ACCEPT
            echo "Added IP: $ip"
            ((added_count++))
        else
            echo "IP $ip already exists in rules."
        fi
    done

    # Update the local IP file
    mv /tmp/fetched_ips.txt "$LOCAL_IP_FILE"

    # Log the update
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp - Firewall rules updated: Success" >> "$LOG_FILE"
    echo "Total allowed IPs: $(wc -l < "$LOCAL_IP_FILE")" >> "$LOG_FILE"
    echo "Newly added IPs: $added_count" >> "$LOG_FILE"
    echo "Removed IPs: $(echo "$removed_ips" | wc -l)" >> "$LOG_FILE"
else
    # Log no changes
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp - No changes in IP addresses" >> "$LOG_FILE"
fi

exit 0
