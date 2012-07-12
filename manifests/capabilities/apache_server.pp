
class apache_server {

  $apache_use_dev = hiera('apache_use_dev', false)
  $apache_modules = hiera_array('apache_modules', [])

  #-----------------------------------------------------------------------------
  # Web server

  class { 'apache': }

  if $apache_use_dev and $apache_use_dev != 'false' {
    include apache::dev
  }

  a2mod { $apache_modules:
    ensure => 'present',
  }
}
