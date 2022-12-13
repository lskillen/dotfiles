
function die {
    echo $@ 1>&2
    exit 1
    return 1
}

function tool_exists {
    which $1 &>/dev/null
    if [[ $? -ne 0 ]]; then
      die "$1 is not installed (hint: run setup_packages.sh first)"
    fi
}

function check_failure {
    local rc=${1:-$?}
    test $? -eq 0 || die "   = Failed!"
    return 1
}

function echo_ok {
    echo "   = OK!"
}

function is_sudo {
    [ "$(id -u)" -eq 0 ] || return 1
    [ "$SUDO_USER" != "" ] || return 1
    return 0
}

function ensure_sudo {
    is_sudo || die "You must run this script as sudo!"
}

function run_as_sudo {
    ensure_sudo
    sudo -H $*
}

function run_as_user {
    is_sudo && {
        sudo -H -u $SUDO_USER $*
    } || {
        $*
    }
}

function sync_git {
    local url="$1"
    local dir="${2:-$(basename $url)}"
    echo " - Synchronising $url ..."
    local exists="false"
    (test -d "$dir/.git" &&
        git --git-dir "$dir/.git" status &>/dev/null) && {
        exists="true"
        (cd "$dir" && git pull 1>/dev/null)
    } || (git clone "$url" "$dir" 1>/dev/null)
    check_failure
    test "$exists" == "true" && return 2
    return 0
}

