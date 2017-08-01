# \curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
if [ -f /etc/profile.d/rvm.sh ]; then
  source /etc/profile.d/rvm.sh
else
  source ~/.profile
fi
rvm reload
rvm --version
rvm install 1.8.7
rvm use 1.8.7
rvm --default use 1.8.7
rvm default
ruby --version
gem update --system
gem install bundler --no-ri --no-rdoc
