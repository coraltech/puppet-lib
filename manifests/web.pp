
class web inherits base {

  #-----------------------------------------------------------------------------

  include params

  class { 'apache':
    http_port  => $params::http_port,
    https_port => $params::https_port,
  }

  include apache::dev

  a2mod { [
      'alias',
      'autoindex',
      'deflate',
      'env',
      'mime',
      'rewrite',
      'ssl',
      'vhost_alias',
    ]:
    ensure => 'present',
  }

  #-----------------------------------------------------------------------------

  web::firewall { [ $params::http_port, $params::https_port ]: }
}

#-------------------------------------------------------------------------------

define web::firewall ($port = $name) {
  if $port {
    firewall { "0500 INPUT Accept Apache connection: ${port}":
      action => 'accept',
      dport  => $port,
      proto  => 'tcp'
    }
  }
}
