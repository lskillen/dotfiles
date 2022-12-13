# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

SSH_AGENT_FILE="$HOME/.sshagent"

function check-ssh-agent
{
    [ -S "$SSH_AUTH_SOCK" ] && { ssh-add -l >& /dev/null || [ $? -ne 2 ]; }
}

function start-agent
{
    check-ssh-agent || {
        [ -f "$SSH_AGENT_FILE" ] && {
            . "$SSH_AGENT_FILE" > /dev/null
            check-ssh-agent || { rm -f $SSH_AGENT_FILE && start-agent; }
        } || {
            echo "Starting new SSH agent ..."
            ssh-agent -s | sed 's/^echo/#echo/' > "${SSH_AGENT_FILE}"
            chmod 600 "$SSH_AGENT_FILE"
            start-agent
        }
    }
}

start-agent

export EDITOR=vim
export VISUAL=vim
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export PYTHONDONTWRITEBYTECODE=1
export AWS_VAULT_PASS_PREFIX=aws-vault
export AWS_VAULT_BACKEND=pass
export GOPATH="$HOME/.go"
export PATH=$PATH:/usr/local/go/bin:$HOME/.go/bin
export PATH="$HOME/.cargo/bin:$PATH"

set -o vi

test "$PATH" == *"$HOME/.bin"* || export PATH="$PATH:$HOME/.bin"

if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
    powerline-daemon -q

fi

if [ -z "$POWERLINE_HOME" ]; then
  command -v pip &>/dev/null
  if [ $? -eq 0 ]; then
      export POWERLINE_HOME="$(pip show powerline-status | grep Location: | awk '{ print $2 }')"
  fi
fi

if [ -z "$POWERLINE_HOME" ]; then
    export POWERLINE_HOME="$HOME/.vim/bundle/powerline"
fi

POWERLINE_SCRIPTS="$POWERLINE_HOME/scripts"
if [ -d "$POWERLINE_SCRIPTS" ]; then
    if [ "${PATH/$POWERLINE_SCRIPTS/}" != "$POWERLINE_SCRIPTS" ]; then
        export PATH="$PATH:$POWERLINE_SCRIPTS"
    fi
fi

export POWERLINE_BINDINGS="$POWERLINE_HOME/powerline/bindings"
POWERLINE_BASH="$POWERLINE_BINDINGS/bash/powerline.sh"
if [ -f "$POWERLINE_BASH" ]; then
    # See: https://powerline.readthedocs.org/en/latest/usage/shell-prompts.html#bash-prompt
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source $POWERLINE_BASH
    export POWERLINE_COMMAND
    export POWERLINE_CONFIG_COMMAND
fi

command -v direnv &>/dev/null && eval "$(direnv hook bash)"

[ -n "$TMUX" ] && export TERM=screen-256color
