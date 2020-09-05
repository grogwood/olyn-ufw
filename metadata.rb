name 'olyn_ufw'
maintainer 'Scott Richardson'
maintainer_email 'dev@grogwood.com'
chef_version '~> 16'
license 'GPL-3.0'
supports 'debian', '>= 10'
source_url 'https://gitlab.com/olyn/olyn_ufw'
description 'Installs and configures UFW with rules from the ports databag'
version '1.0.1'

provides 'olyn_ufw::default'
recipe 'olyn_ufw::default', 'Installs and configures UFW with rules from the ports databag'

depends 'ufw', '~> 3'
