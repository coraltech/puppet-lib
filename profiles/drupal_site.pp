/**
 * Drupal web server profile.
 */
class drupal_site inherits base {

  #-----------------------------------------------------------------------------
  # Configurations

  $sites         = hiera('drupal_sites', [])
  $use_dev_tools = hiera('drupal_site_use_dev_tools', 'false')

  #-----------------------------------------------------------------------------
  # Required systems

  include php

  include php::mod::apc
  include php::mod::curl
  include php::mod::gd
  include php::mod::xmlrpc
  include php::mod::uploadprogress
  include php::mod::mysql

  include drupal

  #---

  include php::apache

  a2mod { 'php5':
    require => Class['php::apache'],
  }

  #---

  CLass['base'] -> Class['php'] -> Class['apache'] -> Class['drupal']

  #-----------------------------------------------------------------------------
  # Optional systems

  if $use_dev_tools {
    include php::mod::xdebug
  }

  if ! defined(Class['percona']) {
    include percona
    Class['base'] -> Class['percona']
  }

  #-----------------------------------------------------------------------------
  # Wrapper

  if ! empty($sites) {
    drupal_site::environment { $sites: }
  }
}

#---

define drupal_site::environment ( $site = $name ) {

  #-----------------------------------------------------------------------------
  # Configurations

  $default_domain                  = hiera("drupal_site_default_domain", '')
  $default_aliases                 = hiera("drupal_site_default_aliases", '')
  $default_site_ip                 = hiera("drupal_site_default_ip", $::ipaddress)
  $default_admin_email             = hiera("drupal_site_default_admin_email", '')

  $default_repo_name               = hiera("drupal_site_default_repo_name", 'panopoly')
  $default_source                  = hiera("drupal_site_default_source", 'git://git.drupal.org/project/panopoly.git')
  $default_revision                = hiera("drupal_site_default_revision", '7.x-1.x')

  $default_use_make                = hiera("drupal_site_default_use_make", 'true')
  $default_make_file               = hiera("drupal_site_default_make_file", 'build-panopoly.make')
  $default_include_repos           = hiera("drupal_site_default_include_repos", 'false')

  $default_site_dir                = hiera("drupal_site_default_conf_dir", 'default')
  $default_files_dir               = hiera("drupal_site_default_files_dir", '')

  $default_databases               = hiera_hash("drupal_site_default_databases", '')
  $default_base_url                = hiera("drupal_site_default_base_url", '')
  $default_cookie_domain           = hiera("drupal_site_default_cookie_domain", '')
  $default_session_max_lifetime    = hiera("drupal_site_default_session_max_lifetime", '')
  $default_session_cookie_lifetime = hiera("drupal_site_default_session_cookie_lifetime", '')
  $default_pcre_backtrack_limit    = hiera("drupal_site_default_pcre_backtrack_limit", '')
  $default_pcre_recursion_limit    = hiera("drupal_site_default_pcre_recursion_limit", '')
  $default_ini_settings            = hiera_hash("drupal_site_default_ini_settings", {})
  $default_conf                    = hiera_hash("drupal_site_default_conf", {})

  #---

  $domain                  = hiera("drupal_site_${site}_domain", $default_domain)
  $aliases                 = hiera("drupal_site_${site}_aliases", $default_aliases)
  $site_ip                 = hiera("drupal_site_${site}_ip", $default_site_ip)
  $admin_email             = hiera("drupal_site_${site}_admin_email", $default_admin_email)

  $repo_name               = hiera("drupal_site_${site}_repo_name", $default_repo_name)
  $source                  = hiera("drupal_site_${site}_source", $default_source)
  $revision                = hiera("drupal_site_${site}_revision", $default_revision)

  $use_make                = hiera("drupal_site_${site}_use_make", $default_use_make)
  $make_file               = hiera("drupal_site_${site}_make_file", $default_make_file)

  $release_dir             = "${apache::params::web_home}/releases"
  $include_repos           = hiera("drupal_site_${site}_include_repos", $default_include_repos)

  $home                    = "${apache::params::web_home}/${site}"
  $site_dir                = hiera("drupal_site_${site}_conf_dir", $default_site_dir)
  $files_dir               = hiera("drupal_site_${site}_files_dir", $default_files_dir)

  $databases               = hiera_hash("drupal_site_${site}_databases", $default_databases)

  $base_url                = hiera("drupal_site_${site}_base_url", $default_base_url)
  $cookie_domain           = hiera("drupal_site_${site}_cookie_domain", $default_cookie_domain)
  $session_max_lifetime    = hiera("drupal_site_${site}_session_max_lifetime", $default_session_max_lifetime)
  $session_cookie_lifetime = hiera("drupal_site_${site}_session_cookie_lifetime", $default_session_cookie_lifetime)
  $pcre_backtrack_limit    = hiera("drupal_site_${site}_pcre_backtrack_limit", $default_pcre_backtrack_limit)
  $pcre_recursion_limit    = hiera("drupal_site_${site}_pcre_recursion_limit", $default_pcre_recursion_limit)
  $ini_settings            = hiera_hash("drupal_site_${site}_ini_settings", $default_ini_settings)
  $conf                    = hiera_hash("drupal_site_${site}_conf", $default_conf)

  #-----------------------------------------------------------------------------
  # Environment

  apache::vhost::file { $site:
    aliases             => $aliases,
    admin_email         => $admin_email,
    doc_root            => $home,
    vhost_ip            => $site_ip ? {
      ''                  => '*',
      default             => $site_ip,
    },
    require             => A2mod['php5'],
  }

  drupal::site { $site:
    domain                  => $domain,
    aliases                 => $aliases,
    home                    => $home,
    release_dir             => $release_dir,
    use_make                => $use_make,
    make_file               => $make_file,
    repo_name               => $repo_name,
    source                  => $source,
    revision                => $revision,
    include_repos           => $include_repos,
    server_user             => $apache::params::user,
    server_group            => $apache::params::group,
    site_dir                => $site_dir,
    site_ip                 => $site_ip,
    admin_email             => $admin_email,
    files_dir               => $files_dir,
    databases               => $databases,
    base_url                => $base_url,
    cookie_domain           => $cookie_domain,
    session_max_lifetime    => $session_max_lifetime,
    session_cookie_lifetime => $session_cookie_lifetime,
    pcre_backtrack_limit    => $pcre_backtrack_limit,
    pcre_recursion_limit    => $pcre_recursion_limit,
    ini_settings            => $ini_settings,
    conf                    => $conf,
    require                 => Apache::Vhost::File[$site],
  }
}
