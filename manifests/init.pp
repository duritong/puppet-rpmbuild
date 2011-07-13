class rpmbuild {
    include gcc

    package{ ['rpm-build', 'rpmdevtools', 'rpmlint', 'repoview' ]:
        ensure => present,
    }

    user::managed{'mockbuild': }
}
