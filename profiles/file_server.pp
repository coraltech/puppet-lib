/**
 * General purpose file server profile.
 */
class file_server inherits base {

  #-----------------------------------------------------------------------------
  # Configurations

  $servers = unique(hiera_array('file_servers', []))

  #-----------------------------------------------------------------------------
  # Required systems

  include cloudfuse
  include apache

  #---

  Class['base'] -> Class['cloudfuse'] -> Class['apache']

  #-----------------------------------------------------------------------------
  # Environment

  if ! empty($servers) {
    file_server::server { $servers:
      require => Class['apache'],
    }
  }
}

#*******************************************************************************
# Scalable resources
#*******************************************************************************

define file_server::server ( $server = $name ) {

  $mount_dir = "${cloudfuse::params::os_mount_home}/${server}"

  #---

  cloudfuse::mount { $server:
    mount_dir     => $mount_dir,
    auth_url      => hiera("file_server_${server}_cloudfuse_auth_url", $cloudfuse::params::auth_url),
    cloud_user    => hiera("file_server_${server}_cloudfuse_cloud_user", $cloudfuse::params::cloud_user),
    cloud_api_key => hiera("file_server_${server}_cloudfuse_cloud_api_key", $cloudfuse::params::cloud_api_key),
    container     => hiera("file_server_${server}_cloudfuse_container", $cloudfuse::params::container),
    cache_timeout => hiera("file_server_${server}_cloudfuse_cache_timeout", $cloudfuse::params::cache_timeout),
    gid           => hiera("file_server_${server}_cloudfuse_gid", $cloudfuse::params::gid),
    umask         => hiera("file_server_${server}_cloudfuse_umask", $cloudfuse::params::umask),
  }

  apache::vhost::file { $server:
    doc_root            => $mount_dir,
    aliases             => hiera("file_server_${server}_apache_aliases", $apache::params::aliases),
    admin_email         => hiera("file_server_${server}_apache_admin_email", $apache::params::admin_email),
    vhost_ip            => hiera("file_server_${server}_apache_vhost_ip", $apache::params::vhost_ip),
    priority            => hiera("file_server_${server}_apache_priority", $apache::params::priority),
    options             => hiera("file_server_${server}_apache_options", $apache::params::options),
    http_port           => hiera("file_server_${server}_apache_http_port", $apache::params::http_port),
    https_port          => hiera("file_server_${server}_apache_https_port", $apache::params::https_port),
    use_ssl             => hiera("file_server_${server}_apache_use_ssl", $apache::params::use_ssl),
    ssl_cert            => hiera("file_server_${server}_apache_ssl_cert", $apache::params::ssl_cert),
    ssl_key             => hiera("file_server_${server}_apache_ssl_key", $apache::params::ssl_key),
    error_log_level     => hiera("file_server_${server}_apache_error_log_level", $apache::params::error_log_level),
    rewrite_log_level   => hiera("file_server_${server}_apache_rewrite_log_level", $apache::params::rewrite_log_level),
    extra               => hiera("file_server_${server}_apache_extra", {}),
    require             => Cloudfuse::Mount[$server],
  }
}
