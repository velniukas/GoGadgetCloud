# GoGadgetCloud #
=============

Build and deploy to a private cloud and/or vagrant using Puppet and git.


## GOAL: ##
Command line deployment, build and verification of infrastructure, servers and apps
using git, puppet and jenkins to build and deploy images

### 1. Infrastructure as code ###
> 1. Externalize build definitions outside ServiceMesh into git
> 2. Use Puppet for build definitions
> 3. Create a standard script for installing Ruby, Rubygems and Puppet client
> 4. Create a standard Jenkins deploy via Puppet
> 5. Create an alternative git repository if github is not available
> 6. Set up clouddeploy and rake to deploy/build puppet modules from the command line
> 7. BDD Deployment testing and SLA monitoring using Cucumber & Nagios
> 8. Git-Annex for binary file management
> 9. Foreman for Puppet monitoring
 

### 2. DevaaS ###
#### Connect a user to a full toolchain ####
> 1. Setup git for them and connect them to their master repo
> 2. Create a jenkins instance or connect them to an existing one
> 3. On checking in a sample app - build it on the jenkins instance, save the output to maven
> 4. Give the user the ability to deploy a new vm and install the app onto it - via a jenkins manual job 
> 5. Setup their local ide on their windows desktop
		
Setup ruby/rubygems
Setup git repo on master
Setup puppet master
Setup puppet client
Setup jenkins on client

	
Setup sample puppet manifest on server in git


Setup triggers on windows desktop 


## 1. Set up a git repository ##
> ### References: ###
> http://www.gitguys.com/topics/creating-a-shared-repository-users-sharing-the-repository/
> http://stackoverflow.com/questions/6531799/unable-to-create-a-bare-git-repository
> 8 ways to share a git repo http://www.jedi.be/blog/2009/05/06/8-ways-to-share-your-git-repository/
	
  yum install git git-daemon
  mkdir -p /home/root/repo && cd /home/root/repo

> Need to create a bare repo, but the easiest way to set this up is to create an ordinary git repo first

  git init project1.git
  // then change it to a bare repo - this avoids having to worry about configuring the git working tree etc
  cd project1.git
  cd .git
  // edit the config file, and change "bare=false" to "bare=true"
  vim config
  // save a first commit
  cd ..
  echo First commit > README.md
  git add .
  git commit -m 'first commit'

> You can now clone this repo from another user / folder

  mkdir -p /home/root/some_other_folder && cd /home/root/some_other_folder
  git clone file:///home/root/repo/project1.git
  cd project1.git
  // make a sample change and push it back
  echo Another test >> README.md
  git add .
  git commit -m 'second commit'
  git push origin master

Alternative method (allows users on other computers access as well)

  git daemon --reuseaddr --base-path=/home/root --export all --verbose --enable=receive-pack

To clone the repo - just use 'git clone git://remote.computer.hostname/newrepo' or similar (can also use the ipaddress instead of hostname)

## 2. Install ruby ##

  yum install ruby rubygems

or wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz
or use the following script to install ruby and puppet (vagrant compatible)

  !/bin/sh
  fail()
  {
    echo "FATAL: $*"
    exit 1
  }

  yum -y install gcc bzip2 make kernel-devel-`uname -r`
  yum -y install gcc-c++ zlib-devel openssl-devel readline-devel sqlite3-devel
  yum -y erase wireless-tools gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
  yum -y clean all

  // install ruby
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

## 3. Set up puppet ##
> ### References: ###
> http://docs.puppetlabs.com/guides/installation.html
> http://projects.puppetlabs.com/projects/1/wiki/simplest_puppet_install_pattern
> 
> Note: Puppet Enterprise setup is different - see http://docs.puppetlabs.com/pe/2.5/install_basic.html
	
run this on both the master and the agent
setup for RHEL 5 

  sudo rpm -ivh http://yum.puppetlabs.com/el/5/products/i386/puppetlabs-release-5-5.noarch.rpm

RHEL 6

  sudo rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-5.noarch.rpm

On your puppet master

  yum install ruby rubygems puppet-server
  service puppetmaster start

Open the port for the clients

  iptables -I INPUT -m tcp -p tcp --dport 8140 -j ACCEPT
  service iptables save
  service iptables restart

Setup your puppet agent 

  yum install ruby rubygems git puppet

Allow importing of 3rd party modules

  gem install puppet-module

edit your puppet.conf

  nano /etc/puppet/puppet.conf

add the following line: 

  server = puppet_master_hostname

get a certificate - on the puppet agent

  puppet agent --test

You will get an error - go to the puppet master console 

  puppetca -l

you should see a line like 'myclient.domain.com' or similar

  puppetca -s myclient.domain.com 


