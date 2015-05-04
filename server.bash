apt-get update
apt-get install git libcairo2-dev libpango1.0-dev libgdal-dev ruby ruby-dev

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile

echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

rbenv install 2.2.2

sudo gem install simpler-tiles
