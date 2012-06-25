
class mysql_server inherits base {

  $percona_version = hiera('percona_version')

  $db_port         = hiera('db_port')
  $db_allow_remote = hiera('db_allow_remote')

  $db_admin_user   = hiera('db_admin_user')
  $db_admin_pw     = hiera('db_admin_pw')
  $db_admin_access = hiera('db_admin_access')

  #-----------------------------------------------------------------------------
  # MySQL(ish) database

  class { 'percona':
    server          => true,
    port            => $db_port,
    allow_remote    => $db_allow_remote,
    percona_version => $percona_version,
  }

  if $db_admin_user and $db_admin_pw {
    percona::user { $db_admin_user:
      password => $db_admin_pw,
      ensure   => 'present',
      host     => $db_admin_access,
      database => '*',
      grant    => true,
    }
  }
}
