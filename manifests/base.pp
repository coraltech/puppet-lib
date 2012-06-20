
class base {

  #-----------------------------------------------------------------------------
  # Basic systems

  include params
  include global_lib

  # - Time
  class { 'ntp': autoupdate => false }

  # - Security
  class { 'iptables': allow_icmp => $params::allow_icmp }
  class { 'ssh':
    port        => $params::ssh_port,
    user_groups => [ $params::admin_group, $params::git_group ],
  }
  class { 'sudo':
    permissions => [
      "%${params::admin_group} ALL=(ALL) NOPASSWD:ALL",
    ],
  }

  #-----------------------------------------------------------------------------
  # User environment

  class { 'users':
    editor => $params::admin_editor,
    umask  => $params::user_umask,
  }

  users::user { $params::admin_name:
    group      => $params::admin_group,
    alt_groups => [ $params::git_group ],
    email      => $params::admin_email,
    ssh_key    => $params::admin_ssh_key,
    key_type   => $params::admin_ssh_key_type,
  }

  class { 'locales':
    locales => [ $params::locale ],
  }

  #-----------------------------------------------------------------------------
  # Utilities

  class { 'puppet': module_paths => [ "${params::puppet_path}/modules" ] }

  class { 'git':
    user       => $params::git_user,
    home       => $params::git_home,
    group      => $params::git_group,
    ssh_key    => $params::admin_ssh_key,
    root_email => $params::git_root_email,
    skel_email => $params::git_skel_email,
  }

  git::repo { $params::puppet_repo:
    home     => $params::git_home,
    user     => $params::git_user,
    group    => $params::git_group,
    source   => $params::puppet_source,
    revision => $params::puppet_revision,
    base     => false,
  }
}
