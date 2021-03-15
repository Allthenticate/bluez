#!/usr/bin/env sh

# TODO requirements

# Remove old bluez
sudo make clean
sudo systemctl stop bluetooth
sudo make uninstall

# Configure and make
./configure --prefix=/usr --mandir=/usr/share/man --sysconfdir=/etc --localstatedir=/var --enable-library --enable-experimental --enable-deprecated --enable-maintainer-mode --with-dbusconfdir=/usr/share 2>errors.txt
make -j 4

#sudo ./src/bluetoothd -n -P battery -d --experimental -f ./src/main.conf
sudo make install
sudo sed -i -e 's/ExecStart=.*/ExecStart=\/usr\/libexec\/bluetooth\/bluetoothd -C -P battery -d --experimental /' /lib/systemd/system/bluetooth.service

# Get the proper configuration file
sudo ../../scripts/update_bluez_config.sh src/bluetooth.conf
sudo cp src/bluetooth.conf /etc/dbus-1/system.d/bluetooth.conf

# Reload the config fle
sudo systemctl daemon-reload
sudo systemctl unmask bluetooth
sudo systemctl restart bluetooth
