class refresh-lb::conf {
    File{
        owner   => "root",
        group   => "root",
        mode    => 755
    }
 
    file{"/usr/local/bin/refresh-lb.sh":
            source => "puppet:///modules/refresh-lb/refresh-lb.sh";
 
    }
}

class refresh-lb::run {
    exec { "refresh_cache":
       command => "refresh-lb.sh",
       path    => "/usr/local/bin/:/bin/:/usr/bin/",
       unless  => "test -f /tmp/register",
    }
}

class refresh-lb {
    include refresh-lb::conf, refresh-lb::run
}
