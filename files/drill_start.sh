#!/usr/bin/env sh

i=1
while [ ${i} -lt 4 ]; do
    /bin/ssh  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/centos/.ssh/beta -l centos vm-centos73-drill-accpt4vt-${i} sudo /opt/apache-drill-1.10.0/bin/drillbit.sh start
    i=`expr ${i} + 1`
done
