class epel {
   yumrepo { "epel":
	name       => "epel",
 	#baseurl    => "http://download.fedoraproject.org/pub/epel/6/\$basearch",
	mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=\$basearch",
	descr      => "Extra Packages for Enterprise Linux 6 - \$basearch",
	gpgkey     => "https://fedoraproject.org/static/0608B895.txt",
	gpgcheck   => 1,
	enabled    => 1,
   }
}

