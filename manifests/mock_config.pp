define rpmbuild::mock_config(){
  require rpmbuild::mock
  file{"/etc/mock/${name}.cfg":
    source => [ "puppet:///modules/site-rpmbuild/mock/${fqdn}/${name}.cfg",
                "puppet:///modules/site-rpmbuild/mock/${name}.cfg",
                "puppet:///modules/rpmbuild/mock/${name}.cfg" ],
    owner => root, group => 0, mode => 0644;
  }
}
