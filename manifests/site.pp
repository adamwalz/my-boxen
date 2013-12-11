require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions (possible include v_4 v_6 v_8 v_10)
  include nodejs::v0_10

  # default ruby versions (possible include 1_8_7 1_9_2 1_9_3 2_0_0)
  include ruby::2_0_0

  # OS X Applications
  include iterm2::stable
  include chrome

  # OS X Settings
  include osx::global::enable_keyboard_control_access
  include osx::universal_access::ctrl_mod_zoom
  include osx::no_network_dsstores
  include osx::software_update

  # common, useful packages
  package {
    [
      'ack',
      'coreutils',
      'emacs',
      'fasd',
      'findutils',
      'gfortran',
      'gnu-tar',
      'mobile-shell',
      'pianobar',
      'reattach-to-user-namespace',
      'trash',
      'tree',
      'tmux',
      'zeromq',
      'zsh'
    ]:
  }

  file { "${boxen::config::srcdir}/setup/my-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
