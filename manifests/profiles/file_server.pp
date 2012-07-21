/**
 * General purpose file server profile.
 */
class file_server inherits base {

  #-----------------------------------------------------------------------------
  # Configurations

  $doc_root = hiera('apache_doc_root')

  #-----------------------------------------------------------------------------
  # Required systems

  include cloudfuse
  include apache

  #---

  Class['base'] -> Class['cloudfuse'] -> Class['apache']

  #-----------------------------------------------------------------------------
  # Environment

  cloudfuse::mount { 'public-files':
    mount_dir => $doc_root,
  }

  apache::vhost::file { 'default':
    doc_root => $doc_root,
  }
}
