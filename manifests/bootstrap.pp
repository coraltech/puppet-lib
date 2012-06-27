
class bootstrap {

  include config
  include git

  #-----------------------------------------------------------------------------

  class { 'puppet':
    module_paths    => $config::puppet_module_paths,
    hiera_hierarchy => $config::hiera_hierarchy,
    hiera_backends  => $config::hiera_backends,
  }

  git::repo { $config::config_repo:
    home => $config::git_home,
    base => false,
  }
}
