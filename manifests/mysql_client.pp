
class mysql_client inherits base {

  include params

  #-----------------------------------------------------------------------------
  # MySQL(ish) database client

  class { 'percona':
    client          => true,
    server          => false,
    percona_version => $params::percona_version,
  }
}
