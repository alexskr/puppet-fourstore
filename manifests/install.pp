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
  $raptor2_ver = '2.0.15',
  $rasqal_ver  = '0.9.33',
  $fsrepo      = 'https://github.com/ncbo/4store',
  $fsrevision  = 'master'
) {

  require librdf::rasqal
  include git

  user { '4store':
  ensure           => 'present',
  system           => true,
  comment          => '4Store Server',
  home             => '/var/lib/4store',
  password         => '!!',
  password_max_age => '-1',
  password_min_age => '-1',
  shell            => '/bin/bash',
  #uid              => '70009',
  #gid              => '70009',
}
# group { '4store':
#   ensure => 'present',
#   gid    => '70009',
# }


  if ! defined( Class['fourstore::dependencies'] ) {
    require fourstore::dependencies
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
  file { [ '/srv/4store', '/srv/4store/data'] :
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

  file {  '/usr/local/bin/fixperms':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/fourstore/fixperms',
  }

  vcsrepo { '/usr/local/src/4store':
    ensure   => present,
    provider => git,
    source   => $fsrepo,
    revision => $fsrevision,
  }

  exec { 'make_4store':
    command => '/usr/local/bin/make4store deps',
    cwd     => '/usr/local/bin/',
    creates => '/usr/local/bin/4s-backend',
    timeout => 1200,
    require =>File['/usr/local/bin/make4store'],
  }

  file {  '/usr/local/bin/make4store':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/fourstore/make4store',
    require => Vcsrepo['/usr/local/src/4store'],
  }

}
