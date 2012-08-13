class zenphoto::prereq {
  $php_packages = ['php', 'php-mysql', 'php-gd', 'php-xml']
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
    file{"/tmp/get_photo.sh":
        source => "puppet:///modules/zenphoto/get_photo.sh",
        mode   => 755;
    }
}

class zenphoto::data {
    include s3cmd
    exec {'/bin/sh /tmp/get_photo.sh':
      user     => "root",
      require  => Class["zenphoto::config"],
#      require  => Class["s3cmd::applypatch"],
    }
}
 
class zenphoto {
  include zenphoto::prereq, zenphoto::install, zenphoto::config, zenphoto::data
  #notify => Class["http::service"]
}

