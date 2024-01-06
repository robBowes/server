#!/bin/bash

# Fail fast and be aware of exit codes
set -eo pipefail

# Global constants (readonly)
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

setup_wireguard() {
    # Local variables
    local config_path="/etc/wireguard/wg0.conf"
    local ip_address=$1 # Get the IP address from the first script argument

    # Validate the IP address
    if [[ -z "$ip_address" ]]; then
        echo "IP address is required. Usage: $PROGNAME <ip-address>"
        exit 1
    fi

    mkdir -p /etc/wireguard
    touch $config_path

    # Generate keys (private and public)
    local private_key=$(wg genkey)
    local public_key=$(echo "$private_key" | wg pubkey)

    # Create WireGuard configuration
    echo "[Interface]
PrivateKey = $private_key
Address = $ip_address/24
ListenPort = 51820
SaveConfig = true
" >$config_path

    echo "Setup complete. Configuration file located at $config_path"
}

main() {
    setup_wireguard "$@"
}

# Run the main function
main "$@"
