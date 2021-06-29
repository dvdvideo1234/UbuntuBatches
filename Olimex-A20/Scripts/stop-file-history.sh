#!/bin/bash

# Disable recent accessed files list.

sudo gsettings set org.gnome.desktop.privacy remember-recent-files false

sudo rm ~/.local/share/recently-used.xbel        # clear current file history
sudo touch ~/.local/share/recently-used.xbel     # create a 0-byte history file
sudo chattr +i ~/.local/share/recently-used.xbel # make it readonly
