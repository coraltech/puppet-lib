
class cloud_files {

  $cloudfuse_source   = hiera('cloudfuse_source', 'git://github.com/redbo/cloudfuse.git')
  $cloudfuse_revision = hiera('cloudfuse_revision', 'master')

  #-----------------------------------------------------------------------------
  # Web server

  class { 'cloudfuse':
    cloudfuse_source   => $cloudfuse_source,
    cloudfuse_revision => $cloudfuse_revision,
  }
}
