
class mysql_client inherits base {

  $percona_version = hiera('percona_version')

  #-----------------------------------------------------------------------------
  # MySQL(ish) database client

  class { 'percona':
    client          => true,
    server          => false,
    percona_version => $percona_version,
  }
}
