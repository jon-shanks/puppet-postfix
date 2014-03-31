# == Class: postfix::files
#
#
# [*status*]
#   Whether to ensure files are present or absent
# [*relay*]
#   Whether the server is acting as a relay
# [*smtpd_banner*]
#   The smtpd banner to display when connections come inbound
# [*biff*]
#   Whether or not to use the local biff service. This service sends "new mail" notifications to users who have requested new mail notifications.
# [*relayhost*]
#   The host that email is being sent to if it's not managing itself or through a smarthost
# [*local_mx*]
#   if it's a relay what are the local mx records to send mail through to internally
# [*smarthost*]
#   used to define the smarthost to send mail through usually this is all mail that isn't managed internally
# [*transport_maps*]
#   Optional lookup tables with mappings from recipient address to (message delivery transport, next-hop destination)
# [*local_recipient_maps*]
#   local_recipient_maps setting needs to specify a database that lists all the known user names or addresses for that delivery agent (virtual mailbox maps)
# [*local_transport*]
#   Specify a string of the form transport:nexthop, where transport is the name of a mail delivery transport defined in master.cf
# [*relay_domains*]
#   These are the domains to allow mail to relay through
# [*mynetworks*]
#   These are the networks to allow mail to relay through
# [*queue_life*]
#   Maximum queue life
# [*root_email*]
#   The root email address to send mail through to in the aliases
# [*smtpd_tls*]
#   Smtpd tls authentication options for authenticating clients
# [*smtp_tls*]
#   A hash containing the key value settings for the smtp_tls configuration
#     postfix::smtp_tls:
#       smtp_tls_security_level: 'may'
#       smtp_tls_policy_maps: 'hash:/etc/postfix/tls_policy'
#       smtp_tls_fingerprint_digest: 'md5
# [*smtp_tls_policy*]
#   Array data of policy types per domain
#
# === Variables
#
# === Examples
#
#  class { postfix::files: 
#  }
#
# === Authors
#
# Jonathan Shanks <jon.shanks@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jon Shanks
#
class postfix::files( $relay                = false,
                      $relayhost            = '',
                      $smtpd_banner         = false,
                      $biff                 = false,
                      $local_mx             = '',
                      $queue_life           = false,
                      $smarthost            = false,
                      $transport_maps       = false,
                      $local_recipient_maps = false,
                      $local_transport      = false,
                      $relay_domains        = [],
                      $mynetworks           = [],
                      $root_email           = false,  
                      $status               = '',
                      $smtpd_tls            = false,
                      $smtp_tls             = false, 
                      $smtp_tls_policy      = false, )
{

  File { mode => '0644', owner => 'root', group => 'root' }

  if $relay {
    if $transport_maps {
      file { '/etc/postfix/transport':
        ensure  => $status,
        content => template('postfix/transport.erb'),
      }

      exec { '/usr/sbin/postmap /etc/postfix/transport':
        refreshonly => true,
        subscribe   => File['/etc/postfix/transport'],
      }
    }

    file { '/etc/aliases':
      ensure  => $status,
      content => template('postfix/aliases.erb'),
    }

    exec { '/usr/bin/newaliases':
      subscribe     => File['/etc/aliases'],
      refreshonly   => true,
    }
  
    if $smtp_tls and $smtp_tls_policy {
      file { '/etc/postfix/tls_policy':
        ensure  => $status,
        content => inline_template('<% @smtp_tls_policy.each do |policy| %><%= policy %><% end %>'),
      }

      exec { '/usr/sbin/postmap /etc/postfix/tls_policy':
        refreshonly => true,
        subscribe   => File['/etc/postfix/tls_policy'],
      }
    }

  } else {
    file { ['/etc/postfix/transport', '/etc/aliases']:
      ensure => absent,
    }
  }

  file { '/etc/postfix/main.cf':
    ensure  => $status, 
    content => template('postfix/main.cf.erb'),
  }

}
