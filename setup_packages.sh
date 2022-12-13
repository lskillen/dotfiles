#!/usr/bin/env bash
# Script to install packages.
self=$(readlink -f "$BASH_SOURCE")
self_name=$(basename "$self")
self_dir=$(dirname "$self")
root_dir="$self_dir"
orig_dir=`pwd`

. $self_dir/common.sh

function setup_packages {
    echo
    echo "Setting up packages..."
    echo " - Updating Apt"
    apt update
    while read -r package; do
        echo " - Installing $package..."
        apt-get install -y $package 1>/dev/null
    done < <(cat "$self_dir/packages.txt")
    check_failure || echo_ok
}

# Cleanup after completion
function finish {
    cd $orig_dir
}

function graceful_exit {
    echo "Caught signal, gracefully exiting ..."
    exit 1
}

trap graceful_exit SIGINT SIGTERM
trap finish exit

ensure_sudo
setup_packages
