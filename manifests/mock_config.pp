define rpmbuild::mock_config(){
  require rpmbuild::mock
  file{"/etc/mock/${name}.cfg":
    source => [ "puppet://$server/modules/site-rpmbuild/mock/${fqdn}/${name}.cfg",
                "puppet://$server/modules/site-rpmbuild/mock/${name}.cfg",
                "puppet://$server/modules/rpmbuild/mock/${name}.cfg" ],
    owner => root, group => 0, mode => 0644;
  }
}
