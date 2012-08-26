class bootstrap {

	file { "/var/tmp/boostrap.sh": 
		owner => 'root',
		group => 'root',
		mode => 550,
		source => "puppet:///modules/bootstrap/bootstrap.sh",
	}
}
