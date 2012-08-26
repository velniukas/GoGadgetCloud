#!/bin/sh

fail()
{
  echo "FATAL: $*"
  exit 1
}

yum -y install gcc bzip2 make kernel-devel-`uname -r`
yum -y install gcc-c++ zlib-devel openssl-devel readline-devel sqlite3-devel
yum -y erase wireless-tools gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all

# install ruby
cd /tmp
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz || fail "Could not download Ruby source"
tar xzvf ruby-1.9.2-p180.tar.gz 
cd ruby-1.9.2-p180
./configure
make && make install
cd /tmp
rm -rf /tmp/ruby-1.9.2-p180
rm /tmp/ruby-1.9.2-p180.tar.gz
ln -s /usr/local/bin/ruby /usr/bin/ruby
ln -s /usr/local/bin/gem /usr/bin/gem 

/usr/local/bin/gem install puppet --no-ri --no-rdoc || fail "Could not install puppet"
