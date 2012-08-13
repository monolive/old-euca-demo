class webcollectd::install {
    include local-repo
    $collectd_packages = ['collectd']
    package { $collectd_packages:
        ensure  => latest,
    } 
}
 
class webcollectd::config {
    File{
        require => Class["webcollectd::install"],
        notify  => Class["webcollectd::service"],
#        notify  => Class["http::service"],
        owner   => "root",
        group   => "root",
        mode    => 644
    }
 
    file{"/opt/collectd/etc/collectd.conf":
        source => "puppet:///modules/webcollectd/collectd.conf";
    }
}

class webcollectd::service {
    exec{"collectd":
        command  => "/opt/collectd/sbin/collectdmon -c /opt/collectd/sbin/collectd",
        path     => "/opt/collectd/sbin:/opt/collectd/bin",
        unless   => "/opt/collectd/var/run/colledmon.pid",
        require  => Class["webcollectd::config"],
    }
}
 
class webcollectd {
    include webcollectd::install, webcollectd::config, webcollectd::service
}
