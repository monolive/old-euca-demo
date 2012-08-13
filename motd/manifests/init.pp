# class to setup basic motd, include on all nodes
class motd {
   include concat::setup
   $motd = "/etc/motd"

   concat{$motd:
      owner => root,
      group => root,
      mode  => 644
   }

   concat::fragment{"motd_header":
      target => $motd,
      content => "\nYou are currently log to:\n\n",
      order   => 01,
   }

   # local users on the machine can append to motd by just creating
   # /etc/motd.local
   concat::fragment{"motd_local":
      target => $motd,
      ensure  => "/etc/motd.local",
      order   => 15
   }
}

# used by other modules to register themselves in the motd
define motd::register($content="", $order=10) {
   if $content == "" {
      $body = $name
   } else {
      $body = $content
   }

   concat::fragment{"motd_fragment_$name":
      target  => "/etc/motd",
      content => "    -- $body\n"
   }
}

