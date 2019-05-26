#Conflicts with node9, add code to remove node9 if user allows.
echo "Install will include NodeJS 8 and Yarn"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# Yarn package repo
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Install packages
sudo apt update
sudo apt install -y libx11-dev libxkbfile-dev libsecret-1-dev fakeroot npm curl nodejs nodejs-dev yarn

# Clone repo
git clone https://github.com/Microsoft/vscode.git

cd vscode

sudo rm package.json
sudo rm test/smoke/package.json
#clones the first pkg.json into the Vscode folder.
git clone https://gist.github.com/e0010219e8af5e6cb4c4d34c35bba47d.git
cd test/smoke/
git clone https://gist.github.com/121e97781a56ae3e051335f77d2c600d.git
cd ..
cd ..

# Fetch deps, build, and create deb
yarn
yarn run watch
./scripts/code.sh

# Reboot
code-oss

