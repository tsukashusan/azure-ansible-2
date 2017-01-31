# azure-ansible-2

あらかじめ「リソース グループ」と「ストレージアカウント」は作成しておいてください。
以下がサンプルの該当項目になります。

リソースグループ:southeastasia-resource-test1
ストレージアカウント:southeastasiacentos

# ネットワーク構築用 コマンドサンプル

>ansible-playbook --extra-vars "resource_group=southeastasia-resource-test1 vm_net_name=vmnet-southeastasia network_addr_prefix=10.255.0.0/16 subnet_name=vnet-sub-southeastasia network_subnet_addr_prefix=10.255.0.0/24 security_group_name=southeastasia_seg" create_network.yml

# Virtual Machine構築コマンドサンプル
>ansible-playbook --extra-vars "no=-54 host_group=cdh-hadoop nic_name=nic-centos73 public_ip_name=public-ip-centos73 vm_name=vm-centos73 security_group_name=southeastasia_seg storage_account_name=southeastasiacentos vm_network_name=vmnet-southeastasia resource_group=southeastasia-resource-test1 vm_net_name=vmnet-southeastasia subnet_name=vnet-sub-southeastasia" create_vm.yml
