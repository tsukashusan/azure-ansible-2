#!/usr/bin/env sh

if [ ${#} -ne 6 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには6個の引数が必要です。" 1>&2
  exit 1
fi

# ヒアドキュメントでメッセージを表示する。
cat <<__EOT__
指定された引数は、
  resource_group:${1}
  vm_name_prefix:${2}
  vm_size:${3}
  vm no from :${4}
  vm no to :${5}
  allocated: ${6}
の${#}個です。
__EOT__


yaml_path=$(cd $(dirname $0) && pwd)
resource_group=${1}
vm_name_prefix=${2}
vm_size=${3}
allocated=${6}

i=${4}
max=`expr ${5} + 1`
while [ ${i} -lt ${max} ]; do
    vm_name="${vm_name_prefix}-${i}"
    echo ${resource_group}
    echo ${vm_name}
    echo ${vm_size}
    /usr/bin/nohup /usr/local/bin/ansible-playbook --extra-vars "resource_group=${resource_group} vm_name=${vm_name} vm_size=${vm_size} allocated=${allocated}" ${yaml_path}/stop_vm.yml -vvv > ${yaml_path}/nohup_stop_vm.out.${i} 2>&1 &

    i=`expr ${i} + 1`
done
