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
define fourstore::kb (
  String                  $kb_name  = $name,
  Optional[Integer]       $segments = undef,
  Enum['present', 'absent'] $ensure = present,
){

  require fourstore

  if $segments {
    $_segments = "--segments=${segments}"
  } else {
    $_segments = ""
  }

  case $ensure {
    'present': {
      exec { "create_kb_${kb_name}":
        command => "/usr/local/bin/4s-admin create-store ${_segments} ${kb_name}",
        cwd     => '/usr/local/bin/',
        creates => "$fourstore::data_dir/${kb_name}/metadata.nt",
        timeout => 30,
      }
    }
    'absent': {
      exec { "delete-kb_${kb_name}":
        command => "/usr/local/bin/4s-admin/4s-admin delete-stores ${kb_name}",
        cwd     => '/usr/local/bin/',
        onflyif => "test -f $fourstore::data_dir/${kb_name}/metadata.nt",
        timeout => 30,
      }
    }
  }
}
