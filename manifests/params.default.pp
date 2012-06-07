
class params_default {

  #-----------------------------------------------------------------------------
  # To use:
  #
  # 1. Copy this file to "manifests/params.pp"
  # 2. Rename this class to "params".
  # 3. Fill in your values, particularly any values with a <VALUE> format below.

  $locale         = 'en_US.UTF-8 UTF-8'

  $ssh_port       = 22
  $allow_icmp     = true

  $user_umask     = 002

  $admin_name     = 'admin'
  $admin_group    = $admin_name
  $admin_editor   = 'vim'
  $admin_email    = ''

  $ssh_key        = '<PUBLIC KEY HERE>'
  $ssh_key_type   = 'rsa'

  $git_user       = 'git'
  $git_group      = 'git'
  $git_home       = '/var/git'
  $git_root_email = '<ROOT EMAIL HERE>'
  $git_skel_email = '<DEFAULT USER EMAIL HERE>'

  $puppet_repo    = 'puppet.git'
  $puppet_path    = "${git_home}/${puppet_repo}"
  $puppet_source  = 'git://github.com/coraltech/puppet_lib.git'

  $http_port      = 80
  $https_port     = 443
}
