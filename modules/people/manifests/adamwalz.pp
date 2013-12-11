class people::adamwalz {

  $email      = "adam@adamwalz.net"
  $home       = "/Users/${::boxen_user}"
  $zprezto    = "${home}/.zprezto"
  $dotfiles   = "${boxen::config::srcdir}/setup/dotfiles"
  $ssh_config = "${home}/.ssh"

  repository {
    $zprezto:
      source => "#{::boxen_user}/prezto";
    $dotfiles:
      source => "#{::boxen_user}/dotfiles";
    $ssh_config:
      source => "#{::boxen_user}/SSH"
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
  include projects::adamwalz_net

  # OS X Applications
  include alfred
  #include appzapper
  include bartender
  include crashplan
  include dropbox
  include evernote
  include filezilla
  include flux
  include parallels::v8
  include skitch
  include sizeup
  include sourcetree
  include sublime_text_3
  include vlc

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
      value => $email;
  }
  Git::Config::Global <| title == 'core.excludesfile' |> {
    value => "$home/.gitignore"
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
