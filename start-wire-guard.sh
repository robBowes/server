#!/bin/bash

# Fail fast and be aware of exit codes
set -eo pipefail

# Global constants (readonly)
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

start_wireguard() {
    # Local variables
    local interface="wg0"

    # Start WireGuard
    wg-quick up $interface
    echo "WireGuard interface $interface is up."
}

main() {
    start_wireguard "$@"
}

# Run the main function
main "$@"
