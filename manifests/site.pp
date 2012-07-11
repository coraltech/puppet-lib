/**
 * Gateway manifest to all Puppet classes.
 *
 * Note: This is the only node in this system.  We use it to dynamically
 * bootstrap or load and manage classes (profiles).
 *
 * This should allow the server to configure it's own profiles in the future.
 */
node default {

  import "core/*.pp"
  include config::common

  $common_config = $::hiera_ready ? {
    true    => hiera('hiera_common_config'),
    default => $config::common::hiera_common_config,
  }
  notice "Hiera ready: ${::hiera_ready}"
  notice "Common configuration file: ${common_config}"

  if ! $::hiera_ready or ! exists($common_config) {
    notice "Bootstrapping server"

    # We require Hiera and a valid configuration.
    include bootstrap
  }
  else {
    import "capabilities/*.pp"
    import "profiles/*.pp"

    include base
    hiera_include('profiles')
  }
}
