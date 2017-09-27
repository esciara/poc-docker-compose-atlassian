#!/bin/bash

####################################################################################################################
# DEVELOPMENT ENVIRONMENT SETUP FOR DEBIAN/UBUNTU LINUX
# THIS IS A SAMPLE OF BASH COMMANDS TO INSTALL THE NECESSARY ENVIRONMENT. DO NOT RUN THIS SCRIPT! RUNNING IT DOES NOT WORK
# see https://stackoverflow.com/questions/29628635/why-is-source-home-vagrant-bashrc-not-working-in-a-vagrant-shell-provisionin
####################################################################################################################
set -ex

echo "#############################################"
echo "# Docker installation NOT IMPLEMENTED"
echo "#############################################"

echo "#############################################"
echo "# docker-compose installation NOT IMPLEMENTED"
echo "#############################################"

echo "#############################################"
echo "# Installing ruby"
echo "#############################################"
# Following instructions in http://misheska.com/blog/2013/12/26/set-up-a-sane-ruby-cookbook-authoring-environment-for-chef/#linux
yum update
yum install -y git
yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel
yum install -y libyaml-devel libffi-devel openssl-devel make bzip2
yum install -y autoconf automake libtool bison
yum install -y libxml2-devel libxslt-devel# additional lib below needed because of build failure with ruby-build 20170914
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
cd chruby-0.3.9/
make install
cd ..
rm chruby-0.3.8.tar.gz
rm -rf chruby-0.3.8
git clone https://github.com/sstephenson/ruby-build.git
cd ruby-build/
./install.sh
cd ..
rm -rf ruby-build
echo 'source /usr/local/share/chruby/chruby.sh' >> $HOME/.bashrc
echo 'source /usr/local/share/chruby/auto.sh' >> $HOME/.bashrc
source $HOME/.bashrc
ruby-build 2.4.2 --install-dir $HOME/.rubies/ruby-2.4.2
source $HOME/.bashrc
chruby ruby-2.4.2
echo 'chruby ruby-2.4.2' >> $HOME/.bashrc
gem update --system
gem install bundler

echo "#############################################"
echo "# Installing PhantomJS"
echo "#############################################"
# Following instructions in https://gist.github.com/julionc/7476620
yum install fontconfig freetype freetype-devel fontconfig-devel libstdc++
export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
tar xvjf $PHANTOM_JS.tar.bz2
mv $PHANTOM_JS /usr/local/share
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin