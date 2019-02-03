#!/bin/bash

source config

virsh net-list --all --name | grep ^${NET}$
if [ $? -eq 0 ] ; then
  virsh net-destroy $NET
  virsh net-undefine $NET
fi

for VM in $MACHINES; do
  virsh list --all --name | grep "^${VM}\.${NET}"
  if [ $? -eq 0 ] ; then
    virsh destroy ${VM}.${NET}
    virsh undefine --remove-all-storage ${VM}.${NET}
  fi
done
