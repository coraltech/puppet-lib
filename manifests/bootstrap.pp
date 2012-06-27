
class bootstrap {

  include config::common
  include users

  #-----------------------------------------------------------------------------

  class { 'puppet':
    module_paths    => $config::common::puppet_module_paths,
    hiera_hierarchy => $config::common::hiera_hierarchy,
    hiera_backends  => $config::common::hiera_backends,
  }

  class { 'git':
    home  => $config::common::git_home,
    user  => $config::common::git_user,
    group => $config::common::git_group,
  }

  git::repo { $config::common::puppet_repo:
    home     => $config::common::git_home,
    user     => $config::common::git_user,
    group    => $config::common::git_group,
    source   => $config::common::puppet_source,
    revision => $config::common::puppet_revision,
    base     => false,
  }

  git::repo { $config::common::config_repo:
    home     => $config::common::git_home,
    user     => $config::common::git_user,
    group    => $config::common::git_group,
    base     => false,
  }
}
