#
# rpmbuild module
#
# Copyright 2008, Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

# modules_dir { \"rpmbuild\": }

class rpmbuild {
    include rpmbuild::base
}

class rpmbuild::base {
    package{'rpmbuild':
        ensure => present,
    }
    service{rpmbuild:
        ensure => running,
        enable => true,
        hasstatus => true,
        require => Package[rpmbuild],
    }
}
