
class mysql_server inherits base {

  include params

  #-----------------------------------------------------------------------------
  # MySQL(ish) database

  class { 'percona':
    server          => true,
    port            => $params::db_port,
    allow_remote    => $params::db_allow_remote,
    percona_version => $params::percona_version,
  }

  #if $params::db_admin_user and $params::db_admin_pw {
  #  percona::user { $params::db_admin_user:
  #    password => $params::db_admin_pw,
  #    ensure   => 'present',
  #    host     => $params::db_admin_access,
  #    database => '*',
  #    grant    => true,
  #  }
  #}
}
