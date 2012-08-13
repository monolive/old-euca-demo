class zenphoto::prereq {
  $php_packages = ['php', 'php-mysql', 'php-gd', 'php-xml','nfs-utils']
  package { $php_packages:
    ensure  => present,
  }
}
class zenphoto::install {
  include local-repo
  package { "zenphoto":
    require => Class["local-repo"],
    ensure  => present,
  }
}

 
class zenphoto::config {
    include http::service
    File{
        require => Class["zenphoto::install"],
        notify  => Class["http::service"],
        owner   => "apache",
        group   => "apache",
        mode    => 644
    }
    file{"/var/www/html/zenphoto/zp-data/zenphoto.cfg":
        source => "puppet:///modules/zenphoto/zenphoto.cfg";
    }
    file{"/var/www/html/zenphoto/zp-data/.htaccess":
        source => "puppet:///modules/zenphoto/htaccess";
    }
    mount{"albums":
        require => Class["zenphoto::install"],
        device  => "mysql:/images",        
        ensure  => mounted,
        fstype  => "nfs4",
        name    => "/var/www/html/zenphoto/albums",
        options => "defaults",
    }
}
 
class zenphoto {
  include zenphoto::prereq, zenphoto::install, zenphoto::config
  #notify => Class["http::service"]
}

