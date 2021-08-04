# Class handles installation of depenencies required for compiling 4store
class fourstore::dependencies {
  include git

  case $facts['os']['family'] {
    'Debian': {
      $build_packages = [
        'make',
        'autoconf',
        'libtool',
        'pkg-config',
        'libncurses5-dev',
        'libreadline6-dev',
        'zlib1g-dev',
        'uuid-dev',
        'libxml2-dev',
        'libglib2.0-dev',
        'libraptor2-dev',
        'librasqal3-dev',
      ]
    }
    'RedHat': {
      #RedHat 7 has v0.9.30 of rasqal which might not be fresh enough.
      require librdf::rasqal

      $build_packages = [
        #build essentials for EL
        'autoconf',
        'automake',
        'binutils',
        'bison',
        'flex',
        'gcc',
        'gcc-c++',
        'make',
        'gettext',
        'libtool',
        'pkgconfig',
        'patch',
        #libs for building 4store
        'libxml2-devel',
        'openssl-devel',
        'glib2-devel',
        'pcre-devel',
        'libcurl-devel',
        'libuuid-devel',
        'readline-devel',
        'zlib-devel',
        'perl-libwww-perl',
      ]
    }
    default: {
      fail("Unsupported platform: ${facts['os']['family']}/${facts['os']['name']}")
    }
  }
  ensure_packages( $build_packages )
}
