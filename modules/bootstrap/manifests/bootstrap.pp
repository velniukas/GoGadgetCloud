class bootstrap {

	file { "/root/boostrap.sh": 
		owner => 'root',
		group => 'root',
		mode => 550,
		source => "puppet:///modules/bootstrap/bootstrap.sh"
	}
}
