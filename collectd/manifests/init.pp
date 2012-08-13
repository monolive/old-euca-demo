class collectd::install {
    include local-repo
    $collectd_packages = ['collectd']
    package { $collectd_packages:
        ensure  => latest,
        require => Class["local-repo"],
    } 
}
 
class collectd::config {
    File{
        require => Class["collectd::install"],
        notify  => Class["collectd::service"],
        owner   => "root",
        group   => "root",
        mode    => 644
    }
    case $company_role { 
      load-balancer : {
        file{"/opt/collectd/etc/collectd.conf":
          source => "puppet:///modules/collectd/haproxy-collectd.conf";
        }
        file{"/opt/collectd/lib/collectd/haproxy.py":
          source => "puppet:///modules/collectd/haproxy.py";
        }
      }
      web-server : {
        file{"/opt/collectd/etc/collectd.conf":
          source => "puppet:///modules/collectd/http-collectd.conf";
        }
      }
    }
}

class collectd::service {
    exec{"collectd":
        command  => "/opt/collectd/sbin/collectdmon -c /opt/collectd/sbin/collectd",
        path     => "/opt/collectd/sbin:/opt/collectd/bin",
        unless   => "/usr/bin/test -f /opt/collectd/var/run/collectdmon.pid",
        require  => Class["collectd::config"],
    }
}
 
class collectd {
    include collectd::install, collectd::config, collectd::service
}
