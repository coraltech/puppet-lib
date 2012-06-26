
node bootstrap {

  include config

  #-----------------------------------------------------------------------------

  class { 'puppet':
    module_paths    => $config::puppet_module_paths,
    hiera_hierarchy => $config::hiera_hierarchy,
    hiera_backends  => $config::hiera_backends,
  }
}
