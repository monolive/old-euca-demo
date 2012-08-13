class local-repo {
   yumrepo { "local":
        descr    => "Local Yum Repository",
	baseurl  => "http://puppet/pub/local",
	enabled  => 1,
	gpgcheck => 0,
	name     => "local",
   }
}

