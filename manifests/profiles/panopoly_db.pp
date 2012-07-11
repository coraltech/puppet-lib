/**
 * Panopoly database server profile.
 */
class panopoly_db {

  include mysql_server

  #-----------------------------------------------------------------------------

  $panopoly_db      = hiera('panopoly_db', 'panopoly')
  $panopoly_db_user = hiera('panopoly_db_user', 'panopoly')
  $panopoly_db_pw   = hiera('panopoly_db_pw', 'panopoly')

  $db_allow_remote  = hiera('db_allow_remote', false)

  #-----------------------------------------------------------------------------
  # MySQL configurations

  percona::database { $panopoly_db: ensure => 'present' }

  Percona::User {
    user_name => $panopoly_db_user,
    password  => $panopoly_db_pw,
    database  => $panopoly_db,
    ensure    => 'present',
    grant     => true,
  }

  percona::user { 'panopoly_local': host => 'localhost' }

  if $db_allow_remote and $db_allow_remote != 'false' {
    percona::user { 'panopoly_remote': host => '%' }
  }
}
