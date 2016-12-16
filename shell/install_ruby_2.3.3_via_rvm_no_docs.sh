#!/usr/bin/env bash

\curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
\curl -sSL https://get.rvm.io | bash -s stable
if [ -f /etc/profile.d/rvm.sh ]; then
  source /etc/profile.d/rvm.sh
else
  source ~/.profile
fi
rvm reload
rvm --version
rvm install 2.3.3
rvm use 2.3.3
rvm --default use 2.3.3
rvm default
ruby --version
gem update --system
gem install bundler --no-ri --no-rdoc
