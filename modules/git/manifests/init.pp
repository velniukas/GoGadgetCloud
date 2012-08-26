
class git {
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
	  key => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqK3RkldOO/l3dbRBoQaQNqRo/1Y2z1QcOUiG6vzvFYi4QC2TgpI7s2ZglvY3nRIdMfKtVYefBDiA4+/3dWtHmgXDGVitC+GvykWmCJjInhcLvSi/b5m32JwIaAGWmhbc7M9Y760mx2Tf4wgefKF7Gpr0xlNG6u4lOSHmkqKOs9hNosO00PSOuSf09L7QENFPurZAt7A+OrQ5J9FLEfrJuSduHtqd/f1jZjGqqeix3mtx3umw/YvAvXaXO00q+/hfG5j8ujjdO1O2Le5X9pezgo2IDZlIGThDTjVtt5JDfKxH7/JdlfTtSqlo05NJ7mytRDKPyYcwpu87s4/Eg0XyCw== root@ip-10-128-69-153",
	  name => "git@54.251.48.3",
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

}
