Disclaimer
----------

USE THESE DOTFILES AT YOUR OWN RISK.  These dotfiles meet my own requirements,
but they may not meet yours (or worse, ruin them).  Subsequent changes may break
your environment and I cannot be held responsible for it doing so (feel free to
send gripes about it though, and I'll try to help fix it.) Also, the Python
code is terrible; written hastily in early 2013. HERE BE DRAGONS! :)

Dotfiles
========

Hi!  This is the repository for my dotfiles setup, including:

- Highly customised vim installation with vundle + plugins (see vimrc)
- Solarized colourscheme for both vim and gnome-terminal [desktop].
- Installation of system-wide packages (see packages.txt) [desktop].
- Installation of python packages (see requirements.txt).

Please refer the simple/extended usage to see how this works.

Installation
------------

- Clone
- Execute setup.sh (from anywhere, see extended usage for more options).
- Enjoy!

The default setup will install for desktop environments and MUST be run under
sudo in order to install system packages (etc.)

Extended Usage
--------------

```
Usage: ./setup.sh [options]
  -e <stages(s)> A CSV-list of stages to exclude (default: ).
                   See -i for a full list of stages.
  -f             Force setup (by default anything that has already been setup
                   before will be skipped.)
  -m <mode>      Mode to setup (desktop/server, default: desktop)
                   This influences what is installed, where server mode
                   is for headless or terminal-only servers, possibly
                   without sudo access.  See -i for a full list of stages.
  -i <stage(s)> A CSV-list of stages to execute (default: all)
                   Stages (asterisks are desktop-only):
                    - dotfiles: Link dotfiles.
                    * fonts: Setup terminal fonts.
                    * libgcrypt11: Setup libgcrypt11 (Ubuntu 15.04+ only).
                    * packages: Install packages from packages.txt
                    - pip: Install pip/python packages from requirements.txt
                   E.g. to only link dotfiles, use -i dotfiles.
  -h           Display usage (this text)
```

Making Changes
--------------

If you want to submit changes back then please issue a pull request.
Procedure:

- Fork the repository and make your changes on a new feature branch.
- Raise a pull request to merge from that feature branch.
- Detail what the changes are for and whether they are specific to OS/Env.

Note: If the changes are customisation rather than fixes to the scripts or for
additional features then I'm not likely to accept them - I might split the repo
into two in the future to make this easier (i.e. one for scripts, one for the
customisations).

Further Reading
---------------

Check out: http://dotfiles.github.io/

