class epel {
   file { "epel":
	path => "/etc/yum.repos.d/epel.repo",
	ensure => file,
	owner => root,
	group => root,
	mode => 644,
	source => "puppet:///modules/epel/epel.repo",
   }
   file { "epel-pki":
        path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6",
        ensure => file,
        owner => root,
        group => root,
        mode => 644,
        source => "puppet:///modules/epel/RPM-GPG-KEY-EPEL-6",
   }
}

