
class mysql_client {

  $percona_version = hiera('percona_version', '5.5')

  #-----------------------------------------------------------------------------
  # MySQL(ish) database client

  class { 'percona':
    server          => false,
    percona_version => $percona_version,
  }
}
