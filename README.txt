#-------------------------------------------------------------------------------
# Installation

1. Create new cloud server instance.  Note the public IP and root password.
2. SSH into the new cloud server instance as root.

#
# On server (only tested so far with Ubuntu 12.04 LTS)
#
# Wrap steps 3 - 8 into cloud images which can be created more efficiently on 
# demand. 
#

3.> apt-get update
4.> apt-get install git puppet -y
5.> git clone git://github.com/coraltech/puppet-panopoly-lib.git puppet-lib
6.> cd puppet-lib
7.> git submodule update --init --recursive
8.> puppet apply --modulepath=core/modules site.pp

#
# Run the following commands anywhere for each new server instance from the 
# image created above
#
# A single configuration repository can power an unlimited number of servers.
# Since we use Hiera we can override general configurations based on factors
# such as environment (dev, staging, qa, prod), location (data centers), and
# individual hostname of the server.  We can even define new file separations 
# as needed.
#

9. > git clone git://github.com/coraltech/puppet-panopoly-config.git puppet-config
10. > cd puppet-config
11. > Edit common.json and add your settings.  Replace all values wrapped in < >.
12.> git add .
13.> git commit -m "Locking in my configurations."
14.> git remote add hostname git@host-ip:config.git
15.> git push hostname master

# Done.


