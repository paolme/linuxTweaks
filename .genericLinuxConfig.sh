#!/bin/sh
# Sets up ssh stuff, some bash goodies,
# and a vimrc, should work on any linux distro.
# Also Emacs.

# wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/.genericLinuxConfig.sh -P ~/; sh ~/.genericLinuxConfig.sh

# PGP:
if [ ! -d ~/pgp/ ] && [ "`which keybase`" ]; then
    cd
    git clone keybase://private/rpcm/pgp ~/pgp
    cd
fi

# SSH:
if [ ! -d ~/.ssh/ ] && [ "`which keybase`" ]; then
    cd
    git clone keybase://private/rpcm/ssh ~/.ssh
    chmod 700 ~/.ssh/
    chmod 400 ~/.ssh/*
    chmod 444 ~/.ssh/id_rsa.pub
    chmod 600 ~/.ssh/config
    chmod 644 ~/.ssh/known_hosts
    cd
fi

# Copy this version if you do not have sudo:
#echo >> /etc/profile.d/START_SSH_AGENT; echo 'if [ -z "$SSH_AUTH_SOCK" ]; then' >> /etc/profile.d/START_SSH_AGENT; echo '    eval `ssh-agent`' >> /etc/profile.d/START_SSH_AGENT; echo '    ssh-add' >> /etc/profile.d/START_SSH_AGENT; echo 'fi' >> /etc/profile.d/START_SSH_AGENT; echo >> /etc/profile.d/START_SSH_AGENT

# Start the ssh-agent so we can clone away without
# entering a passphrase several times:
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval `ssh-agent`
    ssh-add
fi

# Get vimrc, and set up git config:
curl https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/.gitVimNORMALorROOT.sh | sh

# Emacs!
wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/.emacs -P ~/

# Sublime!
wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/.installSublimeStuff.sh -P ~/
bash ~/.installSublimeStuff.sh

SUBLIME_MERGE_CONFIG_DIR=~/.config/sublime-merge/Packages/User
if [ -d "${SUBLIME_MERGE_CONFIG_DIR}" ]; then
    wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/SublimeMerge/Preferences.sublime-settings -P "${SUBLIME_MERGE_CONFIG_DIR}"
fi

SUBLIME_TEXT_CONFIG_DIR=~/.config/sublime-text/Packages/User
if [ -d "${SUBLIME_TEXT_CONFIG_DIR}" ]; then
    wget -N https://raw.githubusercontent.com/ryanpcmcquen/sublime_witness/master/Witness.sublime-color-scheme -P "${SUBLIME_TEXT_CONFIG_DIR}"

    wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/SublimeText/C.sublime-settings -P "${SUBLIME_TEXT_CONFIG_DIR}"
    wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/SublimeText/C++.sublime-settings -P "${SUBLIME_TEXT_CONFIG_DIR}"
    wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/SublimeText/Default.sublime-keymap -P "${SUBLIME_TEXT_CONFIG_DIR}"
    wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/SublimeText/Default.sublime-mousemap -P "${SUBLIME_TEXT_CONFIG_DIR}"
    wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/SublimeText/Doxy.sublime-settings -P "${SUBLIME_TEXT_CONFIG_DIR}"
    wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/SublimeText/orgmode.sublime-settings -P "${SUBLIME_TEXT_CONFIG_DIR}"
    wget -N https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/SublimeText/Preferences.sublime-settings -P "${SUBLIME_TEXT_CONFIG_DIR}"
    # If we haven't installed Package Control yet, get some of my faves:
    if [ ! -e "${SUBLIME_TEXT_CONFIG_DIR}/Package Control.sublime-settings" ]; then
        wget -N "https://raw.githubusercontent.com/ryanpcmcquen/linuxTweaks/master/SublimeText/Package Control.sublime-settings" -P "${SUBLIME_TEXT_CONFIG_DIR}"
    fi
fi

# U2F:
sudo wget -N https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules -P /etc/udev/rules.d/

# Map Caps lock to Ctrl!
#
# Note about the option chosen here:
#
# caps:ctrl_modifier and ctrl:nocaps are defined in
# symbols/capslock and symbols/ctrl respectively.
#
# Looking at their definition it seems that ctrl_modifier
# will make Caps a Control modifier but still send the
# Caps_Lock keysym. Whereas nocaps has Caps send the
# actual Control_L keysym.
#
# Source: https://www.reddit.com/r/commandline/comments/4gusjx/setxkbmap_whats_the_difference_between_capsctrl/d2lvni3/
sudo sed -i 's/XKBOPTIONS=.*/XKBOPTIONS="ctrl:nocaps"/g' /etc/default/keyboard

