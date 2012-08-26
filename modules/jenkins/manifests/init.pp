class jenkins {

	package { "jenkins":
		ensure => installed,
	}

	file { "/var/lib/jenkins":
		ensure => "directory",
		mode => 0664,
	}

	file { "/var/lib/jenkins/plugins":
		ensure => "directory",
		mode => 0664,
	}
	
	file { "/var/lib/jenkins/jenkins.war":
		source => "puppet:///modules/jenkins/jenkins.war",
		ensure => "directory",
		owner => "root",
		group => "root",
		mode => 0555
	}

	file { "/var/lib/jenkins/plugins/ant.hpi":
		source => "puppet:///modules/jenkins/plugins/ant.hpi",
		ensure => "directory",
		owner => "root",
		group => "root"
	}

        file { "/var/lib/jenkins/plugins/git.hpi":
                source => "puppet:///modules/jenkins/plugins/git.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/github.hpi":
                source => "puppet:///modules/jenkins/plugins/github.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/maven-plugin.hpi":
                source => "puppet:///modules/jenkins/plugins/maven-plugin.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/subversion.hpi":
                source => "puppet:///modules/jenkins/plugins/subversion.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/maven-dependency-update-trigger.hpi":
                source => "puppet:///modules/jenkins/plugins/maven-dependency-update-trigger.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/maven-invoker-plugin.hpi":
                source => "puppet:///modules/jenkins/plugins/maven-invoker-plugin.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }


        file { "/var/lib/jenkins/plugins/svn-release-mgr.hpi":
                source => "puppet:///modules/jenkins/plugins/svn-release-mgr.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/svnmerge.hpi":
                source => "puppet:///modules/jenkins/plugins/svnmerge.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/github-api.hpi":
                source => "puppet:///modules/jenkins/plugins/github-api.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/sonar.hpi":
                source => "puppet:///modules/jenkins/plugins/sonar.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/gerrit.hpi":
                source => "puppet:///modules/jenkins/plugins/gerrit.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }

        file { "/var/lib/jenkins/plugins/gerrit-trigger.hpi":
                source => "puppet:///modules/jenkins/plugins/gerrit-trigger.hpi",
                ensure => "directory",
                owner => "root",
                group => "root"
        }


	service { "jenkins":
		ensure => running,
		enable => true,
		require => [ Package["jenkins"], File["/var/lib/jenkins/jenkins.war"] ],
	}

}
