
class config {

  #
  # IMOPTANT: Keep these configurations as few as possible!
  #
  # We just want to set up Puppet and Hiera so we can begin the "real" process
  # with the selected server profile.  Most configurations should be managed
  # through Hiera.
  #
  #-----------------------------------------------------------------------------

  $git_home            = '/var/git'

  $puppet_repo         = 'puppet.git'
  $puppet_path         = "${git_home}/${puppet_repo}"

  $config_repo         = 'config.git'
  $config_path         = "${git_home}/${config_repo}"

  $puppet_module_paths = [ "${puppet_path}/modules" ]

  $hiera_hierarchy     = [ '%{environment}', '%{hostname}', 'common' ]
  $hiera_backends      = {
    'json'   => $config_path,
    'puppet' => 'data',
  }
}
