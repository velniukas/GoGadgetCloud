class repo::gem-server {
	
	include apache

	file { "/etc/apache2/sites-available/gemrepo":
		source => "puppet:///modules/repo/gemrepo.conf",
		require => Package[ "apache2-mpm-worker" ],
		notify => Service["apache2"],
	}

	file { "/etc/apache2/sites-enabled/gemrepo":
		ensure => symlink,
		target => "/etc/apach2/sites-available/gemrepo",
		require => File[ "/etc/apache2/sites-available/gemrepo" ],
		notify => Service[ "apache2" ],
	}

	file { "/var/gemrepo":
		ensure => "directory",
	}
}