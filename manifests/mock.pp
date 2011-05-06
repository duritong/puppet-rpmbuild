class rpmbuild::mock inherits rpmbuild {
  package {
    'mock' :
      ensure => installed
  }
  user::groups::manage_user {
    'mockbuild' :
      group => 'mock',
      require => [Package['mock'], User::Managed['mockbuild']],
  }
  require expect
  require rubygems::highline
  require rubygems::systemu

  file{
    '/home/mockbuild/.rpmmacros':
        source => [ "puppet:///modules/site-rpmbuild/mock/${fqdn}/rpmmacros",
                    "puppet:///modules/site-rpmbuild/mock/rpmmacros" ],
        require => User::Managed['mockbuild'],
        owner => mockbuild, group => mockbuild, mode => 0640;
    '/home/mockbuild/bin':
        ensure => directory,
        require => User::Managed['mockbuild'],
        owner => mockbuild, group => mockbuild, mode => 0640;
    '/home/mockbuild/bin/signrpm':
        source => "puppet:///modules/rpmbuild/scripts/signrpm",
        require => User::Managed['mockbuild'],
        owner => mockbuild, group => mockbuild, mode => 0700;
    '/home/mockbuild/.pbad.yml':
        source => [ "puppet:///modules/site-rpmbuild/mock/${fqdn}/pbad.yml",
                    "puppet:///modules/site-rpmbuild/mock/pbad.yml" ],
        require => [ User::Managed['mockbuild'], File['/home/mockbuild/bin/signrpm'] ],
        owner => mockbuild, group => mockbuild, mode => 0700;
    '/home/mockbuild/bin/pbad':
        source => "puppet:///modules/rpmbuild/scripts/pbad.rb",
        require => [ User::Managed['mockbuild'], File['/home/mockbuild/.pbad.yml'] ],
        owner => mockbuild, group => mockbuild, mode => 0700;
    '/home/mockbuild/bin/p2stable':
        source => "puppet:///modules/rpmbuild/scripts/p2stable.rb",
        require => [ User::Managed['mockbuild'], File['/home/mockbuild/bin/pbad'] ],
        owner => mockbuild, group => mockbuild, mode => 0700;
  }
}
