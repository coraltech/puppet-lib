
 Capabilities
--------------------------------------------------------------------------------

In this context capabilities refer to cohesive systems built from included
Puppet modules that are configured through Hiera.  These systems should be 
generic enough to be applicable in multiple use cases.

For example, we might have a PHP application that requires a MySQL server.  For
this we need various systems set up; PHP language, possibly Apache web server, 
and a MySQL server.

We could have three capabilities (configured through Hiera)

1. PHP language, libraries, and configurations (php_application.pp)
2. MySQL server and configurations (mysql_server.pp)
3. Apache web server (apache_server.pp)

So we are "capable" of running PHP applications through Apache with a MySQL
backend.  This does not specify which applications or virtual hosts and it does
not create databases or database users.  Capabilities mostly connect Hiera 
configurations with the included modules.

Specialized complete server puppet builds are placed in the "profiles" directory
and included through dynamic Hiera configurations.  
