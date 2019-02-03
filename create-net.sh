#!/bin/bash

source config

HOSTS=($MACHINES)
IPS=($MACHINES_IP)
MACS=($MACHINES_MAC)

TMPFILE="virbr-${NET}.xml"
cat > $TMPFILE << EOS
<network connections='1'>
  <name>${NET}</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <mac address='${MAC_PREFIX}:01'/>
  <bridge name='virbr-${NET}' stp='on' delay='0'/>
  <domain name='${NET}' localOnly='yes'/>
  <ip address='${IP_PREFIX}.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='${IP_PREFIX}.100' end='${IP_PREFIX}.254'/>
EOS

for ((i = 0; i < ${#HOSTS[@]}; i++)) {
  echo "      <host mac='${MACS[i]}' name='${HOSTS[i]}' ip='${IPS[i]}'/>" >> $TMPFILE
}

cat >> $TMPFILE << EOS
    </dhcp>
  </ip>
</network>
EOS

virsh net-list --all --name | grep ^${NET}$
if [ $? -eq 0 ] ; then
  virsh net-destroy $NET
  virsh net-undefine $NET
fi
virsh net-define $TMPFILE
virsh net-start $NET
rm -f $TMPFILE 
