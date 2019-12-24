#!/bin/bash -v
chmod +x run.sh

# Get directory name of `asemica.pl`
PT=$(dirname ~/asemica.pl)
echo $PT >perlpath.txt

os=${OSTYPE//[0-9.-]*/}
case "$os" in

  msys) # Windows
    python -v
    perl -v
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
