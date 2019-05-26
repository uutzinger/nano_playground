#####################################################################################
# 
# Purge for minimal AI system
# No office tools and reduced unity lens and scope needed
#
# [If you copy paste this into shell you need to copy paste each line]
#####################################################################################

#####################################################################################
# Purge lens
sudo apt remove --purge unity-lens-friends -y
sudo apt remove --purge unity-lens-music -y
sudo apt remove --purge unity-lens-music -y
sudo apt remove --purge unity-lens-photos -y
sudo apt remove --purge unity-lens-video -y
# Purge scope
sudo apt remove --purge unity-scope-audacious -y
sudo apt remove --purge unity-scope-calculator -y
sudo apt remove --purge unity-scope-chromiumbookmarks -y
sudo apt remove --purge unity-scope-clementine -y
sudo apt remove --purge unity-scope-colourlovers -y
sudo apt remove --purge unity-scope-devhelp -y
sudo apt remove --purge unity-scope-firefoxbookmarks -y
sudo apt remove --purge unity-scope-gdrive -y
sudo apt remove --purge unity-scope-gmusicbrowser -y
sudo apt remove --purge unity-scope-gourmet -y
sudo apt remove --purge unity-scope-guayadeque -y
sudo apt remove --purge unity-scope-manpages -y
sudo apt remove --purge unity-scope-musicstores -y
sudo apt remove --purge unity-scope-musique -y
sudo apt remove --purge unity-scope-openclipart -y
sudo apt remove --purge unity-scope-exdoc -y
sudo apt remove --purge unity-scope-tomboy -y
sudo apt remove --purge unity-scope-video-remote -y
sudo apt remove --purge unity-scope-virtualbox -y
sudo apt remove --purge unity-scope-yelp -y
sudo apt remove --purge unity-scope-zotero -y
# Purge libre office
sudo apt remove --purge libreoffice* -y
#
sudo apt-get clean -y
sudo apt autoremove -y
sudo apt-get update





