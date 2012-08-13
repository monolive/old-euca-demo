class s3cmd::repo {
   file { "s3cmd-repo":
        path => "/etc/yum.repos.d/s3cmd.repo",
        ensure => file,
        owner => root,
        group => root,
        mode => 644,
        source => "puppet:///modules/s3cmd/s3tools.repo",
   }
}

class s3cmd::package {
  $packages = ['s3cmd', 'patch' ]
  package { $packages:
     require => Class["s3cmd::repo"],
     ensure  => present,
  }
}

class s3cmd::patch {
  File {
    require => Class["s3cmd::package"],
    owner   => "root",
    group   => "root",
    mode    => 644,
  }
  file{"/tmp/S3.patch":
    source  => "puppet:///modules/s3cmd/S3.patch";
  }
  file{"/tmp/s3cmd.patch":
    source  => "puppet:///modules/s3cmd/s3cmd.patch";
  }
  file{"/tmp/s3patch.sh":
    source  => "puppet:///modules/s3cmd/s3patch.sh",
    mode    => 755;
  }
  file{"/root/.s3cfg":
    source  => "puppet:///modules/s3cmd/s3cfg",
    mode    => 600;
  }
}

class s3cmd::applypatch {
  include zenphoto::data
  exec { "/bin/sh /tmp/s3patch.sh":
    user    => "root",
    onlyif  => "/usr/bin/file /tmp/patch_done",
    require => Class["s3cmd::patch"],
    before  => Class["zenphoto::data"];
  }
}

class s3cmd {
  include s3cmd::repo, s3cmd::package, s3cmd::patch, s3cmd::applypatch
}
