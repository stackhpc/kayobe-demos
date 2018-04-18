#!/bin/bash

# Kayobe overcloud single host deployment demo.

set -e

source $(dirname ${BASH_SOURCE[0]})/functions

clear
announce Hello!
announce Today we\'re going to walk through installation of an all-in-one OpenStack controller using kayobe.
announce We\'re using the development environment provided with kayobe, which provisions a CentOS 7.4 VM using Vagrant.
announce We\'re roughly following the procedure in the development guide:
announce http://kayobe.readthedocs.io/en/latest/development/automated.html
pause

echo
announce First of all, clone the kayobe git repository and change to its directory.
pause
run git clone git@github.com:openstack/kayobe
# Copy the in-VM half of the demo to the Vagrant shared directory.
cp demo-in-vm.sh functions kayobe/
run cd kayobe

echo
announce Clone the development configuration repository, dev-kayobe-config.
announce The kayobe development environment expects a kayobe configuration repository to be checked out at config/src/kayobe-config.
pause
run mkdir -p config/src/
run git clone git@github.com:stackhpc/dev-kayobe-config config/src/kayobe-config

echo
announce Configure Docker to use a local registry to speed up image downloads.
announce This step is optional.
pause
fake_run echo "kolla_docker_registry: 192.168.33.1:5000" \>\> config/src/kayobe-config/etc/kayobe/kolla.yml
echo "kolla_docker_registry: 192.168.33.1:5000" >> config/src/kayobe-config/etc/kayobe/kolla.yml

echo
announce Bring up the Vagrant VM.
announce This can take some time as it includes installing kayobe and a few dependencies.
announce See dev/install.sh in kayobe for details.
pause
run vagrant up

# Install pv, as used in functions.
vagrant ssh -c "sudo yum -y install epel-release" >/dev/null 2>&1
vagrant ssh -c "sudo yum -y install pv" >/dev/null 2>&1

echo
announce SSH to the Vagrant VM.
announce From this point, all commands will be executed in the VM.
pause
fake_run vagrant ssh

vagrant ssh -c /vagrant/demo-in-vm.sh
