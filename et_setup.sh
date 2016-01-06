#!/bin/bash

# Updates
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install python3-pip
sudo apt-get -y install tmux
sudo apt-get -y install gdb gdb-multiarch
sudo apt-get -y install unzip
sudo apt-get -y install foremost
sudo apt-get -y install ipython
sudo apt-get -y install libffi-dev
sudo apt-get -y install libssl-dev

cd /home/vagrant || exit
mkdir tools
cd tools || exit

( # Install Binjitsu
  sudo apt-get -y install python2.7 python-pip python-dev git
  sudo pip install pyopenssl ndg-httpsclient pyasn1
  sudo pip install --upgrade git+https://github.com/binjitsu/binjitsu.git
)

( # Install pwndbg
  git clone https://github.com/zachriggle/pwndbg
  sudo pip3 install pycparser # Use pip3 for Python3
  echo "source $(pwd)/pwndbg/gdbinit.py" >> ~/.gdbinit
)

( # Install capstone
  git clone https://github.com/aquynh/capstone
  cd capstone || exit
  git checkout -t origin/next
  sudo ./make.sh install

  cd bindings/python || exit
  sudo python3 setup.py install

  sudo pip uninstall capstone
  sudo python2 setup.py install
)

( # Install radare2
  git clone https://github.com/radare/radare2
  cd radare2 || exit
  ./sys/install.sh
)

( # Install binwalk
  git clone https://github.com/devttys0/binwalk
  cd binwalk || exit
  sudo python setup.py install
  sudo apt-get install squashfs-tools
)

( # Personal config
  sudo sudo apt-get -y install stow
  cd /home/vagrant || exit
  rm .bashrc
  git clone https://github.com/thebarbershopper/dotfiles
  cd dotfiles || exit
  ./install.sh
)

( # Install Angr
  sudo apt-get -y install python-dev libffi-dev build-essential
  git clone https://github.com/angr/angr-dev
  cd angr-dev || exit
  sudo ./setup.sh -i -e angr
)

( # Install american-fuzzy-lop
  sudo apt-get -y install clang llvm
  wget --quiet http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
  tar -xzvf afl-latest.tgz
  rm afl-latest.tgz
  cd afl-* || exit
  make
  ( # build clang-fast
    cd llvm_mode || exit
    make
  )
  sudo make install
)

( # Install 32 bit libs
  sudo dpkg --add-architecture i386
  sudo apt-get update
  sudo apt-get -y install libc6-dev:i386 libncurses5:i386 libstdc++6:i386
)
