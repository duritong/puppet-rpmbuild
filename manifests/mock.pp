class rpmbuild::mock inherits rpmbuild {

    package{'mock': ensure => installed }

    user::groups::manage_user{'mockbuild':
        group => 'mock',
        require => [ Package['mock'], User::Managed['mockbuild'] ],
    }
}
