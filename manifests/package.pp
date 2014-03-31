# == Class: postfix::package
#
# === Parameters
# [*package*]
#   The package responsible for postfix this can be an array
# [*status*]
#   Whether to be present, (installed) or absent (removed)
# === Variables
#
# === Examples
#
#  class { postfix::package:
#    package => 'postfix'
#  }
#
# === Authors
#
# Jonathan Shanks <jon.shanks@gmail.com>
#
# === Copyright
#
# Copyright 2013 NYSE EURONEXT
#

class postfix::package( $package = {},
                        $status = '', )
{

  package { $package:
    ensure => $status
  }

}
