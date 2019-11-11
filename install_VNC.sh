sudo apt update
sudo apt install vino
# Enable the VNC server to start each time you log in
sudo ln -s ../vino-server.service \
    /usr/lib/systemd/user/graphical-session.target.wants

# Configure the VNC server
gsettings set org.gnome.Vino prompt-enabled false
gsettings set org.gnome.Vino require-encryption false

# Set a password to access the VNC server
# Replace thepassword with your desired password
gsettings set org.gnome.Vino authentication-methods "['vnc']"
gsettings set org.gnome.Vino vnc-password $(echo -n 'thepassword'|base64)

# Reboot the system so that the settings take effect
sudo reboot
vino-preferences

