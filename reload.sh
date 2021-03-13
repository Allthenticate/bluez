#!/usr/bin/env sh
sudo make clean
sudo systemctl stop bluetooth
sudo make uninstall
./configure --prefix=/usr --mandir=/usr/share/man --sysconfdir=/etc --localstatedir=/var --enable-library --enable-experimental --enable-deprecated --enable-maintainer-mode --with-dbusconfdir=/usr/share
make -j 4
sudo ./src/bluetoothd -n -P battery -d --experimental -f ./src/main.conf
#sudo make install
#sudo sed -i -e 's/ExecStart=.*/ExecStart=\/usr\/libexec\/bluetooth\/bluetoothd  -n -C -P battery -d --experimental /' /lib/systemd/system/bluetooth.service
#sudo ../../scripts/update_bluez_config.sh /etc/dbus-1/system.d/bluetooth.conf
#sudo systemctl daemon-reload
#sudo systemctl unmask bluetooth
#sudo systemctl restart bluetooth
