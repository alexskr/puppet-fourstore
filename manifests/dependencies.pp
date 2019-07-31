# Class handles installation of depenencies required for compiling 4store
class fourstore::dependencies {

  ensure_packages([
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
    'perl-libwww-perl'
  ])
}

