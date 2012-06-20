
class params_default {

  #-----------------------------------------------------------------------------
  # To use:
  #
  # 1. Copy this file to "manifests/params.pp"
  # 2. Rename this class to "params".
  # 3. Fill in your values, particularly any values with a <VALUE> format below.

  #-----------------------------------------------------------------------------
  # Core settings

  $locale     = 'en_US.UTF-8 UTF-8'
  $allow_icmp = true

  #-----------------------------------------------------------------------------
  # User settings

  $user_umask = 002

  #-----------------------------------------------------------------------------
  # Administrator

  $admin_name         = 'admin'
  $admin_group        = $admin_name
  $admin_editor       = 'vim'
  $admin_email        = '<YOUR ADMIN EMAIL>'
  $admin_ssh_key      = '<YOUR PUBLIC SSH KEY HERE>'
  $admin_ssh_key_type = 'rsa'

  #-----------------------------------------------------------------------------
  # SSH settings

  $ssh_port = 22

  #-----------------------------------------------------------------------------
  # Git settings

  $git_user       = 'git'
  $git_group      = 'git'
  $git_home       = '/var/git'
  $git_root_email = ''
  $git_skel_email = ''

  #-----------------------------------------------------------------------------
  # Puppet settings

  $puppet_repo     = 'puppet.git'
  $puppet_path     = "${git_home}/${puppet_repo}"
  $puppet_source   = 'git://github.com/coraltech/puppet-lib.git'
  $puppet_revision = 'master'

  #-----------------------------------------------------------------------------
  # Database settings

  $percona_version = '5.5'

  $db_allow_remote = true
  $db_port         = 3306

  $db_admin_user   = 'admin'
  $db_admin_pw     = 'admin'
  $db_admin_access = 'localhost'

  #-----------------------------------------------------------------------------
  # PHP settings

  $php_use_xdebug  = true
  $php_use_apc     = true

  $php_packages    = [
    'php5-curl',
    'php5-gd',
    'php5-mysql',
    'php5-tidy',
    'php5-xmlrpc',
  ]

  $pear_packages   = []

  $pecl_packages   = [
    'uploadprogress',
  ]

  $php_web_enabled = true

  #-----------------------------------------------------------------------------
  # Apache settings

  $apache_user              = 'www-data'
  $apache_group             = $apache_user

  $apache_default_ip        = '*'
  $apache_options           = 'Indexes FollowSymLinks MultiViews'

  $http_port                = 80

  $use_ssl                  = false
  $ssl_cert                 = undef
  $ssl_key                  = undef
  $https_port               = 443

  $apache_use_dev           = true

  $apache_modules           = [
    'alias',
    'autoindex',
    'deflate',
    'env',
    'mime',
    'rewrite',
    'ssl',
    'vhost_alias',
  ]

  $apache_error_log_level   = 'warn'
  $apache_rewrite_log_level = 0

  #-----------------------------------------------------------------------------
  # Drupal settings

  $drupal_site_dir = 'default'

  $drupal_session_max_lifetime    = 200000
  $drupal_session_cookie_lifetime = 2000000

  $drupal_pcre_backtrack_limit    = 200000
  $drupal_pcre_recursion_limit    = 200000

  $ini_settings                   = undef

  $conf                           = undef

  #-----------------------------------------------------------------------------
  # Panopoly settings

  $panopoly_db            = 'panopoly'
  $panopoly_db_user       = 'panopoly'
  $panopoly_db_pw         = 'panopoly'

  $panopoly_domain        = 'drupal.loc'
  $panopoly_aliases       = ''

  $panopoly_repo_name     = 'panopoly'
  $panopoly_source        = 'git://git.drupal.org/project/panopoly.git'
  $panopoly_revision      = '7.x-1.x'

  $panopoly_priority      = 15

  $panopoly_make_file     = 'build-panopoly.make'
  $panopoly_include_repos = true

  $panopoly_files_dir     = undef

  $panopoly_databases     = undef

  $panopoly_base_url      = undef
  $panopoly_cookie_domain = undef
}
