#!/bin/bash

xfce4-panel --quit
pkill xfconfd
rm -rf ~/.config/xfce4/panel
rm -rf ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
xfce4-panel
