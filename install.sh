#!/bin/bash -v
chmod +x run.sh

# https://gist.github.com/ctokheim/4507404

# Get directory name of `asemica.pl`
PT=$(dirname ~/asemica.pl)
echo $PT >perlpath.txt

os=${OSTYPE//[0-9.-]*/}
case "$os" in

  darwin) # MacOS
    mkdir -p ~/local
    wget https://www.python.org/ftp/python/3.8.1/python-3.8.1-macosx10.9.pkg    
    tar -xf Python-3.8.1-macosx10.9.pkg
    cd Python-3.8.1-macosx10.9
    ./configure
    make
    make altinstall prefix=~/local
    ln -s ~/local/bin/python2.7 ~/local/bin/python
    cd ..
    easy_install pip
    echo "Will have to install Perl manually
  ;;

  msys) # Windows
    mkdir -p ~/local
    wget https://www.python.org/ftp/python/3.8.1/python/python-3.8.1.exe   
    tar xvzf Python-3.8.1.exe
    cd Python-3.8.1.exe
    ./configure
    make
    make altinstall prefix=~/local
    ln -s ~/local/bin/python2.7 ~/local/bin/python
    cd ..
    python get-pip.py
    echo "Will have to install Perl manually
  ;;

  linux)
    apt-get install python3
    python get-pip.py
    apt-get install perl

  exit 1
esac

pip install flask

chmod +x run.py
./run.py
python run.py
