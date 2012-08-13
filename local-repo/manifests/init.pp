class local-repo {
   file { "local-repo":
	path => "/etc/yum.repos.d/local.repo",
	ensure => file,
	owner => root,
	group => root,
	mode => 644,
	source => "puppet:///modules/local-repo/local.repo",
   }
}

