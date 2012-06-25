
node panopoly {

  $panopoly_databases             = hiera_hash('panopoly_databases')

  $panopoly_db                    = hiera('panopoly_db')
  $panopoly_db_user               = hiera('panopoly_db_user')
  $panopoly_db_pw                 = hiera('panopoly_db_pw')

  $db_allow_remote                = hiera('db_allow_remote')

  $panopoly_domain                = hiera('panopoly_domain')

  $panopoly_aliases               = hiera_array('panopoly_aliases')
  $panopoly_repo_name             = hiera('panopoly_repo_name')
  $panopoly_source                = hiera('panopoly_source')
  $panopoly_revision              = hiera('panopoly_revision')
  $panopoly_priority              = hiera('panopoly_priority')
  $panopoly_make_file             = hiera('panopoly_make_file')
  $panopoly_include_repos         = hiera('panopoly_include_repos')
  $panopoly_files_dir             = hiera('panopoly_files_dir')
  $panopoly_base_url              = hiera('panopoly_base_url')
  $panopoly_cookie_domain         = hiera('panopoly_cookie_domain')

  $git_home                       = hiera('git_home')
  $git_user                       = hiera('git_user')
  $git_group                      = hiera('git_group')

  $apache_default_ip              = hiera('apache_default_ip')
  $apache_options                 = hiera('apache_options')
  $http_port                      = hiera('http_port')
  $use_ssl                        = hiera('use_ssl')
  $ssl_cert                       = hiera('ssl_cert')
  $ssl_key                        = hiera('ssl_key')
  $https_port                     = hiera('https_port')
  $apache_error_log_level         = hiera('apache_error_log_level')
  $apache_rewrite_log_level       = hiera('apache_rewrite_log_level')
  $admin_email                    = hiera('admin_email')
  $apache_user                    = hiera('apache_user')
  $apache_group                   = hiera('apache_group')

  $drupal_site_dir                = hiera('drupal_site_dir')
  $drupal_session_max_lifetime    = hiera('drupal_session_max_lifetime')
  $drupal_session_cookie_lifetime = hiera('drupal_session_cookie_lifetime')
  $drupal_pcre_backtrack_limit    = hiera('drupal_pcre_backtrack_limit')
  $drupal_pcre_recursion_limit    = hiera('drupal_pcre_recursion_limit')
  $drupal_ini_settings            = hiera_hash('drupal_ini_settings')
  $drupal_conf                    = hiera_hash('drupal_conf')

  #-----------------------------------------------------------------------------

  include php_application
  include apache_server

  if ! $panopoly_databases {
    include mysql_server

    percona::database { $panopoly_db: ensure => 'present' }

    Percona::User {
      user_name => $panopoly_db_user,
      password  => $panopoly_db_pw,
      database  => $panopoly_db,
      ensure    => 'present',
      grant     => true,
    }

    percona::user { 'panopoly_local': host => 'localhost' }

    if $db_allow_remote {
      percona::user { 'panopoly_remote': host => '%' }
    }
  }
  else {
    include mysql_client
  }

  include drupal

  drupal::site { $panopoly_domain:
    aliases                 => $panopoly_aliases,
    repo_name               => $panopoly_repo_name,
    source                  => $panopoly_source,
    revision                => $panopoly_revision,
    vhost_priority          => $panopoly_priority,
    use_make                => true,
    make_file               => $panopoly_make_file,
    include_repos           => $panopoly_include_repos,
    files_dir               => $panopoly_files_dir,
    databases               => $panopoly_databases,
    base_url                => $panopoly_base_url,
    cookie_domain           => $panopoly_cookie_domain,
    git_home                => $git_home,
    git_user                => $git_user,
    git_group               => $git_group,
    vhost_ip                => $apache_default_ip,
    vhost_options           => $apache_options,
    http_port               => $http_port,
    use_ssl                 => $use_ssl,
    ssl_cert                => $ssl_cert,
    ssl_key                 => $ssl_key,
    https_port              => $https_port,
    error_log_level         => $apache_error_log_level,
    rewrite_log_level       => $apache_rewrite_log_level,
    admin_email             => $admin_email,
    apache_user             => $apache_user,
    apache_group            => $apache_group,
    site_dir                => $drupal_site_dir,
    session_max_lifetime    => $drupal_session_max_lifetime,
    session_cookie_lifetime => $drupal_session_cookie_lifetime,
    pcre_backtrack_limit    => $drupal_pcre_backtrack_limit,
    pcre_recursion_limit    => $drupal_pcre_recursion_limit,
    ini_settings            => $drupal_ini_settings,
    conf                    => $drupal_conf,
  }
}
