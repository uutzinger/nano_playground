############################################################################33
#
# Visual Studio Code
#
# References
#  https://github.com/rbonghi/jetson_easy
#  https://medium.com/@kcchien/jetson-nano-%E5%AE%89%E8%A3%9D-visual-studio-code-a26a279293e6
#
# Urs Utzinger, Summer 2019
############################################################################33

# Need curl
sudo apt-get install curl

# Yarn package repo
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Install node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
# Follow instuctions to close and open new terminal
nvm ls-remote
# Install version compatible with yarn. 
# When you run yarn in vscode directory it will tell you wich version range is compatible, for me this is working:
nvm install v10.16.0 # latest Long Term Support version
node --version

# Install packages
sudo apt-get update
sudo apt-get install -y libx11-dev libxkbfile-dev libsecret-1-dev
sudo apt-get install -y fakeroot npm 
sudo apt-get install -y yarn

# Clone repo
git clone https://github.com/Microsoft/vscode.git
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




