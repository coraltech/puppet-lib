
class mysql_server {

  $percona_version = hiera('percona_version', '5.5')

  $db_allow_remote = hiera('db_allow_remote', false)

  $db_port         = hiera('db_port', 3306)
  $mysqlchk_port   = hiera('db_status_port', 9200)

  $server_id       = hiera('db_server_id', 1)
  $server_ip       = hiera('db_server_ip', $::ipaddress)
  $origin_ip       = hiera('db_origin_ip', '')

  $db_admin_user   = hiera('db_admin_user', 'admin')
  $db_admin_pw     = hiera('db_admin_pw', 'admin')
  $db_admin_access = hiera('db_admin_access', 'localhost')

  #-----------------------------------------------------------------------------
  # MySQL(ish) database

  class { 'percona':
    server          => true,
    port            => $db_port,
    mysqlchk_port   => $mysqlchk_port,
    allow_remote    => $db_allow_remote ? {
      false           => false,
      /(false|)/      => false,
      default         => true,
    },
    server_id       => $server_id,
    server_ip       => $server_ip,
    origin_ip       => $origin_ip,
    percona_version => $percona_version,
  }

  if $db_admin_user and $db_admin_pw {
    #percona::user { $db_admin_user:
    #  password => $db_admin_pw,
    #  ensure   => 'present',
    #  host     => $db_admin_access,
    #  database => '*',
    #  grant    => true,
    #}
  }
}
