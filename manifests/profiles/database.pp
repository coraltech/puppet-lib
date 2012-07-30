/**
 * Database server profile.
 */
class database inherits base {

  #-----------------------------------------------------------------------------
  # Configurations

  $databases = hiera('databases', [])

  #-----------------------------------------------------------------------------
  # Required systems

  class { 'percona':
    server => true,
  }

  #---

  Class['base'] -> Class['percona']

  #-----------------------------------------------------------------------------
  # Wrapper

  if ! empty($databases) {
    database::environment { $databases: }
  }
}

#---

define database::environment ( $database = $name ) {

  #-----------------------------------------------------------------------------
  # Configurations

  $default_user     = hiera('database_default_user', 'db_user')
  $default_password = hiera('database_default_password', 'db_user')

  #---

  $databases        = hiera("database_${database}_databases", [])
  $user             = hiera("database_${database}_user", $default_user)
  $password         = hiera("database_${database}_password", $default_password)

  if ! empty($databases) {
    $database_real = $databases
  }
  else {
    $database_real = $database
  }

  #-----------------------------------------------------------------------------
  # Environment

  percona::database { $database_real:
    ensure    => present,
    user_name => $user,
    password  => $password,
  }
}
