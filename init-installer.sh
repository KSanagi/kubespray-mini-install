#!/bin/bash

source /root/config

yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yum -y install git python36u python36u-pip
git clone https://github.com/kubernetes-incubator/kubespray
cd kubespray
pip3.6 install -r requirements.txt
cp -r inventory/sample inventory/mycluster
declare -a IPS=($NODE1_IP $NODE2_IP $NODE3_IP)
CONFIG_FILE=inventory/mycluster/hosts.ini python3.6 contrib/inventory_builder/inventory.py ${IPS[@]}
ansible-playbook -i inventory/mycluster/hosts.ini cluster.yml
