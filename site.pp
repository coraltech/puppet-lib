/**
 * Gateway manifest to all Puppet classes.
 *
 * Note: This is the only node in this system.  We use it to dynamically
 * bootstrap or load and manage classes (profiles).
 *
 * This should allow the server to configure it's own profiles in the future.
 */
node default {

  # This assumes the puppet-manifest-core has been added to the core directory.
  import "core/*.pp"
  include data::common

  if ! ( $::hiera_ready and exists($data::common::os_hiera_common_config) ) {
    notice "Bootstrapping server"
    notice "Push configurations to: git@${::ipaddress}:config.git"

    # We require Hiera and a valid configuration.
    include bootstrap
  }
  else {
    import "profiles/*.pp"

    include base

    $profiles = hiera('profiles', [])
    if ! empty($profiles) {
      hiera_include('profiles')
    }
  }
}
