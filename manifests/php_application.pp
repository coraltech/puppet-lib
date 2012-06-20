
class php_application inherits base {

  include params

  #-----------------------------------------------------------------------------
  # PHP Language

  class { 'php':
    use_apc    => $params::php_use_apc,
    use_xdebug => $params::php_use_xdebug,
  }

  if $params::php_packages {
    php::module { $params::php_packages:
      ensure         => 'present',
    }
  }

  if $params::pear_packages {
    php::module { $params::pear_packages:
      ensure         => 'present',
      provider       => 'pear',
    }
  }

  if $params::pecl_packages {
    php::module { $params::pecl_packages:
      ensure         => 'present',
      provider       => 'pecl',
    }
  }

  #-----------------------------------------------------------------------------
  # Apache support

  if $params::php_web_enabled {
    include php::apache2

    a2mod { 'php5':
      ensure  => 'present',
      require => Class['php::apache2'],
    }
  }
}