## 4. Install jenkins on the client/agent machine ##
> ### References: ###
> http://jenkins-ci.org/
> http://www.wakaleo.com/component/content/article/206

  sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
  sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
  yum install jenkins

  /etc/init.d/jenkins start

You can test this by pointing your browser to the jenkins dashboard http://your.agent.machine.ipaddress:8080


On the puppet server
Setup puppet git repo

  mkdir -p /home/root/repo/puppet/manifests /home/root/repo/puppet/modules
  cd /home/root/repo/puppet
  git init

generate an ssh key for git to use

  ssh-keygen -f git.rsa

on the server, create a puppet manifests repository

  mkdir -p /etc/puppet/modules /etc/puppet/manifests

create the default site configuration for _all_ nodes

  echo "class default {\n\n\n}" > site.pp

manifests contains machine configurations
modules contains the modules that go into the configurations
organized as the following e.g. 

  mkdir -p /etc/puppet/modules/git/manifests && cd /etc/puppet/modules/git/manifests

Create a puppet module to install git on each client
the public key is taken from the ssh key generated above and using:

  cat git.rsa.pub

 nano git.pp

	user { "git":
	  ensure => "present",
	  home => "/var/git",
	}

	file {
	  "/var/git": ensure => directory, owner => git, 
	  require => User["git"];
	  "/var/git/puppet": ensure => directory, owner => git, 
	  require => [User["git"], File["/var/git"]],
	}

	ssh_authorized_key { "git":
	  ensure => present,
	  key => "INSERT PUBLIC KEY HERE",
	  name => "git@atalanta-systems.com",
	  target => "/var/git/.ssh/authorized_keys",
	  type => rsa,
	  require => File["/var/git"],
	}

	yumrepo { "example":
	  baseurl => "http://packages.example.com",
	  descr => "Example Package Repository",
	  enabled => 1,
	  gpgcheck => 0,
	  name => "example",
	}

	package { "git":
	  ensure => installed,
	  require => Yumrepo["example"],
	}

	exec { "Create puppet Git repo":
	  cwd => "/var/git/puppet",
	  user => "git",
	  command => "/usr/bin/git init --bare",
	  creates => "/var/git/puppet/HEAD",
	  require => [File["/var/git/puppet"], Package["git"], User["git"]],
	}


## 5. bdd testing / monitoring on server ##
> ### References: ###
> http://nokogiri.org/tutorials/installing_nokogiri.html 
> EPEL http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F

  yum install -y rubygem-nokogiri

or 

  yum install -y gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel gcc-c++
  sudo gem install nokogiri -- --with-xml2-lib=/usr/local/lib 
                         --with-xml2-include=/usr/local/include/libxml2 
                         --with-xslt-lib=/usr/local/lib 
                         --with-xslt-include=/usr/local/include
  gem install cucumber-nagios
  gem install bundler
  cucumber-nagios-gen project bddtest
  cd bddtest
  rake deps
  bundle install


## 6. Install git-annex ##
> ### References: ###
> http://git-annex.branchable.com/install/ScientificLinux5/
> http://stackoverflow.com/questions/540535/managing-large-binary-files-with-git

	$ git annex add mybigfile
	$ git commit -m'add mybigfile'
	$ git push myremote 
	$ git annex copy --to myremote mybigfile ## this command copies the actual content to myremote 
	$ git annex drop mybigfile ## remove content from local repo
	...
	$ git annex get mybigfile ## retrieve the content
	// or to specify the remote from which to get:
	$ git annex copy --from myremote mybigfile

el5     http://sherkin.justhub.org/el5/RPMS/x86_64/justhub-release-2.0-4.0.el5.x86_64.rpm
el6     

  wget http://sherkin.justhub.org/el6/RPMS/x86_64/justhub-release-2.0-4.0.el6.x86_64.rpm

  rpm -ivh justhub-release-2.0-4.0.el6.x86_64.rpm
  PATH=/usr/hs/bin:$PATH
  yum install haskell-min

## 7. Maven ##

  wget http://apache.01link.hk/maven/binaries/apache-maven-3.0.4-bin.tar.gz

## 8. Jenkins and plugins ##

  wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war

plugins - download and copy to $JENKINS_HOME/plugins folder 
http://updates.jenkins-ci.org/download/plugins/

  wget --no-check-certificate http://updates.jenkins-ci.org/latest/svn-release-mgr.hpi
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/subversion.hpi
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/sonar.hpi
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/svnmerge.hpi
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/maven-invoker-plugin.hpi
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/maven-dependency-update-trigger.hpi
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/maven-deployment-linker.hpi
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/maven-plugin.hpi 
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/github.hpi   
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/github-api.hpi 
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/git.hpi  
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/ant.hpi
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/gerrit.hpi
  wget --no-check-certificate http://updates.jenkins-ci.org/latest/gerrit-trigger.hpi

