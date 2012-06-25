
class apache_server inherits base {

  $apache_use_dev = hiera('apache_use_dev')
  $apache_modules = hiera_array('apache_modules')

  #-----------------------------------------------------------------------------

  class { 'apache': }

  if $apache_use_dev {
    include apache::dev
  }

  a2mod { $apache_modules:
    ensure => 'present',
  }
}
