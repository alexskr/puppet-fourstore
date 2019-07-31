#
# Class: 4store::master
#
# Description: This class manages 4store backend nodes
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class fourstore::boss (
  String  $fsnodes         = 'localhost',
  Integer $port            = 8080,
  Integer $log_rotate_days = 7,
){

  systemd::unit_file { '4s-boss.service':
    ensure  => present,
    content => epp ('fourstore/4s-boss.service.epp', {
    }),
  }
  -> service { '4s-boss':
    enable  => true,
  }

  file { '/etc/4store.conf':
    mode    => '0644',
    content => epp ('fourstore/4store.conf.epp', {}),
  }
}
