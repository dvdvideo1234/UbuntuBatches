#!/bin/bash

# Link configuration output to the manual file

sudo cp /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf.manually-configured
sudo rm -f /etc/resolv.conf
sudo ln -s /etc/resolv.conf.manually-configured /etc/resolv.conf

# Add the DNS name servers providers

sudo sh -c "echo nameserver 8.8.8.8 >> /etc/resolv.conf"
sudo sh -c "echo nameserver 8.8.4.4 >> /etc/resolv.conf"
sudo sh -c "echo nameserver 1.1.1.1 >> /etc/resolv.conf"
sudo sh -c "echo nameserver 1.0.0.1 >> /etc/resolv.conf"
