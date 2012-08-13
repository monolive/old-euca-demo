# class to setup basic hosts, include on all nodes
class hosts {
   include concat::setup
   $hosts = "/etc/hosts"

   concat{$hosts:
      owner => root,
      group => root,
      mode  => 644
   }

   concat::fragment{"hosts_header":
      target => $hosts,
      ensure  => "/etc/hosts",
      order   => 01,
   }

}

# used by other modules to register themselves in the hosts
define hosts::register(
  $server_ip       = $::ipaddress,
  $hostname        = $::hostname,
  $role            = $::company_role,
  $order           = 10
) {

   concat::fragment{"hosts_fragment_$name":
      target  => "/etc/hosts",
      content => "$server_ip    $hostname   $role\n"
   }
}
