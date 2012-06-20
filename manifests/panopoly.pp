
node panopoly {

  #-----------------------------------------------------------------------------

  include params

  include php_application
  include apache_server

  if ! $params::panopoly_databases {
    include mysql_server

    percona::database { $params::panopoly_db: ensure => 'present' }

    Percona::User {
      user_name => $params::panopoly_db_user,
      password  => $params::panopoly_db_pw,
      database  => $params::panopoly_db,
      ensure    => 'present',
      grant     => true,
    }

    percona::user { 'panopoly_local': host => 'localhost' }

    if $params::db_allow_remote {
      percona::user { 'panopoly_remote': host => '%' }
    }
  }
  else {
    include mysql_client
  }

  include drupal

  drupal::site { $params::panopoly_domain:
    aliases                 => $params::panopoly_aliases,
    repo_name               => $params::panopoly_repo_name,
    source                  => $params::panopoly_source,
    revision                => $params::panopoly_revision,
    vhost_priority          => $params::panopoly_priority,
    use_make                => true,
    make_file               => $params::panopoly_make_file,
    include_repos           => $params::panopoly_include_repos,
    files_dir               => $params::panopoly_files_dir,
    databases               => $params::panopoly_databases,
    base_url                => $params::panopoly_base_url,
    cookie_domain           => $params::panopoly_cookie_domain,
    git_home                => $params::git_home,
    git_user                => $params::git_user,
    git_group               => $params::git_group,
    vhost_ip                => $params::apache_default_ip,
    vhost_options           => $params::apache_options,
    http_port               => $params::http_port,
    use_ssl                 => $params::use_ssl,
    ssl_cert                => $params::ssl_cert,
    ssl_key                 => $params::ssl_key,
    https_port              => $params::https_port,
    error_log_level         => $params::apache_error_log_level,
    rewrite_log_level       => $params::apache_rewrite_log_level,
    admin_email             => $params::admin_email,
    apache_user             => $params::apache_user,
    apache_group            => $params::apache_group,
    site_dir                => $params::drupal_site_dir,
    session_max_lifetime    => $params::drupal_session_max_lifetime,
    session_cookie_lifetime => $params::drupal_session_cookie_lifetime,
    pcre_backtrack_limit    => $params::drupal_pcre_backtrack_limit,
    pcre_recursion_limit    => $params::drupal_pcre_recursion_limit,
    ini_settings            => $params::ini_settings,
    conf                    => $params::conf,
  }
}
