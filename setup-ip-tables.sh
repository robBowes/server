#!/bin/bash

# Bash best practices and style-guide
set -eo pipefail

# Global constants (readonly)
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

# Default values for arguments
readonly DEFAULT_PORT="51820"
readonly DEFAULT_INTERFACE="wg0"

# Function to setup iptables rules
setup_iptables() {
    local port="${1:-$DEFAULT_PORT}"
    local interface="${2:-$DEFAULT_INTERFACE}"

    echo "Setting up iptables for WireGuard on port $port and interface $interface..."

    # Add your iptables rules here
    # Example:
    sudo iptables -A INPUT -p udp -m udp --dport "$port" -j ACCEPT
    sudo iptables -A FORWARD -i "$interface" -j ACCEPT
    sudo iptables -A FORWARD -o "$interface" -j ACCEPT
    sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

    echo "iptables setup complete."
}

# Function to handle command line arguments
cmdline() {
    local arg=
    for arg; do
        local delim=""
        case "$arg" in
        --port) args="${args}-p " ;;
        --interface) args="${args}-i " ;;
        --help) args="${args}-h " ;;
        *)
            [[ "${arg:0:1}" == "-" ]] || delim="\""
            args="${args}${delim}${arg}${delim} "
            ;;
        esac
    done

    eval set -- $args

    while getopts "hp:i:" OPTION; do
        case $OPTION in
        h)
            echo "Usage: $PROGNAME [--port <port>] [--interface <interface>]"
            exit 0
            ;;
        p)
            readonly PORT=$OPTARG
            ;;
        i)
            readonly INTERFACE=$OPTARG
            ;;
        esac
    done
    return 0
}

# Main function
main() {
    cmdline "$@"
    setup_iptables "$PORT" "$INTERFACE"
}

# Entry point
[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