# IBM Plex fonts:
wget -N \
    $(curl https://api.github.com/repos/IBM/plex/releases/latest | grep TrueType | grep browser_download | cut -d \" -f 4) \
    -P /tmp/

IBM_PLEX_DIR_NAME=ibm_plex_mono
if [ -e /tmp/TrueType.zip ]; then
    mkdir -p /tmp/${IBM_PLEX_DIR_NAME}/
    unzip -o /tmp/TrueType.zip -d /tmp/${IBM_PLEX_DIR_NAME}/
    sudo cp -R /tmp/${IBM_PLEX_DIR_NAME}/TrueType/* /usr/share/fonts/truetype/
    rm -rf /tmp/${IBM_PLEX_DIR_NAME}/
fi

# JetBrains Mono:
wget -N \
    $(curl https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest | grep browser_download | cut -d \" -f 4) \
    -P /tmp/

JET_BRAINS_DIR_NAME=jet_brains_mono
JET_BRAINS_MONO_ARCHIVE="$(find /tmp/ -maxdepth 1 -iname 'JetBrainsMono-*.zip')"
if [ "$(echo ${JET_BRAINS_MONO_ARCHIVE})" ]; then
    mkdir -p /tmp/${JET_BRAINS_DIR_NAME}/
    unzip -o "${JET_BRAINS_MONO_ARCHIVE}" -d /tmp/${JET_BRAINS_DIR_NAME}/
    sudo cp -R /tmp/${JET_BRAINS_DIR_NAME}/ttf/* /usr/share/fonts/truetype/
    rm -rf /tmp/${JET_BRAINS_DIR_NAME}/
fi

# Office Code Pro:
wget -N \
    $(curl https://api.github.com/repos/nathco/Office-Code-Pro/releases/latest | grep zipball_url | cut -d \" -f 4) \
    -O /tmp/office_code_pro.zip

OFFICE_CODE_PRO_DIR_NAME=office_code_pro
if [ -e /tmp/office_code_pro.zip ]; then
    mkdir -p /tmp/${OFFICE_CODE_PRO_DIR_NAME}/
    unzip -o /tmp/office_code_pro.zip -d /tmp/${OFFICE_CODE_PRO_DIR_NAME}/
    find /tmp/office_code_pro -type d -name 'TTF' -exec sudo cp -R {} /usr/share/fonts/truetype/ \;
    rm -rf /tmp/${OFFICE_CODE_PRO_DIR_NAME}/
fi

if [ -e $HOME/.bashrc ]; then
    if [ -e $HOME/.bash_profile ]; then
        BASHFILE=".bash_profile"
    else
        BASHFILE=".bashrc"
    fi
    # Make ssh less annoying:
    if [ -z "$(grep 'SSH_AUTH_SOCK' ${BASHFILE})" ]; then
        echo >> ~/${BASHFILE}
        echo 'if [ -z "$SSH_AUTH_SOCK" ]; then' >> ~/${BASHFILE}
        echo '    eval `ssh-agent`' >> ~/${BASHFILE}
        echo '    ssh-add' >> ~/${BASHFILE}
        echo 'fi' >> ~/${BASHFILE}
        echo >> ~/${BASHFILE}
    fi
    if [ -z "`grep 'for DIR in' ${BASHFILE}`" ]; then
        echo >> ~/${BASHFILE}
        echo '# Extend path with any /opt/ programs:' >> ~/${BASHFILE}
        echo 'for DIR in /opt/*/bin' >> ~/${BASHFILE}
        echo '    do PATH="$DIR:$PATH"' >> ~/${BASHFILE}
        echo 'done' >> ~/${BASHFILE}
        echo >> ~/${BASHFILE}
        echo '# Extend path with any /usr/local/ stuff, like Heroku:' >> ~/${BASHFILE}
        echo 'for DIR in /usr/local/*/bin' >> ~/${BASHFILE}
        echo '    do PATH="$DIR:$PATH"' >> ~/${BASHFILE}
        echo 'done' >> ~/${BASHFILE}
        echo >> ~/${BASHFILE}
        echo '# Add ~/bin/ to PATH only if it exists, and is not already in $PATH:' >> ~/${BASHFILE}
        echo '[ -d $HOME/bin/ ] && [ -z "$(echo $PATH | grep $HOME)" ] && PATH=$HOME/bin:"$PATH"' >> ~/${BASHFILE}
        echo 'PATH=$HOME/.local/bin:"$PATH"' >> ~/${BASHFILE}
        echo >> ~/${BASHFILE}
        echo
        echo "Enjoy your new PATH goodies!"
        echo
    else
        echo
        echo "You already have the PATH goodies!"
        echo
    fi
else
    echo
    echo "You have no .bashrc or .bash_profile, make one like so:"
    echo "    touch ~/.bashrc"
    echo
    exit 1
fi
