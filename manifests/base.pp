class rpmbuild::base {
    include gcc

    package{ ['rpm-build', 'rpmdevtools', 'rpmlint']:
        ensure => present,
    }

    user::managed{'mockbuild': }
}
