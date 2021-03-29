#!/usr/bin/env sh

# Remove old bluez
sudo make clean
sudo systemctl stop bluetooth
sudo make uninstall

# Get requirements
sudo apt-get update
sudo apt-get install -y libusb-dev libdbus-1-dev libsbc-dev libglib2.0-dev doxygen libudev-dev libical-dev libreadline-dev libjson-c-dev systemtap libcurl4-openssl-dev

# Get ELL
wget https://mirrors.edge.kernel.org/pub/linux/libs/ell/ell-0.38.tar.gz
tar xvf ell-0.38.tar.gz
cd ell-0.38/
./configure
make
sudo make install
cd ..

# Get Elfutils
wget https://sourceware.org/elfutils/ftp/elfutils-latest.tar.bz2
tar xjvf elfutils-latest.tar.bz2
cd elfutils-0.183/
./configure --disable-debuginfod
make
sudo make install
cd ..

# Get JSON-C
git clone https://github.com/json-c/json-c.git
cd json-c
mkdir json-c-build
cd json-c-build
cmake ..
sudo make install
cd ../../

# Configure and make
./bootstrap
./configure --prefix=/usr --mandir=/usr/share/man --sysconfdir=/etc --localstatedir=/var --enable-deprecated --enable-experimental --enable-library --enable-tools --enable-logger --enable-backtrace
make

#sudo ./src/bluetoothd -n -P battery -d --experimental -f ./src/main.conf
sudo make install
sudo sed -i -e 's/ExecStart=.*/ExecStart=\/usr\/local\/libexec\/bluetooth\/bluetoothd -C -P battery -d --experimental /' /lib/systemd/system/bluetooth.service

# Get the proper configuration file
#sudo ../../scripts/update_bluez_config.sh src/bluetooth.conf
sudo cp src/bluetooth.conf /etc/dbus-1/system.d/bluetooth.conf

# Reload the config fle
sudo systemctl daemon-reload
sudo systemctl unmask bluetooth
sudo systemctl restart bluetooth

echo "Done installing bluez!"