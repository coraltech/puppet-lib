
class db inherits base {

  include params

  #-----------------------------------------------------------------------------
  # MySQL(ish) database

  class { 'percona':
    server          => true,
    percona_version => '5.5',
  }
}
