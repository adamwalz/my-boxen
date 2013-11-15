#!/bin/sh
#------------------------------------------------------------------------------
#          FILE:  install.sh
#   DESCRIPTION:  Bootstraps the installation of boxen and links dotfiles
#        AUTHOR:  Adam Walz <adam@adamwalz.net>
#       VERSION:  1.0.0
#------------------------------------------------------------------------------

sudo mkdir -p /opt/boxen
sudo chown ${USER}:staff /opt/boxen
git clone https://github.com/adamwalz/my-boxen /opt/boxen/repo
/opt/boxen/repo/script/boxen
