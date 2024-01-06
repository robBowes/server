#!/bin/bash

# Fail fast and be aware of exit codes
set -eo pipefail

# Global constants (readonly)
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

# Function to add a new client
add_client() {
    # Local variables
    local client_name=$1
    local client_ip=$2
    local server_config="/etc/wireguard/wg0.conf" # Path to server config file
    local server_endpoint="SERVER_IP:PORT"        # Replace with your server's IP and port
    local client_config_dir="/etc/wireguard/clients"

    # Retrieve server's public key from the configuration file or active interface
    local server_public_key=$(grep 'PublicKey' $server_config | awk '{print $3}')
    # Alternatively, if the interface is up, you could use: local server_public_key=$(wg show wg0 public-key)

    # Check if client name is provided
    if [[ -z "$client_name" ]]; then
        echo "Client name is required. Usage: add_client.sh <client-name> <client-ip>"
        exit 1
    fi

    # Check if client IP is provided
    if [[ -z "$client_ip" ]]; then
        echo "Client IP is required. Usage: add_client.sh <client-name> <client-ip>"
        exit 1
    fi

    # Generate client private and public keys
    local client_private_key=$(wg genkey)
    local client_public_key=$(echo "$client_private_key" | wg pubkey)

    # Create client configuration directory if it doesn't exist
    mkdir -p "$client_config_dir"

    # Define new client configuration
    local client_conf="$client_config_dir/${client_name}.conf"

    echo "[Interface]
PrivateKey = $client_private_key
Address = 10.0.0.$client_ip/32  # Use a unique number for each client
DNS = 1.1.1.1  # Replace with your preferred DNS

[Peer]
PublicKey = $server_public_key
AllowedIPs = 0.0.0.0/0
Endpoint = $server_endpoint
PersistentKeepalive = 25
" >"$client_conf"

    # Add client to server configuration
    echo "
# Client $client_name
[Peer]
PublicKey = $client_public_key
AllowedIPs = 10.0.0.$client_ip/32
" >>"$server_config"

    # Restart WireGuard to apply changes
    wg-quick down wg0 && wg-quick up wg0

    echo "Client $client_name added. Configuration file located at $client_conf"
}

main() {
    add_client "$@"
}

# Run the main function
[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
