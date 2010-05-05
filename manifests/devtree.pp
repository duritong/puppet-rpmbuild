define rpmbuild::devtree(){
  require ::rpmbuild
  exec{"rpmbuild_devtree_for_${name}":
    command => '/usr/bin/rpmdev-setuptree',
    user => $name,
    unless => "test -d /home/${name}/rpmbuild",
  }
}
