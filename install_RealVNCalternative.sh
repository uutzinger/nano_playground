# Raspberry Pi provides VNCConnect services which is not available for arm 64 as raspian runs a 32bit OS
# 
# The alternative is to install OpenVPN server on a raspberry pi 
# to access the home network
# 1) obtain DNS domain, e.g. through FreeDNS
# 2) create Raspberry Pi server in home network with static IP and ddclient
# 3) install Pi-Hole for DNS service and advertisign blocking
# 4) install Pi-VPN, use the free domain name you registered at FreeDNS
# 5) Configure OpenVPN
# 6) Create certigicate for you outside computers such as phone, labtop etc.
# 7) Install OpenVPN VPN on your client computers
#
#
# Remote Access with NAT traverse suggestion:
# No Machine
sudo apt-get install cups # printing services
# with brwoser
# https://www.nomachine.com/download/download&id=116&s=ARM
# download the tar.gz and arm6, ARMv8 version and follow instructions
sudo /usr/NX/nxserver --install
sudo /usr/NX/scripts/setup/nxnode --printingsetup

