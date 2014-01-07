class people::adamwalz {

  $home       = "/Users/${::boxen_user}"
  $zprezto    = "${home}/.zprezto"
  $dotfiles   = "${boxen::config::srcdir}/setup/dotfiles"
  $ssh_config = "${home}/.ssh"

  notify{"The users home is: ${home}": }

  if $hostname !~ /.*Evernote.*/ {
    $email    = "adam@adamwalz.net"
  } else {
    $email    = "awalz@evernote.com"
  }

  repository {
    $zprezto:
      source => "adamwalz/prezto";
    $dotfiles:
      source => "adamwalz/dotfiles";
    $ssh_config:
      source => "adamwalz/SSH"
  }

  exec {
    "Pull dotfile updates":
      require => Repository[$dotfiles],
      command => "git pull --ff",
      cwd => $dotfiles;
    "Pull zprezto updates":
      require => Repository[$zprezto],
      command => "git pull --ff",
      cwd => $zprezto;
    "Pull SSH config updates":
      require => Repository[$ssh_config],
      command => "git pull --ff",
      cwd => $ssh_config
  }

  exec {
    "Symlink dotfiles":
      require => Exec["Pull dotfile updates"],
      command => "rake install",
      cwd => $dotfiles
  }

  # Projects
  if $hostname !~ /.*Evernote.*/ {
    include projects::adamwalz_net
  }

  # OS X Applications
  include alfred
  #include appzapper
  include bartender
  include crashplan
  include dropbox
  include eclipse::java
  include filezilla
  include flux
  include parallels::v8
  include sizeup
  include sourcetree
  include sublime_text_3
  include vlc
  if $hostname !~ /.*Evernote.*/ {
    include evernote
    include skitch
  }

  # OS X Preferences
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_autocorrect
  include osx::finder::unhide_library
  include osx::global::natural_mouse_scrolling
  osx::recovery_message { "If this Mac is found, please email $email": }
  class { 'osx::dock::icon_size':
    size => 64
  }

  # Git Settings
  git::config::global {
    'user.name':
      value => 'Adam Walz';
    'user.email':
      value => "awalz@evernote.com"
  }
  Git::Config::Global <| title == 'core.excludesfile' |> {
    value => "~/.gitignore"
  }

  # Ruby settings
  class { 'ruby::global' :
    version => '2.0.0-p353'
  }

  include sublime_text_3::package_control
  sublime_text_3::package {
    'Theme - Soda':
      source => 'buymeasoda/soda-theme'
  }
}
