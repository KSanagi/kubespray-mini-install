#/bin/bash
LANG=C
source config

./clean.sh
./create-net.sh

./create-vm.sh ${INST1}.$NET "${INST1_MAC}" 4096 &
sleep 10
./create-vm.sh ${NODE1}.$NET "${NODE1_MAC}" 4096 &
sleep 10
./create-vm.sh ${NODE2}.$NET "${NODE2_MAC}" 4096 &
sleep 10
./create-vm.sh ${NODE3}.$NET "${NODE3_MAC}" 4096 &
sleep 10

# checking if machines is boot up and ready to be sshed
for IP in $MACHINES_IP; do
  for i in `seq 20`; do
    echo "$IP checking...count=$i"
    ssh -q $IP "ls > /dev/null"
    if [[ $? -eq 0 ]]; then
      ssh $IP "systemctl disable firewalld; systemctl stop firewalld"
      break
    fi
    sleep 30
  done
done

scp init-installer.sh config $INST1_IP:/root
ssh $INST1_IP "/root/init-installer.sh | tee log-init-installer.txt"
