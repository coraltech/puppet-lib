
class base {

  include config
  include global_lib

  #-----------------------------------------------------------------------------

  $allow_icmp         = hiera('allow_icmp')
  $ssh_port           = hiera('ssh_port')
  $locale             = hiera('locale')
  $user_umask         = hiera('user_umask')

  $admin_name         = hiera('admin_name')
  $admin_group        = hiera('admin_group')
  $admin_email        = hiera('admin_email')
  $admin_ssh_key      = hiera('admin_ssh_key')
  $admin_ssh_key_type = hiera('admin_ssh_key_type')
  $admin_editor       = hiera('admin_editor')

  $git_user           = hiera('git_user')
  $git_group          = hiera('git_group')
  $git_root_email     = hiera('git_root_email')
  $git_skel_email     = hiera('git_skel_email')

  $puppet_source      = hiera('puppet_source')
  $puppet_revision    = hiera('puppet_revision')

  #-----------------------------------------------------------------------------
  # Basic systems

  # - Time
  class { 'ntp': autoupdate => false }

  # - Security
  class { 'iptables': allow_icmp => $allow_icmp }
  class { 'ssh':
    port        => $ssh_port,
    user_groups => [ $admin_group, $git_group ],
  }
  class { 'sudo':
    permissions => [
      "%${admin_group} ALL=(ALL) NOPASSWD:ALL",
    ],
  }

  #-----------------------------------------------------------------------------
  # User environment

  class { 'users':
    editor => $admin_editor,
    umask  => $user_umask,
  }

  users::user { $admin_name:
    group      => $admin_group,
    alt_groups => [ $git_group ],
    email      => $admin_email,
    ssh_key    => $admin_ssh_key,
    key_type   => $admin_ssh_key_type,
  }

  class { 'locales':
    locales => [ $locale ],
  }

  #-----------------------------------------------------------------------------
  # Utilities

  class { 'puppet':
    module_paths    => $config::puppet_module_paths,
    hiera_hierarchy => $config::hiera_hierarchy,
    hiera_backends  => $config::hiera_backends,
  }

  class { 'git':
    home       => $config::git_home,
    user       => $git_user,
    group      => $git_group,
    ssh_key    => $admin_ssh_key,
    root_email => $git_root_email,
    skel_email => $git_skel_email,
  }

  git::repo { $config::puppet_repo:
    home     => $config::git_home,
    user     => $git_user,
    group    => $git_group,
    source   => $puppet_source,
    revision => $puppet_revision,
    base     => false,
  }

  git::repo { $config::config_repo:
    home     => $config::git_home,
    user     => $git_user,
    group    => $git_group,
    base     => false,
  }
}
