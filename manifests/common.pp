
class config::common {

  #
  # IMOPTANT: Keep these configurations as few as possible!
  #
  # We just want to set up Puppet and Hiera so we can begin the "real" process
  # with the selected server profile.  Most configurations should be managed
  # through Hiera.
  #
  #-----------------------------------------------------------------------------

  $git_home            = '/var/git'
  $git_user            = 'git'
  $git_group           = 'git'

  $puppet_repo         = 'puppet.git'
  $puppet_path         = "${git_home}/${puppet_repo}"
  $puppet_module_paths = [ "${puppet_path}/modules" ]
  $puppet_source       = 'git://github.com/coraltech/puppet-lib.git'
  $puppet_revision     = 'master'

  $config_repo         = 'config.git'
  $config_path         = "${git_home}/${config_repo}"

  $hiera_common_config = "${config_path}/common.json"
  $hiera_hierarchy     = [ '%{environment}', '%{hostname}', 'common' ]
  $hiera_backends      = {
    'json'   => $config_path,
    'puppet' => 'config',
  }
}
