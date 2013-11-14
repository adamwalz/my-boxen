class people::adamwalz {

  $home     = "/Users/${::boxen_user}"
  $dotfiles = "${home}/.dotfiles"

  repository { $dotfiles:
    source  => 'adamwalz/dotfiles'
  }
}
