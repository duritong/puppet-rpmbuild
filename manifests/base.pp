class rpmbuild::base {
    include gcc

    package{'rpm-build':
        ensure => present,
    }

    user::managed{'mockbuild': }
}
