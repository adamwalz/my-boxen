class projects::adamwalz_net {

  boxen::project { 'adamwalz_net':
    dotenv  => true,
    source  => 'adamwalz/adamwalz.net',
    ruby    => '2.0.0-p353'
  }
}
