/**
 * Apache powered Drupal web server profile.
 */
class apache_drupal inherits base {

  #-----------------------------------------------------------------------------
  # Configurations

  $sites         = hiera('apache_drupal_sites', [])
  $use_dev_tools = hiera('apache_drupal_use_dev_tools', 'false')

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
  # Environment

  if ! empty($sites) {
    apache_drupal::site { $sites: }
  }
}

#*******************************************************************************
# Scalable resources
#*******************************************************************************

define apache_drupal::site ( $site = $name ) {

  $drupal_home = "${apache::params::web_home}/${site}"

  $domain      = hiera("apache_drupal_site_${site}_domain", $site)
  $aliases     = hiera("apache_drupal_site_${site}_aliases", $drupal::params::aliases)
  $admin_email = hiera("apache_drupal_site_${site}_admin_email", $drupal::params::admin_email)

  #---

  drupal::site { $site:
    home                    => $drupal_home,
    domain                  => $domain,
    aliases                 => $aliases,
    server_user             => $apache::params::user,
    server_group            => $apache::params::group,
    admin_email             => $admin_email,
    use_make                => hiera("apache_drupal_site_${site}_drupal_use_make", $drupal::params::use_make),
    repo_name               => hiera("apache_drupal_site_${site}_drupal_repo_name", $drupal::params::repo_name),
    source                  => hiera("apache_drupal_site_${site}_drupal_source", $drupal::params::source),
    revision                => hiera("apache_drupal_site_${site}_drupal_revision", $drupal::params::revision),
    make_file               => hiera("apache_drupal_site_${site}_drupal_make_file", $drupal::params::make_file),
    include_repos           => hiera("apache_drupal_site_${site}_drupal_include_repos", $drupal::params::include_repos),
    site_ip                 => hiera("apache_drupal_site_${site}_drupal_site_ip", $drupal::params::site_ip),
    site_dir                => hiera("apache_drupal_site_${site}_drupal_site_dir", $drupal::params::site_dir),
    files_dir               => hiera("apache_drupal_site_${site}_drupal_files_dir", $drupal::params::files_dir),
    databases               => hiera_hash("apache_drupal_site_${site}_drupal_databases", $drupal::params::databases),
    base_url                => hiera("apache_drupal_site_${site}_drupal_base_url", $drupal::params::base_url),
    cookie_domain           => hiera("apache_drupal_site_${site}_drupal_cookie_domain", $drupal::params::cookie_domain),
    session_max_lifetime    => hiera("apache_drupal_site_${site}_drupal_session_max_lifetime", $drupal::params::session_max_lifetime),
    session_cookie_lifetime => hiera("apache_drupal_site_${site}_drupal_session_cookie_lifetime", $drupal::params::session_cookie_lifetime),
    pcre_backtrack_limit    => hiera("apache_drupal_site_${site}_drupal_pcre_backtrack_limit", $drupal::params::pcre_backtrack_limit),
    pcre_recursion_limit    => hiera("apache_drupal_site_${site}_drupal_pcre_recursion_limit", $drupal::params::pcre_recursion_limit),
    ini_settings            => hiera_hash("apache_drupal_site_${site}_drupal_ini_settings", $drupal::params::ini_settings),
    conf                    => hiera_hash("apache_drupal_site_${site}_drupal_conf", $drupal::params::conf),
    require                 => Class['php'],
  }

  apache::vhost::file { $site:
    doc_root            => $drupal_home,
    server_name         => $domain,
    aliases             => $aliases,
    admin_email         => $admin_email,
    vhost_ip            => hiera("apache_drupal_site_${site}_apache_vhost_ip", $apache::params::vhost_ip),
    priority            => hiera("apache_drupal_site_${site}_apache_priority", $apache::params::priority),
    options             => hiera("apache_drupal_site_${site}_apache_options", $apache::params::options),
    http_port           => hiera("apache_drupal_site_${site}_apache_http_port", $apache::params::http_port),
    https_port          => hiera("apache_drupal_site_${site}_apache_https_port", $apache::params::https_port),
    use_ssl             => hiera("apache_drupal_site_${site}_apache_use_ssl", $apache::params::use_ssl),
    ssl_cert            => hiera("apache_drupal_site_${site}_apache_ssl_cert", $apache::params::ssl_cert),
    ssl_key             => hiera("apache_drupal_site_${site}_apache_ssl_key", $apache::params::ssl_key),
    error_log_level     => hiera("apache_drupal_site_${site}_apache_error_log_level", $apache::params::error_log_level),
    rewrite_log_level   => hiera("apache_drupal_site_${site}_apache_rewrite_log_level", $apache::params::rewrite_log_level),
    require             => [ A2mod['php5'], Drupal::Site[$site] ],
  }
}
