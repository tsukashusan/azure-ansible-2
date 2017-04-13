#!/usr/bin/env sh

if [ ${#} -ne 3 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには3個の引数が必要です。" 1>&2
  echo "第一引数:ワーカーノード数 第二引数:インスタンスプレフィックス 第三引数:ロケーション"
  exit 1
fi

# ヒアドキュメントでメッセージを表示する。
cat <<__EOT__
指定された引数は、
  ワーカーノード個数:${1}
  インスタンスプレフィックス:${2}
  ロケーション:${3}
の${#}個です。
__EOT__


yaml_path=$(cd $(dirname $0) && pwd)
randstr=`cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1`

resource_group=sea-${2}-${randstr}
vm_network_name=vnet-sea-${2}-${randstr}
vm_network_sub_name=vnet-sea-sub-${2}-${randstr}
security_group_name=seg-sea-${2}-${randstr}
location=${3}
key="smsppdu1234"
cluster_name="hdcls${2}${randstr}"
default_storage_account="storage${2}${randstr}"

/usr/local/bin/ansible-playbook --extra-vars "location=${location} resource_group=${resource_group}" \
${yaml_path}/create_resource_group.yml

/usr/local/bin/ansible-playbook --extra-vars "resource_group=${resource_group} vm_network_name=${vm_network_name} network_addr_prefix=10.255.0.0/16 subnet_name=${vm_network_sub_name} network_subnet_addr_prefix=10.255.0.0/24 security_group_name=${security_group_name}" ${yaml_path}/create_network.yml

/usr/local/bin/ansible-playbook --extra-vars "resource_group=${resource_group} storage_account_name=${default_storage_account} storage_accout_type=Standard_LRS storage_kind=Storage" ${yaml_path}/create_storage.yml

#/usr/local/bin/azure storage account create -g ${resource_group} --sku-name RAGRS -l ${location} --kind Storage ${default_storage_account}

storage_account_key=`/usr/local/bin/azure storage account keys list -g ${resource_group} ${default_storage_account} --json|/usr/bin/jq .[0].value|/bin/sed -e 's/^\"\|\"$//g'`
echo "storage_account_key=${storage_account_key}"
i=0
max=`expr ${1} + 2`
storage_account=""
while [ ${i} -lt ${max} ]; do
    if [ ${i} -eq 0 ]; then 
        storage_account="${2}${randstr}${i}#${key}"
    else
        storage_account="${storage_account};${2}${randstr}${i}#${key}"
    fi

    i=`expr ${i} + 1`
done
#echo ${storage_account}

/usr/local/bin/azure hdinsight cluster create \
-g "${resource_group}" \
-l ${location} \
-y Linux \
--clusterType Hadoop \
--defaultStorageAccountName "${default_storage_account}.blob.core.windows.net" \
--defaultStorageAccountKey "${storage_account_key}" \
--defaultStorageContainer "${cluster_name}" \
--workerNodeCount ${1} \
--userName admin \
--password 1qaz@wsx3edC \
--sshUserName sshuser \
--sshPublicKey  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDObU/peixf8A5zuF7+C9QuXa6iO60R+R/6OOrZfLpNRKsfmEtqhHPaTHwWT21Q2Z1DfVTskmSvPnBcD+LHgWGQwtjw9Q/gE/cfbTq/y3M+KGDyPubvXletQvV5SDwCT1uCaUx+cNE4ege+t9as1Vh5PR41Ajd/QUBLZrFh4E6FbdfIU5qXnZ3/qP5D4HSlI+V67XYrdohghdn7EaV77dxsMRtOGJKfEEUope5JkkBXZX87ofMy4rbvgMEUmDtLWZlxF2eP3ZDcjHcLqwMndBk/mTlVF2/vB340mNMFlE1XM0d/05c2NnUqJ3D98zK5zqBs09vHLR27RLkhiLrihT1x" \
--sshPassword "1qaz@wsx3edC" \
--virtualNetworkId "/subscriptions/dc5d3c89-36dd-4a3c-b09b-e6ee41f6d5b5/resourceGroups/${resource_group}/providers/Microsoft.Network/virtualNetworks/${vm_network_name}" \
--subnetName "/subscriptions/dc5d3c89-36dd-4a3c-b09b-e6ee41f6d5b5/resourceGroups/${resource_group}/providers/Microsoft.Network/virtualNetworks/${vm_network_name}/subnets/${vm_network_sub_name}" \
${cluster_name}
