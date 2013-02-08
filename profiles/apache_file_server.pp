/**
 * General purpose file server profile.
 */
class file_server inherits base {

  #-----------------------------------------------------------------------------
  # Configurations

  $local_files = global_array('file_server_local_files', [])
  $cloud_files = global_array('file_server_cloud_files', [])

  #-----------------------------------------------------------------------------
  # Required systems

  include cloudfuse
  include apache

  global_include('file_server_classes')

  #---

  Class['base'] -> Class['cloudfuse'] -> Class['apache']

  #-----------------------------------------------------------------------------
  # Environment

  if ! empty($local_files) {
    file_server::apache_server { $local_files: }
  }

  if ! empty($cloud_files) {
    file_server::cloud_server { $cloud_files: }
  }
}

#*******************************************************************************
# Scalable resources
#*******************************************************************************

define file_server::cloud_server ( $server = $name ) {

  $mount_dir  = "${cloudfuse::params::mount_home}/${server}"
  $containers = global_param("file_server_${server}_cloudfuse_containers", [])

  #---

  if ! empty($containers) {
    cloudfuse::mount { $server:
      mount_dir     => $mount_dir,
      auth_url      => global_param("file_server_${server}_cloudfuse_auth_url", $cloudfuse::params::auth_url),
      cloud_user    => global_param("file_server_${server}_cloudfuse_cloud_user", $cloudfuse::params::cloud_user),
      cloud_api_key => global_param("file_server_${server}_cloudfuse_cloud_api_key", $cloudfuse::params::cloud_api_key),
      cache_timeout => global_param("file_server_${server}_cloudfuse_cache_timeout", $cloudfuse::params::cache_timeout),
      gid           => global_param("file_server_${server}_cloudfuse_gid", $cloudfuse::params::gid),
      umask         => global_param("file_server_${server}_cloudfuse_umask", $cloudfuse::params::umask),
    }

    file_server::apache_server { $containers:
      parent   => $server,
      web_home => $mount_dir,
      require  => Cloudfuse::Mount[$server],
    }
  }
}

#-------------------------------------------------------------------------------

define file_server::apache_server (

  $server   = $name,
  $parent   = '',
  $web_home = '',

) {

  $dynamic_attr = $parent ? {
    ''           => $server,
    default      => "${parent}_${server}"
  }

  $default_doc_root = "${apache::params::web_home}/${server}"
  $doc_root = $web_home ? {
    ''       => global_param("file_server_${dynamic_attr}_apache_doc_root", $default_doc_root),
    default  => $default_doc_root,
  }

  #---

  apache::vhost::file { $server:
    doc_root            => $doc_root,
    server_name         => global_param("file_server_${dynamic_attr}_apache_server_name", $apache::params::server_name),
    aliases             => global_param("file_server_${dynamic_attr}_apache_aliases", $apache::params::aliases),
    admin_email         => global_param("file_server_${dynamic_attr}_apache_admin_email", $apache::params::admin_email),
    vhost_ip            => global_param("file_server_${dynamic_attr}_apache_vhost_ip", $apache::params::vhost_ip),
    priority            => global_param("file_server_${dynamic_attr}_apache_priority", $apache::params::priority),
    options             => global_param("file_server_${dynamic_attr}_apache_options", $apache::params::options),
    http_port           => global_param("file_server_${dynamic_attr}_apache_http_port", $apache::params::http_port),
    https_port          => global_param("file_server_${dynamic_attr}_apache_https_port", $apache::params::https_port),
    use_ssl             => global_param("file_server_${dynamic_attr}_apache_use_ssl", $apache::params::use_ssl),
    ssl_cert            => global_param("file_server_${dynamic_attr}_apache_ssl_cert", $apache::params::ssl_cert),
    ssl_key             => global_param("file_server_${dynamic_attr}_apache_ssl_key", $apache::params::ssl_key),
    error_log_level     => global_param("file_server_${dynamic_attr}_apache_error_log_level", $apache::params::error_log_level),
    rewrite_log_level   => global_param("file_server_${dynamic_attr}_apache_rewrite_log_level", $apache::params::rewrite_log_level),
  }
}
