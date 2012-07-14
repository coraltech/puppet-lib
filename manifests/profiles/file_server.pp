/**
 * General purpose file server profile.
 */
class file_server inherits base {

  #-----------------------------------------------------------------------------

  $cloudfuse_auth_url             = hiera('cloudfuse_auth_url', 'https://auth.api.rackspacecloud.com/v1.0')
  $cloudfuse_cache_timeout        = hiera('cloudfuse_cache_timeout', 300)

  $cloud_user                     = hiera('cloudfuse_cloud_user')
  $cloud_api_key                  = hiera('cloudfuse_cloud_api_key')
  $container                      = hiera('cloudfuse_container', 'public')

  $domain                         = hiera('files_domain')
  $aliases                        = hiera('files_aliases')
  $priority                       = hiera('files_priority', 99)
  $doc_root                       = hiera('files_doc_root')
  $apache_default_ip              = hiera('apache_default_ip', '*')
  $apache_options                 = hiera('apache_options', 'Indexes FollowSymLinks MultiViews')
  $http_port                      = hiera('http_port', 80)
  $use_ssl                        = hiera('use_ssl', false)
  $ssl_cert                       = hiera('ssl_cert', '')
  $ssl_key                        = hiera('ssl_key', '')
  $https_port                     = hiera('https_port', 443)
  $apache_error_log_level         = hiera('apache_error_log_level', 'warn')
  $apache_rewrite_log_level       = hiera('apache_rewrite_log_level', 0)
  $admin_email                    = hiera('admin_email', '')
  $apache_user                    = hiera('apache_user', 'www-data')
  $apache_group                   = hiera('apache_group', 'www-data')

  #-----------------------------------------------------------------------------
  # CloudFuse

  include cloud_files

  cloudfuse::mount { 'public-files':
    mount_path    => $doc_root,
    auth_url      => $cloudfuse_auth_url,
    cache_timeout => $cloudfuse_cache_timeout,
    cloud_user    => $cloud_user,
    cloud_api_key => $cloud_api_key,
    container     => $container,
  }

  #-----------------------------------------------------------------------------
  # Apache configurations

  include apache_server

  apache::vhost { $domain:
    aliases            => $aliases,
    doc_root           => $doc_root,
    vhost_ip           => $apache_default_ip,
    priority           => $priority,
    options            => $apache_options,
    http_port          => $http_port,
    use_ssl            => $use_ssl ? {
      false              => false,
      /(false|)/         => false,
      default            => true,
    },
    ssl_cert           => $ssl_cert,
    ssl_key            => $ssl_key,
    https_port         => $https_port,
    error_log_level    => $apache_error_log_level,
    rewrite_log_level  => $apache_rewrite_log_level,
    admin_email        => $admin_email,
  }

  #-----------------------------------------------------------------------------
  # Execution order

  CLass['base']
  -> Class['cloud_files'] -> Class['apache_server']
}
