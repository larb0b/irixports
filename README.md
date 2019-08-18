# irixports

Simple ports system for IRIX that's designed to be able to run on a fresh install. 

## Bootstrapping

If you've never used irixports on the system, run bootstrap.sh as root to bootstrap some necessary tools.

## Installing a port

Run the script inside of the port's folder! 

## Arguments

You can run the steps of port scripts one at a time:  
`fetch`, `configure`, `build`, `install`.

The port scripts have cleaning functionality:  
`clean`, `clean_dist`, `clean_all`.

There is also early support for uninstalling:  
`uninstall`.

## Local config

You can create a file in the top level directory called `config.sh`. This can change some default variables, such as $prefix, without getting in the way of keeping up with upstream. 
