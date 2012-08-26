export MODULE_PATH="/etc/puppet/modules/common" 
mkdir -p $MODULE_PATH
for mod in apache foreman git passenger puppet tftp xinetd; do
  mkdir -p $MODULE_PATH/$mod
  wget http://github.com/theforeman/puppet-$mod/tarball/master -O - | tar xzvf - -C $MODULE_PATH/$mod --strip-components=1
done;
echo include puppet, puppet::server, foreman | puppet apply --modulepath $MODULE_PATH
