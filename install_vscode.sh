############################################################################33
#
# Visual Studio Code
#
# References
#  https://github.com/rbonghi/jetson_easy
#  https://medium.com/@kcchien/jetson-nano-%E5%AE%89%E8%A3%9D-visual-studio-code-a26a279293e6
#  https://devtalk.nvidia.com/default/topic/1049448/jetson-nano/quick-build-guide-for-visual-studio-code-on-the-nano/
#
# Urs Utzinger, Summer 2019
############################################################################33

# Here are three different approaches to install Code OSS
#########################################################

# 1) Microsoft Version
############################
wget https://github.com/toolboc/vscode/releases/download/1.32.3/code-oss_1.32.3-arm64.deb
sudo dpkg -i code-oss_1.32.3-arm64.deb

# 2) Headmelted Version
############################
# Install the rep keys and setup
wget -O script.deb.sh https://packagecloud.io/install/repositories/headmelted/codebuilds/script.deb.sh 
sudo bash script.deb.sh
# Run the installation script
wget -O vscodeInstall.sh https://code.headmelted.com/installers/apt.sh
sudo bash vscodeInstall.sh

# 3) Build from scratch
#############################################################
# Need curl
sudo apt-get install curl
# Yarn package repo
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
# Install node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
# Follow instuctions to close and open new terminal
nvm ls-remote
# Install version compatible with yarn. 
# When you run yarn in vscode directory it will tell you wich version range is compatible, for me this is working:
nvm install v12.13.0 # latest Long Term Support version
node --version

# Install packages
# Make sure your swap is 4 gb
# Edit sudo gedit /usr/bin/init-zram-swapping and follow zram change description here:
# https://pysource.com/2019/08/26/install-opencv-4-1-on-nvidia-jetson-nano/
sudo apt-get update
sudo apt-get install -y libx11-dev libxkbfile-dev libsecret-1-dev
sudo apt-get install -y fakeroot npm 
sudo apt-get install -y yarn
# Clone repo
git clone --branch 1.40.0 https://github.com/Microsoft/vscode.git
cd vscode
# Reduce max_old_space_size
sed -i 's/4095/2048/g' package.json
yarn
yarn run gulp vscode-linux-arm64-min
yarn run gulp vscode-linux-arm64-build-deb
sudo dpkg -i ./.build/linux/deb/arm64/deb/code-oss_1.??.?-*_arm64.deb
# Enable Extension Library
sudo nano /usr/share/code-oss/resources/app/product.json
# add
#"extensionsGallery" : { 
#   "serviceUrl" : "https://marketplace.visualstudio.com/_apis/public/gallery",
#   "cacheUrl" : "https://vscode.blob.core.windows.net/gallery/index",
#   "itemUrl" : "https://marketplace.visualstudio.com/items"
#} 

# Reboot
code-oss

# If menu is missing
#  Ctrl + Shift + P
#  Preferences: Open user settings
#  Window title bar style
#  Change  to custom 




