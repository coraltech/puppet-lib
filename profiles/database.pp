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

  #-----------------------------------------------------------------------------
  # Wrapper

  if ! empty($databases) {
    database::db { $databases: }
  }
}

#---

define database::db ( $database = $name ) {

  #-----------------------------------------------------------------------------
  # Configurations

  $databases = hiera("database_${database}_databases", [])

  if ! empty($databases) {
    $database_real = $databases
  }
  else {
    $database_real = $database
  }

  #-----------------------------------------------------------------------------
  # Environment

  percona::database { $database_real:
    ensure        => hiera("database_${database}_ensure", 'present'),
    sql_dump_file => hiera("database_${database}_sql_dump_file", $percona::params::database_sql_dump_file),
    user_name     => hiera("database_${database}_user", $percona::params::user_name),
    password      => hiera("database_${database}_password", $percona::params::user_password),
    permissions   => hiera("database_${database}_permissions", $percona::params::user_permissions),
    grant         => hiera("database_${database}_grant", $percona::params::user_grant),
    remote        => hiera("database_${database}_allow_remote", $percona::params::allow_remote),
  }
}
