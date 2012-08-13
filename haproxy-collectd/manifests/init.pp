class haproxy-collectd::install {
    include local-repo
    $collectd_packages = ['collectd']
    package { $collectd_packages:
        ensure  => latest,
    } 
}
 
class haproxy-collectd::config {
    File{
        require => Class["haproxy-collectd::install"],
        notify  => Class["haproxy-collectd::service"],
#        notify  => Class["http::service"],
        owner   => "root",
        group   => "root",
        mode    => 644
    }
 
    file{"/opt/collectd/lib/collectd/haproxy.py":
        source => "puppet:///modules/haproxy-collectd/haproxy.py";
    }
    file{"/opt/collectd/etc/collectd.conf":
        source => "puppet:///modules/haproxy-collectd/collectd.conf";
    }
}

class haproxy-collectd::service {
    service{"collectd":
        ensure  => running,
        enable  => true,
        require => Class["haproxy-collectd::config"],
    }
}
 
class haproxy-collectd {
    include haproxy-collectd::install, haproxy-collectd::config, haproxy-collectd::service
}
