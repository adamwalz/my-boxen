class people::adamwalz {

  $email      = "adam@adamwalz.net"
  $home       = "/Users/${::boxen_user}"
  $zprezto    = "${home}/.zprezto"
  $dotfiles   = "${home}/.dotfiles"
  $ssh_config = "${home}/.ssh"

  repository { $zprezto:
    source => 'adamwalz/prezto',
  }

  repository { $dotfiles:
    source  => 'adamwalz/dotfiles'
  }

  exec { "Symlink dotfiles":
    require => Repository[$dotfiles],
    command => "rake install",
    cwd => $dotfiles
  }

  repository { $ssh_config:
    source => 'adamwalz/SSH'
  }

  # OS X Applications
  include alfred
  include dropbox
  include evernote
  include flux
  include skitch
  include sizeup
  include sourcetree
  include watts

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

}
