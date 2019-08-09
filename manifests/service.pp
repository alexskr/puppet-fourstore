#
# Class: 4store::master
#
# Description: This class manages 4store master node.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class fourstore::service (
  String  $fsnodes         = 'localhost',
  Integer $port            = 8080,
  Integer $log_rotate_days = 7,
){

  systemd::unit_file { '4s-httpd.service':
    ensure  => present,
    content => epp ('fourstore/4s-httpd.service.epp', {
      'port' => $port,
    }),
  }
  -> service { '4s-httpd':
    enable  => true,
  }


  systemd::unit_file { '4s-backend.service':
    ensure  => present,
    content => epp ('fourstore/4s-backend.service.epp', {
    }),
  }
  -> service { '4s-backend':
    enable  => true,
  }

  systemd::unit_file { '4s-boss.service':
    ensure  => present,
    content => epp ('fourstore/4s-boss.service.epp', {
    }),
  }
  -> service { '4s-boss':
    enable  => true,
  }
  logrotate::rule { '4s-httpd':
    path         => '/var/log/4store/query-*log',
    rotate       => $log_rotate_days,
    rotate_every => 'day',
    copytruncate => true,
    dateext      => true,
    compress     => true,
    missingok    => true,
    su           => true,
    su_user      => '4store',
    su_group     => '4store',
  }

  file { '/etc/4store.conf':
    mode    => '0644',
    content => epp ('fourstore/4store.conf.epp', {
      fsnodes => $fsnodes
    }),
  }
}
