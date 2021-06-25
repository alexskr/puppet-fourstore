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
class fourstore::install(
  String $fsrepo                 = 'https://github.com/ncbo/4store',
  String $fsrevision             = 'master',
  Stdlib::Absolutepath $data_dir = '/srv/4store'
) {

  include git
  require fourstore::dependencies
  require librdf::rasqal

  user { '4store':
    ensure           => 'present',
    system           => true,
    comment          => '4Store Server',
    home             => '/var/lib/4store',
    password         => '!!',
    password_max_age => '-1',
    password_min_age => '-1',
    shell            => '/bin/bash',
    #uid             => '70009',
    #gid             => '70009',
  }

  #ulimits
  file { '/etc/security/limits.d/4store.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/fourstore/limits.d-4store.conf',
  }

  #data directory
  file { $data_dir :
    ensure => directory,
    owner  => '4store',
    group  => '4store',
    mode   => '0775',
    before => File['/var/lib/4store']
  }

  file { '/var/lib/4store':
    ensure => symlink,
    target => '/srv/4store',
  }

  file { '/var/log/4store':
    ensure => directory,
    owner  => '4store',
    group  => '4store',
    mode   => '0755',
  }

  file { '/var/run/4store':
    ensure => directory,
    owner  => '4store',
    group  => '4store',
    mode   => '0755',
  }

  file {  '/usr/local/bin/4s-fixperms':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => "chown -R 4store:4store ${data_dir}",
  }

  vcsrepo { '/usr/local/src/4store':
    ensure   => present,
    provider => git,
    source   => $fsrepo,
    revision => $fsrevision,
  }

  file {  '/usr/local/bin/make4store':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => epp('fourstore/make4store.epp', { 'data_dir' => $data_dir }),
    require => Vcsrepo['/usr/local/src/4store'],
  }

  exec { 'make_4store':
    command => '/usr/local/bin/make4store deps',
    cwd     => '/usr/local/bin/',
    creates => '/usr/local/bin/4s-backend',
    timeout => 1200,
    require => File['/usr/local/bin/make4store'],
  }
}
