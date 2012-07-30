
 Profiles
--------------------------------------------------------------------------------

In this context profiles refer to complete standalone server builds that inherit
from a base server configuration in the puppet-manifest-core.  These should
correspond to actual server images.

For example, we might want to split our database serverout from our web server.
In this case, we would have a web server enabled application image and a 
database image that would be spawned and load balanced.

We can build out these configurations into cloud server images which can be
easily spawned and managed.