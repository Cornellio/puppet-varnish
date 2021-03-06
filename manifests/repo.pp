class varnish::repo(
  $ensure  = 'present',
  $source  = $::osfamily ? {
    'Debian' => 'varnish-cache',
    'RedHat' => 'varnish-cache',
  },
) {
  if defined(Class['varnish::install']) {
    Class['varnish::repo'] -> Class['varnish::install']
  }

  case $::osfamily {
    'Debian': {
      case $source {
        'distro': {
        }
        'varnish-cache': {
          include ::apt
          apt::source { 'varnish':
            ensure     => $ensure,
            location   => 'http://repo.varnish-cache.org/debian',
            repos      => 'varnish-4.0',
            key        => 'C4DEFFEB',
            key_source => 'http://repo.varnish-cache.org/debian/GPG-key.txt',
          }
        }
        default: {
          fail 'Repository source must be one of "distro" or "varnish-cache"'
        }
      }
    }
    'Redhat': {
      yumrepo {'epel':
        descr    => "Extra Packages for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl  => "http://download.fedoraproject.org/pub/epel/${::operatingsystemmajrelease}/\$basearch",
        enabled  => 1,
        gpgkey   => "http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-${::operatingsystemmajrelease}",
        gpgcheck => 1,
      }
      case $source {
        'epel': {
        }
        'varnish-cache': {
          yumrepo { 'varnish':
            ensure   => $ensure,
            descr    => 'varnish',
            baseurl  => "http://repo.varnish-cache.org/redhat/varnish-4.0/el${::operatingsystemmajrelease}/\$basearch",
            enabled  => '1',
            gpgcheck => '1',
            gpgkey   => 'http://repo.varnish-cache.org/debian/GPG-key.txt',
          }
        }
        default: {
          fail 'Repository source must be one of "epel" or "varnish-cache"'
        }
      }
    }
    default: {
      fail "Unsupported Operating System family: ${::osfamily}"
    }
  }
}
