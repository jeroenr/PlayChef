name             'deplay'
maintainer       'Jeroen Rosenberg'
maintainer_email 'jeroen.rosenberg@gmail.com'
license          'Apache 2.0'
description      'Deploys Play Application'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'zip'
depends 'java'

supports 'debian'
supports 'ubuntu'
supports 'centos'
supports 'redhat'

recipe 'deplay::default', 'Deploys Play Application on your Node'
