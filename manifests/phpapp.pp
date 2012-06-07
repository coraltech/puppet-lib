
import 'web.pp'

node phpapp inherits web {

  #-----------------------------------------------------------------------------

  include params

  #-----------------------------------------------------------------------------
  # Dependencies

  package { 'libpcre3-dev':
    ensure => 'present',
  }

  #-----------------------------------------------------------------------------
  # PHP Language

  include php

  php::module { [
      'curl',
      'gd',
      'mysql',
      'tidy',
      'xmlrpc',
    ]:
    package_prefix => 'php5-',
    ensure         => 'present',
  }

  php::module { 'apc':
    ensure         => 'present',
    provider       => 'pecl',
    content        => 'php/apc.ini.erb',
    require        => Package['libpcre3-dev'],
  }

  php::module { 'xdebug':
    ensure         => 'present',
    provider       => 'pecl',
    content        => 'php/xdebug.ini.erb',
  }

  php::module { 'uploadprogress':
    ensure         => 'present',
    provider       => 'pecl',
  }

  #-----------------------------------------------------------------------------
  # Apache support

  include php::apache2

  a2mod { 'php5':
    ensure  => 'present',
    require => Class['php::apache2'],
  }
}
