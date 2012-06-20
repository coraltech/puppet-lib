
class apache_server inherits base {

  include params

  #-----------------------------------------------------------------------------

  class { 'apache': }

  if $params::apache_use_dev {
    include apache::dev
  }

  a2mod { $params::apache_modules:
    ensure => 'present',
  }
}
