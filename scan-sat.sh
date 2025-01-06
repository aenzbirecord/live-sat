#!/bin/bash

# Check if nmap is installed
if ! command -v nmap &> /dev/null
then
    echo "nmap could not be found. Installing..."
    sudo apt update && sudo apt install -y nmap
fi

# Set the network range (replace with your network range)
NETWORK="192.168.1.0/24"

echo "Scanning network $NETWORK for live hosts..."
nmap -sn $NETWORK | grep "Nmap scan report" | awk '{print $5}' > live_hosts.txt

echo "Live hosts detected:"
cat live_hosts.txt

# Identify non-local IP addresses (possible satellite or external links)
echo "Checking for non-local IPs..."
while IFS= read -r ip; do
    whois $ip | grep -E "netname|descr|country|OrgName"
done < live_hosts.txt

echo "Scan complete. Check live_hosts.txt for full results."
