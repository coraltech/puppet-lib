/**
 * Database server profile.
 */
class database inherits base {

  #-----------------------------------------------------------------------------
  # Configurations

  $databases     = hiera('databases', [])
  $user          = hiera('database_user', 'db_user')
  $password      = hiera('database_pw', 'db_user')

  #-----------------------------------------------------------------------------
  # Required systems

  class { 'percona':
    server => true,
  }

  #---

  Class['base'] -> Class['percona']

  #-----------------------------------------------------------------------------
  # Environment

  percona::database { $databases:
    ensure    => present,
    user_name => $user,
    password  => $password,
  }
}
