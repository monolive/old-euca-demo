class truth::enforcer {
   include ntp, prereq, collectd
   $groupname = "$company_platform:$company_role"
   case $groupname {
      "USA:Web" : {
         include epel
      }
   }
   case $company_role {
      "load-balancer" : {
         include epel 
#         motd::register {"haproxy":}
         class { 'haproxy':
            enable                   => true,
            haproxy_global_options   => { 
               'log'      => "${::ipaddress} local0",
               'chroot'   => '/var/lib/haproxy',
               'pidfile'  => '/var/run/haproxy.pid',
               'maxconn'  => '4000',
               'user'     => 'haproxy',
               'group'    => 'haproxy',
               'daemon'   => '',
               'stats'    => 'socket /var/lib/haproxy/stats'
            },
            haproxy_defaults_options => { 
               'log'     => 'global',
               'stats'   => 'enable',
               'option'  => 'redispatch',
               'retries' => '3',
               'timeout' => ['http-request 10s', 'queue 1m', 'connect 10s', 'client 1m', 'server 1m', 'check 10s'],
               'maxconn' => '8000'
            },
         }
         haproxy::config { 'puppet00':
            order                  => '20',
            virtual_ip             => $::ipaddress,
            virtual_ip_port        => '18140',
            haproxy_config_options => { 'option' => ['tcplog'], 'balance' => 'roundrobin' },
         }
         haproxy::config { 'stats':
            order                  => '30',
            virtual_ip             => '',
            virtual_ip_port        => '9090',
            haproxy_config_options => { 'mode' => 'http', 'stats' => ['uri /', 'auth puppet:puppet'] },
         }
      }
   }       
   case $company_role {
      "web-server" : {
         include http, s3cmd, zenphoto
#         motd::register {"http":}
         @@haproxy::balancermember { $fqdn:
            order                  => '21',
            listening_service      => 'puppet00',
            server_name            => $::hostname,
            balancer_ip            => $::ipaddress,
            balancer_port          => '80',
            balancermember_options => 'maxconn 50 check',
         }
         include refresh-lb
      }
   }
   case $company_role {
      "test" : {
         include http, s3cmd, zenphoto
      }
   }
}
