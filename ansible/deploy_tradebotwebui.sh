#!/bin/bash
#Use this script to trigger ansible deployment of tradebot webui application
#Assumes azure cli is installed and authenticated
export ansible_hosts_file=azure-ansible-hosts
export tradebot_resource_group=tradebotRG-dev
export tradebot_vmss=tradebotwebuivmss-dev

az vmss list-instance-public-ips -g $tradebot_resource_group -n $tradebot_vmss | grep \"ipAddress\"\: > azure_ip_addr.txt
#az vm list-ip-addresses -g tradebotresourcegroup | grep \"ipAddress\"\: > azure_ip_addr.txt
echo Deploying application to servers: $(cat azure_ip_addr.txt)
cat > $ansible_hosts_file <<EOL
[local]
localhost

[azure]
EOL
awk '{print $2}' azure_ip_addr.txt | awk -F\" '{print $2}' >> $ansible_hosts_file
ansible-playbook -i $ansible_hosts_file deploy_tradebotwebui.yml
