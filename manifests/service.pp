# == Class: postfix::service
#
# === Parameters
# [*status*]
#   Whether to be present
# === Variables
#
# === Examples
#
#  class { postfix::service:
#    status => 'present'
#  }
#
# === Authors
#
# Jonathan Shanks <jon.shanks@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jon shanks
#

class postfix::service($status = '')
{

  $ensure = $status ? {
    present  => 'running',
    absent   => 'stopped',
  }

  service { 'postfix':
    ensure => $ensure
  }

}
