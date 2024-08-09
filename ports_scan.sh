#!/bin/bash

# Check if the input file and output directory are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <domain_list_file> <output_directory>"
    exit 1
fi

DOMAIN_FILE=$1
OUTPUT_DIR=$2

# Check if the provided file exists
if [ ! -f $DOMAIN_FILE ]; then
    echo "File $DOMAIN_FILE not found!"
    exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Install required tools if not already installed
command -v rustscan >/dev/null 2>&1 || { echo >&2 "RustScan is not installed. Installing..."; curl -s https://api.github.com/repos/RustScan/RustScan/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d '"' | wget -qi - && sudo dpkg -i rustscan_*.deb; }
command -v masscan >/dev/null 2>&1 || { echo >&2 "Masscan is not installed. Installing..."; sudo apt-get install masscan -y; }
command -v xmllint >/dev/null 2>&1 || { echo >&2 "xmllint is not installed. Installing..."; sudo apt-get install libxml2-utils -y; }

# Resolve domains to IP addresses
echo "Resolving domains to IP addresses..."
> $OUTPUT_DIR/ips.txt
while IFS= read -r domain
do
    ip=$(dig +short $domain | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')
    if [ ! -z "$ip" ]; then
        echo "$ip" >> $OUTPUT_DIR/ips.txt
    fi
done < "$DOMAIN_FILE"

# Remove duplicates
sort -u $OUTPUT_DIR/ips.txt -o $OUTPUT_DIR/ips.txt

# Run Masscan to find open ports
echo "Running Masscan to find open ports..."
sudo masscan -iL $OUTPUT_DIR/ips.txt -p0-65535 --rate=10000 -oX $OUTPUT_DIR/masscan_results.xml

# Extract IPs and their open ports from Masscan results
echo "Extracting open ports from Masscan results..."
> $OUTPUT_DIR/ip_ports.txt
xmllint --xpath '//host' $OUTPUT_DIR/masscan_results.xml | while IFS= read -r line; do
    ip=$(echo $line | grep -oP 'addr="\K[^"]+')
    echo $line | grep -oP 'portid="\K[^"]+' | while IFS= read -r port; do
        echo "$ip:$port" >> $OUTPUT_DIR/ip_ports.txt
    done
done

# Run RustScan for detailed port scan on IPs with open ports
echo "Running RustScan for detailed port scan..."
while IFS= read -r ip_port
do
    ip=$(echo $ip_port | cut -d: -f1)
    port=$(echo $ip_port | cut -d: -f2)
    echo "Scanning $ip on port $port with RustScan..."
    sudo rustscan --ulimit 5000 -a $ip -p $port -- -sV -O -oN "$OUTPUT_DIR/$ip-$port-rustscan.txt"
done < $OUTPUT_DIR/ip_ports.txt

echo "Scanning completed. Results are in the $OUTPUT_DIR directory."
