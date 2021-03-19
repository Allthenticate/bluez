#!/usr/bin/env sh

sudo apt-get install -y libusb-dev libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev

# Remove old bluez
sudo make clean
sudo systemctl stop bluetooth
sudo make uninstall

# Configure and make
./configure
sudo make -j 2

#sudo ./src/bluetoothd -n -P battery -d --experimental -f ./src/main.conf
sudo make install
sudo sed -i -e 's/ExecStart=.*/ExecStart=\/usr\/local\/libexec\/bluetooth\/bluetoothd -C -P battery -d --experimental /' /lib/systemd/system/bluetooth.service

# Get the proper configuration file
sudo ../../scripts/update_bluez_config.sh src/bluetooth.conf
sudo cp src/bluetooth.conf /etc/dbus-1/system.d/bluetooth.conf

# Reload the config fle
sudo systemctl daemon-reload
sudo systemctl unmask bluetooth
sudo systemctl restart bluetooth
