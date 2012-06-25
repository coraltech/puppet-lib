
class php_application inherits base {

  $php_use_apc     = hiera('php_use_apc')
  $php_use_xdebug  = hiera('php_use_xdebug')
  $php_web_enabled = hiera('php_web_enabled')

  $php_packages    = hiera_array('php_packages')
  $pear_packages   = hiera_array('pear_packages')
  $pecl_packages   = hiera_array('pecl_packages')

  #-----------------------------------------------------------------------------
  # PHP Language

  class { 'php':
    use_apc    => $php_use_apc,
    use_xdebug => $php_use_xdebug,
  }

  if $php_packages {
    php::module { $php_packages:
      ensure => 'present',
    }
  }

  if $pear_packages {
    php::module { $pear_packages:
      ensure   => 'present',
      provider => 'pear',
    }
  }

  if $pecl_packages {
    php::module { $pecl_packages:
      ensure   => 'present',
      provider => 'pecl',
    }
  }

  #-----------------------------------------------------------------------------
  # Apache support

  if $php_web_enabled {
    include php::apache2

    a2mod { 'php5':
      ensure  => 'present',
      require => Class['php::apache2'],
    }
  }
}
