#-------------------------------------------------------------------------------
# Installation

1. Create new cloud server instance.  Note the public IP and root password.
2. SSH into the new cloud server instance as root.

#
# On server (only tested so far with Ubuntu 12.04 LTS)
#
# Wrap steps 3 - 6 into cloud images which can be created more efficiently on 
# demand. 
#

3.> apt-get update
4.> apt-get install puppet -y
5.> git clone git://github.com/coraltech/puppet-lib.git puppet-lib
6.> puppet apply --modulepath=puppet-lib/modules puppet-lib/manifests/site.pp

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

7. > git clone git://github.com/coraltech/puppet-config.git puppet-config
8. > cd puppet-config
9. > Edit common.json and add your settings.  Replace all values wrapped in < >.
10.> git add .
12.> git commit -m "Locking in my configurations."
13.> git remote add hostname git@host-ip:config.git
14.> git push hostname master

# Done.


