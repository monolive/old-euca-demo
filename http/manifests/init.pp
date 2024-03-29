class http::install {
#    $php_packages = ['httpd', 'ganglia-gmond', 'ganglia-gmond-python']
    $php_packages = ['httpd']
    package { $php_packages:
        ensure  => latest,
    } 
}
 
class http::config {
    File{
        require => Class["http::install"],
        notify  => Class["http::service"],
        owner   => "root",
        group   => "root",
        mode    => 644
    }
 
    file{"/etc/httpd/conf/httpd.conf":
        source => "puppet:///modules/http/httpd.conf";
    }
}

class http::service {
    service{"httpd":
        ensure  => running,
        enable  => true,
        require => Class["http::config"],
    }
}
 
class http {
    include http::install, http::config, http::service
}
