# DKAN2 Installation Script

This script takes out some of the hassle when installing DKAN2.

It performs the following functions:
- installs Docker and Docker Composer
- installs dktl
- stark Docker Containers

There are some things you will need to do:

Open up /etc/hosts, `vim /etc/hosts`. You will see something like:
```
127.0.0.1	localhost
127.0.1.1	nathan-OptiPlex-9020

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

```
You will need to add `127.0.0.{x}   dkan` to the file, like so:
```
127.0.0.1	localhost
127.0.1.1	nathan-OptiPlex-9020
127.0.0.2   dkan

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```
`{x}` can be any value (between 0 and 255), so long as the ip does not conflict.

Make sure that nothing is running on port 80, 32781, 32780, 32779, 32776, 32775