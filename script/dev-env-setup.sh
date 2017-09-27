#!/bin/bash

####################################################################################################################
# DEVELOPMENT ENVIRONMENT SETUP FOR DEBIAN/UBUNTU LINUX
# THIS IS A SAMPLE OF BASH COMMANDS TO INSTALL THE NECESSARY ENVIRONMENT. DO NOT RUN THIS SCRIPT! RUNNING IT DOES NOT WORK
# see https://stackoverflow.com/questions/29628635/why-is-source-home-vagrant-bashrc-not-working-in-a-vagrant-shell-provisionin
# Furthermore, it was tweaked to run in a vagrant vm. Replace /home/vagrant with $HOME
####################################################################################################################
set -ex

echo "#############################################"
echo "# Installing docker"
echo "#############################################"
# See https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
# Solving permission denied pb.
# See https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/
sudo usermod -a -G docker $USER

echo "#############################################"
echo "# Installing docker-compose"
echo "#############################################"
# See https://docs.docker.com/compose/install/#install-using-pip
sudo apt-get install -y python-pip
pip install --upgrade pip
sudo pip install docker-compose

echo "#############################################"
echo "# Installing ruby"
echo "#############################################"
# Following instructions in http://misheska.com/blog/2013/12/26/set-up-a-sane-ruby-cookbook-authoring-environment-for-chef/#linux
sudo apt-get update
sudo apt-get install -y build-essential git
sudo apt-get install -y libxml2-dev libxslt-dev libssl-dev
# additional lib below needed because of build failure with ruby-build 20170914
sudo apt-get install -y libreadline-dev
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
cd chruby-0.3.9/
sudo make install
cd ..
rm chruby-0.3.8.tar.gz
rm -rf chruby-0.3.8
git clone https://github.com/sstephenson/ruby-build.git
cd ruby-build/
sudo ./install.sh
cd ..
rm -rf ruby-build
echo 'source /usr/local/share/chruby/chruby.sh' >> /home/vagrant/.bashrc
echo 'source /usr/local/share/chruby/auto.sh' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc  # see https://stackoverflow.com/questions/29628635/why-is-source-home-vagrant-bashrc-not-working-in-a-vagrant-shell-provisionin
ruby-build 2.4.2 --install-dir /home/vagrant/.rubies/ruby-2.4.2
source /home/vagrant/.bashrc  # see https://stackoverflow.com/questions/29628635/why-is-source-home-vagrant-bashrc-not-working-in-a-vagrant-shell-provisionin
chruby ruby-2.4.2
echo 'chruby ruby-2.4.2' >> /home/vagrant/.bashrc
gem update --system
gem install bundler

echo "#############################################"
echo "# Installing PhantomJS"
echo "#############################################"
# Following instructions in https://gist.github.com/julionc/7476620
sudo apt-get update
sudo apt-get install -y build-essential chrpath libssl-dev libxft-dev
sudo apt-get install -y libfreetype6 libfreetype6-dev
sudo apt-get install -y libfontconfig1 libfontconfig1-dev
export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
sudo tar xvjf $PHANTOM_JS.tar.bz2
sudo mv $PHANTOM_JS /usr/local/share
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin