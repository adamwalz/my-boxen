class people::adamwalz {

  $email    = "adam@adamwalz.net"
  $home     = "/Users/${::boxen_user}"
  $dotfiles = "${home}/.dotfiles"

  repository { $dotfiles:
    source  => 'adamwalz/dotfiles'
  }

  # OS X Applications
  include dropbox

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
