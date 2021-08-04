#
# Class: 4store::server
#
# Description: This class manages 4store server.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class fourstore(
  String $fsrepo                 = 'https://github.com/ncbo/4store',
  String $fsrevision             = 'master',
  Stdlib::Absolutepath $data_dir = '/srv/4store',
  Stdlib::Port $port             = 8080,
  Stdlib::Host $fsnodes          = '127.0.0.1',
  Integer $log_rotate_days       = 7,
) {
  user { '4store':
    ensure           => 'present',
    system           => true,
    comment          => '4Store Server',
    home             => '/var/lib/4store',
    password         => '!!',
    password_max_age => '-1',
    password_min_age => '-1',
    shell            => '/bin/bash',
  }

  #data directory
  file { $data_dir :
    ensure => directory,
    owner  => '4store',
    group  => '4store',
    mode   => '0775',
    before => File['/var/lib/4store'],
  }

  contain fourstore::install
  contain fourstore::service

  Class[fourstore::install] -> Class[fourstore::service]
}
