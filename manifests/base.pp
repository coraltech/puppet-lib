
node default {

  include params

  #-----------------------------------------------------------------------------

  class { 'global_lib': }
  class { 'puppet': module_paths => [ "${params::puppet_path}/modules" ] }

  class { 'ntp': autoupdate => false }
  class { 'locales':
    locales => [ $params::locale ],
  }

  class { 'iptables': allow_icmp => $params::allow_icmp }

  #---

  class { 'ssh': port => $params::ssh_port, user_groups => [ $params::admin_group, 'git' ] }
  class { 'sudo': permissions => [
    "%${params::admin_group} ALL=(ALL) ALL",
  ] }

  class { 'users':
    user_names  => [ $params::admin_name ],
    user_groups => [ $params::admin_group ],
    key         => $params::key,
    email       => $params::admin_email,
    editor      => $params::admin_editor,
    umask       => $params::user_umask,
    init        => true,
  }

  #---

  class { 'git':
    git_home   => $params::git_home,
    git_groups => [ 'git', $params::admin_group ],
    key        => $params::key,
    root_email => $params::git_root_email,
    skel_email => $params::git_skel_email,
  }

  git::repo { $params::puppet_repo:
    git_home => $params::git_home,
  }
}
