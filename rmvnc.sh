#!/bin/bash
sudo rm /usr/share/man/man1/vncviewer.1
sudo rm /usr/share/man/man1/vncaddrbook.1
sudo rm /usr/share/man/man1/vncserver-x11.1
sudo rm /usr/share/man/man1/Xvnc.1
sudo rm /usr/share/man/man1/vncserver-virtual.1
sudo rm /usr/share/man/man1/vncserver-virtuald.1
sudo rm /usr/share/man/man1/vncserver-x11-serviced.1
sudo rm /usr/share/man/man1/vncpasswd.1
sudo rm /usr/share/man/man1/vnclicense.1
sudo rm /usr/share/man/man1/vncinitconfig.1
sudo rm /etc/pam.d/vncserver

sudo rm -r /root/.vnc
sudo rm -r /usr/lib/vnc
sudo rm -r /usr/share/vnc
sudo rm -r /usr/lib/cups/vnc
sudo rm -r /usr/lib/cups/backend/vnc
sudo rm -r /usr/share/vnc
sudo rm -r /etc/vnc

for f in vncviewer vncaddrbook vncserver-x11 vncserver-x11-core Xvnc Xvnc-core \
         vncserverui vncserver-virtual vncserver-virtuald \
         vncserver-x11-serviced vncpasswd vnclicense vnclicensewiz \
         vnclicensehelper vncpipehelper vncinitconfig vncserver; do
    sudo rm "/usr/bin/$f"
done
