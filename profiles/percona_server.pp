/**
 * Percona database server profile.
 */
class percona_server inherits base {

  #-----------------------------------------------------------------------------
  # Configurations

  $databases = global_array('percona_server_databases', [])

  #-----------------------------------------------------------------------------
  # Required systems

  class { 'percona':
    server => true,
  }

  global_include('percona_server_classes')

  #-----------------------------------------------------------------------------
  # Environment

  if ! empty($databases) {
    percona_server::database { $databases: }
  }
}

#*******************************************************************************
# Scalable resources
#*******************************************************************************

define percona_server::database ( $database = $name ) {

  $databases = global_array("percona_server_database_${database}_databases", [])

  if ! empty($databases) {
    $database_real = $databases
  }
  else {
    $database_real = $database
  }

  percona::database { $database_real:
    ensure        => global_param("percona_server_database_${database}_ensure", 'present'),
    sql_dump_file => global_param("percona_server_database_${database}_sql_dump_file", $percona::params::database_sql_dump_file),
    user_name     => global_param("percona_server_database_${database}_user", $percona::params::user_name),
    password      => global_param("percona_server_database_${database}_password", $percona::params::user_password),
    permissions   => global_param("percona_server_database_${database}_permissions", $percona::params::user_permissions),
    grant         => global_param("percona_server_database_${database}_grant", $percona::params::user_grant),
    remote        => global_param("percona_server_database_${database}_allow_remote", $percona::params::allow_remote),
  }
}
