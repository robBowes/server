#!/bin/bash

# Fail fast and be aware of exit codes
set -eo pipefail

# Global constants (readonly)
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

stop_wireguard() {
    # Local variables
    local interface="wg0"

    # Stop WireGuard
    wg-quick down $interface
    echo "WireGuard interface $interface is down."
}

main() {
    stop_wireguard "$@"
}

# Run the main function
main "$@"
