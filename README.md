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

## Local Config

Create a file called config.sh in the top level directory.
Put in changes there to change the behavior of .port.sh script.
For instance, prefix=/usr/local
