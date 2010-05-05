class rpmbuild {
    include gcc

    package{ ['rpm-build', 'rpmdevtools', 'rpmlint']:
        ensure => present,
    }

    user::managed{'mockbuild': }
}
