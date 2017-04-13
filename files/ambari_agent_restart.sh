#!/usr/bin/env sh

i=4
while [ ${i} -lt 13 ]; do
    /bin/ssh  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/centos/.ssh/beta -l centos 10.255.0.${i} sudo systemctl status ambari-agent
    i=`expr ${i} + 1`
done
