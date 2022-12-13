#!/usr/bin/env bash
# Script to setup the dotfiles automagically.
self=$(readlink -f "$BASH_SOURCE")
self_name=$(basename "$self")
self_dir=$(dirname "$self")
root_dir="$self_dir"
orig_dir=`pwd`

. $self_dir/common.sh

function skip_setup {
    local no_force_reason="$1"
    if [[ -z "$no_force_reason" ]]; then
        test "$force" == "true" && return 1
        echo " - Already setup, use -f (force) to force setup again."
    else
        echo " - Already setup, can't be forced: ${no_force_reason}."
    fi
    return 0
}

function is_link_only {
    test "$link_only" == "true"
}

function is_stage_active {
    local requested="$1"
    # Check explicitly excluded
    while read -r stage; do
        test "$stage" == "$requested" && return 1
    done <<< "$exclude"
    # Check explicitly included
    while read -r stage; do
        test "$stage" == "all" && return 0
        test "$stage" == "$requested" && return 0
    done <<< "$include"
    return 1
}

function setup_dotfiles {
    is_stage_active "dotfiles" || return 0
    echo
    echo "Setting up dotfiles..."
    python $self_dir/symlink.py 1>/dev/null
    check_failure || echo_ok
}

function setup_fonts {
    is_stage_active "fonts" || return 0
    which fc-cache &>/dev/null || return 0
    echo
    echo "Setting up fonts..."
    local fonts_home="$HOME/.fonts"
    test -d "$fonts_home" && skip_setup && return 0
    fc-cache -vf "$fonts_home" 1>/dev/null
    check_failure || echo_ok
}

function setup_vundle {
    is_stage_active "vundle" || return 0
    echo
    echo "Setting up Vim Bundle (Vundle)..."
    vundle_repo="https://github.com/VundleVim/Vundle.vim"
    vundle_home="$HOME/.vim/vundle"
    sync_git "$vundle_repo" "$vundle_home"
    vim -c PluginInstall -c qall
    check_failure || echo_ok
}

function usage {
    cat <<-EOH
Setup dotfiles and environment.

Usage: ./$self_name [options]
  -e <stages(s)> A CSV-list of stages to exclude (default: $exclude).
                   See -i for a full list of stages.
  -f             Force setup (by default anything that has already been setup
                   before will be skipped.)
  -i <stage(s)> A CSV-list of stages to execute (default: $include)
                   Stages, in order (asterisks are desktop-only):
                    - dotfiles: Link dotfiles.
                    - fonts: Setup terminal fonts.
                    - vundle: Install Vim Bundle (Vundle) plugins.
                   E.g. to only link dotfiles, use -i dotfiles.
  -h           Display usage (this text)

EOH
    exit 0
}

#
# START MAIN SCRIPT
#

# Variables
force="false"
include=$(cat "$self_dir/stages.txt" | grep -oP "(?<=include=).*" | head -n 1)
exclude=$(cat "$self_dir/stages.txt" | grep -oP "(?<=exclude=).*" | head -n 1)

# Get options
while getopts ":e:fhi:m:" OPT; do
    case $OPT in
        e) exclude="$OPTARG" ;;
        f) force="true" ;;
        h) usage ;;
        i) include="$OPTARG" ;;
        :) die "Error - Option -$OPTARG requires an argument." ;;
        ?) die "Error - Invalid option -$OPTARG (see -h for help)." ;;
    esac
done

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

# Check required tools
tool_exists git
tool_exists pip
tool_exists python

setup_dotfiles
setup_fonts
setup_vundle

echo
echo "You're ready to rock!"
echo
echo "Try sourcing your .bashrc ('. ~/.bashrc') or restarting your shell."
