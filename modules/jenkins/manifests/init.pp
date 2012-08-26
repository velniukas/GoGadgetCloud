class jenkins {

	package { "jenkins":
		ensure => installed,
	}

	file { "/var/lib/jenkins":
		ensure => "directory",
		owner => "jenkins",
		group => "root",
		mode => 0755,
	}

	
	file { "/var/lib/jenkins/jenkins.war":
		source => "puppet:///modules/jenkins/jenkins.war",
		ensure => "directory",
		owner => "root",
		group => "root",
		mode => 0555
	}

	file { "/var/lib/jenkins/plugins":
		source => "puppet:///modules/jenkins/plugins",
		ensure => "directory",
		owner => "jenkins",
		group => "root",
		mode => 0755,
		recurse => "true",
	}

	service { "jenkins":
		ensure => running,
		enable => true,
		require => [ Package["jenkins"], File["/var/lib/jenkins/jenkins.war"], File["/var/lib/jenkins/plugins/"] ],
	}

}
