class jenkins {

	package { "jenkins":
		ensure => installed,
	}
	
	file { "/etc/jenkins/jenkins.war":
		source => "puppet:///modules/jenkins/files/jenkins.war",
	}

	service { "jenkins":
		ensure => running,
		enable => true,
		require => [ Package["jenkins"], File["/etc/memcached.conf"] ],
	}

}
