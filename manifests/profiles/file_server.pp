/**
 * General purpose file server profile.
 */
class file_server inherits base {

  #-----------------------------------------------------------------------------
  # Required systems

  include cloudfuse
  include apache

  #---

  Class['base'] -> Class['cloudfuse'] -> Class['apache']

  #-----------------------------------------------------------------------------
  # Environment

  cloudfuse::mount { 'public-files': }

  apache::vhost::file { 'default':
    doc_root => $cloudfuse::params::os_mount_dir,
  }
}
