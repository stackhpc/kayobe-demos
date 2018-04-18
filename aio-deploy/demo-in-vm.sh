#!/bin/bash

set -e

source $(dirname ${BASH_SOURCE[0]})/functions

echo
announce The kayobe development environment provides a script, dev/overcloud-deploy.sh, to perform the control plane deployment.
announce We\'re going to run the commands manually for the purposes of this demo.
pause

echo
announce Source the kayobe development environment file.
announce This activates the virtual environment and sets some environment variables.
pause
run source /vagrant/dev/environment-setup.sh

echo
announce Bootstrap the ansible control host.
announce This installs kolla-ansible, sets up SSH keys, and downloads Ansible roles from Galaxy.
pause
run kayobe control host bootstrap

echo
announce Configuring the controller host.
announce This performs configuration of the network, OS, and services for control plane hosts.
pause
run kayobe overcloud host configure

echo
announce Pulling overcloud container images.
announce These images will be used to deploy containers to run the OpenStack services.
announce We\'re using a local docker registry, but could equally pull from a public registry such as Docker hub.
pause
run kayobe overcloud container image pull

echo
announce Deploying containerised overcloud services.
announce Kayobe uses kolla-ansible to deploy the OpenStack control plane services.
pause
run kayobe overcloud service deploy

echo
announce Source the admin OpenStack credentials file generated by kolla-ansible.
pause
run source /vagrant/config/src/kayobe-config/etc/kolla/admin-openrc.sh

announce Performing post-deployment configuration.
announce This registers various resources with OpenStack, particularly to support bare metal compute nodes.
pause
run kayobe overcloud post configure

echo
announce Control plane deployment complete\!
announce OpenStack is now running in Docker containers:
pause
run sudo docker ps

echo
announce Now lets create some OpenStack resources.
announce For this we require an openstack client.
pause
run sudo pip install python-openstackclient

echo
announce Kolla-ansible provides a demo script that creates some standard OpenStack resources.
announce This includes flavors, an image, networks, subnets, an SSH key, and more.
pause
run /home/vagrant/kolla-venv/share/kolla-ansible/init-runonce

echo
announce Let\'s create a VM using nova.
announce We\'ll use the cirros image, m1.tiny flavor, demo-net VXLAN network, and the mykey SSH key.
pause
run openstack server create --wait --image cirros --flavor m1.tiny --network demo-net --key-name mykey demo1

echo
announce It worked, hooray!
announce Hopefully this demo has been instructive.
announce For further information, consult the kayobe documentation:
announce https://kayobe.readthedocs.io
announce Or join us in IRC:
announce \#openstack-kayobe
pause
