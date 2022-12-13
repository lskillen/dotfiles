# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -h --group-directories-first'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

set -o vi

test "$PATH" == *"$HOME/.bin"* || export PATH="$PATH:$HOME/.bin"
test "$PATH" == *"$HOME/.chefdk/gem/ruby/2.3.0/bin"* || export PATH="$PATH:$HOME/.chefdk/gem/ruby/2.3.0/bin"
test "$PATH" == *"$HOME/.gem/ruby/2.3.0/bin"* || export PATH="$PATH:$HOME/.gem/ruby/2.3.0/bin"
export EDITOR=vim
export VISUAL=vim
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export PYTHONDONTWRITEBYTECODE=1
export SOLVE_TIMEOUT=300
export AWS_VAULT_PASS_PREFIX=aws-vault
export AWS_VAULT_BACKEND=pass

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

if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi

# added by travis gem
[ -f /home/lskillen/.travis/travis.sh ] && source /home/lskillen/.travis/travis.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -n "$TMUX" ] && export TERM=screen-256color

export GOPATH="$HOME/.go"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias run-ngrok="dc run --service-ports --rm ngrok"
alias run-web="aws-vault exec dev-lee-instance -- dc up --build web"
alias run-web-nodebug="DEBUG=false aws-vault exec dev-lee-instance -- dc up --build web"
alias run-web-jit="JIT_ASSETS=true aws-vault exec dev-lee-instance -- dc up --build web"
alias run-dd="aws-vault exec dev-lee-instance -- dc up --build ddagent"
alias run-worker="aws-vault exec dev-lee-instance -- dc up --build worker"
alias run-command="dc run web python -m cloudsmith $@"
alias run-shell="run-command shell_plus $@"
alias run-makemigrations="run-command makemigrations $@"
alias run-migrate="run-command migrate $@"
alias run-bash="dc run --rm web bash"
