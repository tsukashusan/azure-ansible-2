#!/usr/bin/env sh

if [ ${#} -ne 3 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには3個の引数が必要です。" 1>&2
  exit 1
fi

# ヒアドキュメントでメッセージを表示する。
cat <<__EOT__
指定された引数は、
  インスタンス個数:${1}
  インスタンスプレフィックス:${2}
  ロケーション:${3}
の${#}個です。
__EOT__


yaml_path=$(cd $(dirname $0) && pwd)
randstr=`cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1`

resource_group=ks-${2}-${randstr}
vm_network_name=vnet-ks-${2}-${randstr}
vm_network_sub_name=vnet-ks-sub-${2}-${randstr}
security_group_name=seg-ks-${2}-${randstr}
location=${3}

/usr/local/bin/ansible-playbook --extra-vars "location=${location} resource_group=${resource_group}" ${yaml_path}/create_resource_group.yml
/usr/local/bin/ansible-playbook --extra-vars "resource_group=${resource_group} vm_network_name=${vm_network_name} network_addr_prefix=10.255.0.0/16 subnet_name=${vm_network_sub_name} network_subnet_addr_prefix=10.255.0.0/24 security_group_name=${security_group_name}" ${yaml_path}/create_network.yml

i=0
while [ ${i} -lt ${1} ]; do
    if [ ${i} -lt 1 ]; then
        echo "${i}"
        /usr/bin/nohup /usr/local/bin/ansible-playbook --extra-vars "no=-${i} host_group=cdh-hadoop nic_name=nic-centos73-${2}-${randstr} public_ip_name=public-ip-centos73-${2}-${randstr} vm_name=vm-centos73-${2}-${randstr} security_group_name=${security_group_name} storage_account_name=kos${2}${randstr}${i} vm_network_name=${vm_network_name} resource_group=${resource_group} subnet_name=${vm_network_sub_name} location=${location} vm_size=Standard_DS2_v2 storage_accout_type=Standard_LRS storage_kind=Storage domain_name_label=vm-centos73-${2}-${randstr}-${i}" ${yaml_path}/create_vm_ambari.yml -vvv > ${yaml_path}/nohup_std.out.${i} 2>&1 &
    else
        echo "${i}"
        /usr/bin/nohup /usr/local/bin/ansible-playbook --extra-vars "no=-${i} host_group=cdh-hadoop nic_name=nic-centos73-${2}-${randstr} public_ip_name=public-ip-centos73-${2}-${randstr} vm_name=vm-centos73-${2}-${randstr} security_group_name=${security_group_name} storage_account_name=kos${2}${randstr}${i} vm_network_name=${vm_network_name} resource_group=${resource_group} subnet_name=${vm_network_sub_name} location=${location} vm_size=Standard_DS2_v2 storage_accout_type=Standard_LRS storage_kind=Storage domain_name_label=vm-centos73-${2}-${randstr}-${i}" ${yaml_path}/create_vm_hadoop_datanode.yml -vvv > ${yaml_path}/nohup_std.out.${i} 2>&1 &
    fi
    i=`expr ${i} + 1`
done
