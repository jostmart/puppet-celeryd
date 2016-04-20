# == Class: celery
#
# Full description of class celery here.
#
# === Parameters
#
# [*packages*]
#  Array of packages you want to install. Defaults to python-celery
#
#  Other parameters:
#  $service_name = 'celeryd',
#  $nodes        = $hostname,
#  $celery_bin   = '/usr/bin/celeryd',
#  $chdir        = '/opt/celery',
#  $opts         = '--time-limit=300',
#  $chdir_owner  = 'celery',
#  $chdir_group  = 'celery',
#  $ensure       = 'installed',
#
#
# === Examples
#
#  class { 'celery': }
#
# === Authors
#
# Author Name <jostmart>
#
#
class celery (
  $packages     = 'python-celery',
  $service_name = 'celeryd',
  $nodes        = $hostname,
  $celery_bin   = '/usr/bin/celeryd',
  $chdir        = '/opt/celery',
  $opts         = '--time-limit=300',
  $chdir_owner  = 'celery',
  $chdir_group  = 'celery',
  $ensure       = 'installed',
) {

  package { $packages:
    ensure => $ensure,
  }

  service { 'celeryd':
    ensure    => running,
    name      => $service_name,
    enable    => true,
    subscribe => File['celeryd'],
    require   => [Package[$packages], 
                  File["/etc/init.d/${service_name}"],
                  File["/etc/default/celeryd"]],
  }

  file { 'celeryd':
    name    => '/etc/default/celeryd',
    content => template('celery/celeryd.erb'),
  }

  file { 'celeryd-init':
    name    => "/etc/init.d/${service_name}",
    content => template('celery/celeryd-init.erb'),
    mode    => 0755,
  }

  file {
    $chdir:
      ensure => directory,
      owner  => $chdir_owner,
      group  => $chdir_group,
  }

}
