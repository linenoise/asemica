#!/bin/bash
chmod +x install.sh

# Get directory name of `asemica.pl`
PT= ln -s asemica.pl

# Install Python, Perl
os=${OSTYPE//[0-9.-]*/}
case "$os" in

  darwin) # Apple/Mac
  ;;

  msys) # Windows
  ;;

  linux)
  apt-get update
  apt-get upgrade
  apt-get install python3
  apt-get install perl

  exit 1
esac

chmod +x median.py
./median.py
