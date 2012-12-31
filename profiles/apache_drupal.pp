/**
 * Apache powered Drupal web server profile.
 */
class apache_drupal inherits base {

  #-----------------------------------------------------------------------------
  # Configurations

  $php_modules = global_array('apache_drupal_php_modules', [])
  $sites       = global_array('apache_drupal_sites', [])

  #-----------------------------------------------------------------------------
  # Required systems

  include apache
  include drupal

  include php
  include php::apache
  include php::mod::mysql

  global_include('apache_drupal_classes')

  #---

  a2mod { 'php5':
    require => Class['php::apache'],
  }

  #---

  Class['base'] -> Class['php']
  Class['base'] -> Class['apache']
  Class['php'] -> Class['drupal']

  #-----------------------------------------------------------------------------
  # Environment

  if ! empty($php_modules) {
    apache_drupal::php_module { $php_modules: }
  }

  if ! empty($sites) {
    apache_drupal::site { $sites: }
  }
}

#*******************************************************************************
# Scalable resources
#*******************************************************************************

define apache_drupal::php_module ( $module = $name ) {
  php::module { $module:
    ensure         => global_param("apache_drupal_php_module_${module}_ensure", $php::params::module_ensure),
    package_prefix => global_param("apache_drupal_php_module_${module}_package_prefix", $php::params::module_package_prefix),
    extra_packages => global_array("apache_drupal_php_module_${module}_extra_packages", []),
    extra_ensure   => global_param("apache_drupal_php_module_${module}_extra_ensure", $php::params::module_extra_ensure),
    content        => global_param("apache_drupal_php_module_${module}_content", $php::params::module_content),
    provider       => global_param("apache_drupal_php_module_${module}_provider", $php::params::module_provider),
  }
}

#-------------------------------------------------------------------------------

define apache_drupal::site ( $site = $name ) {

  $drupal_home = "${apache::params::web_home}/${site}"

  $domain      = global_param("apache_drupal_site_${site}_domain", $site)
  $aliases     = global_param("apache_drupal_site_${site}_aliases", $drupal::params::aliases)
  $admin_email = global_param("apache_drupal_site_${site}_admin_email", $drupal::params::admin_email)

  #---

  drupal::site { $site:
    home                    => $drupal_home,
    domain                  => $domain,
    aliases                 => $aliases,
    server_user             => $apache::params::user,
    server_group            => $apache::params::group,
    admin_email             => $admin_email,
    use_make                => global_param("apache_drupal_site_${site}_drupal_use_make", $drupal::params::use_make),
    repo_name               => global_param("apache_drupal_site_${site}_drupal_repo_name", $drupal::params::repo_name),
    source                  => global_param("apache_drupal_site_${site}_drupal_source", $drupal::params::source),
    revision                => global_param("apache_drupal_site_${site}_drupal_revision", $drupal::params::revision),
    make_file               => global_param("apache_drupal_site_${site}_drupal_make_file", $drupal::params::make_file),
    include_repos           => global_param("apache_drupal_site_${site}_drupal_include_repos", $drupal::params::include_repos),
    site_ip                 => global_param("apache_drupal_site_${site}_drupal_site_ip", $drupal::params::site_ip),
    site_dir                => global_param("apache_drupal_site_${site}_drupal_site_dir", $drupal::params::site_dir),
    files_dir               => global_param("apache_drupal_site_${site}_drupal_files_dir", $drupal::params::files_dir),
    databases               => global_hash("apache_drupal_site_${site}_drupal_databases", $drupal::params::databases),
    base_url                => global_param("apache_drupal_site_${site}_drupal_base_url", $drupal::params::base_url),
    cookie_domain           => global_param("apache_drupal_site_${site}_drupal_cookie_domain", $drupal::params::cookie_domain),
    session_max_lifetime    => global_param("apache_drupal_site_${site}_drupal_session_max_lifetime", $drupal::params::session_max_lifetime),
    session_cookie_lifetime => global_param("apache_drupal_site_${site}_drupal_session_cookie_lifetime", $drupal::params::session_cookie_lifetime),
    pcre_backtrack_limit    => global_param("apache_drupal_site_${site}_drupal_pcre_backtrack_limit", $drupal::params::pcre_backtrack_limit),
    pcre_recursion_limit    => global_param("apache_drupal_site_${site}_drupal_pcre_recursion_limit", $drupal::params::pcre_recursion_limit),
    ini_settings            => global_hash("apache_drupal_site_${site}_drupal_ini_settings", $drupal::params::ini_settings),
    conf                    => global_hash("apache_drupal_site_${site}_drupal_conf", $drupal::params::conf),
  }

  apache::vhost::file { $site:
    doc_root            => $drupal_home,
    server_name         => $domain,
    aliases             => $aliases,
    admin_email         => $admin_email,
    vhost_ip            => global_param("apache_drupal_site_${site}_apache_vhost_ip", $apache::params::vhost_ip),
    priority            => global_param("apache_drupal_site_${site}_apache_priority", $apache::params::priority),
    options             => global_param("apache_drupal_site_${site}_apache_options", $apache::params::options),
    http_port           => global_param("apache_drupal_site_${site}_apache_http_port", $apache::params::http_port),
    https_port          => global_param("apache_drupal_site_${site}_apache_https_port", $apache::params::https_port),
    use_ssl             => global_param("apache_drupal_site_${site}_apache_use_ssl", $apache::params::use_ssl),
    ssl_cert            => global_param("apache_drupal_site_${site}_apache_ssl_cert", $apache::params::ssl_cert),
    ssl_key             => global_param("apache_drupal_site_${site}_apache_ssl_key", $apache::params::ssl_key),
    error_log_level     => global_param("apache_drupal_site_${site}_apache_error_log_level", $apache::params::error_log_level),
    rewrite_log_level   => global_param("apache_drupal_site_${site}_apache_rewrite_log_level", $apache::params::rewrite_log_level),
    require             => [ A2mod['php5'], Drupal::Site[$site] ],
  }
}
