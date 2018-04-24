#!/bin/bash
#Use this script to trigger ansible deployment of tradebot webui application

export ansible_hosts_file=azure-ansible-hosts
az vm list-ip-addresses -g tradebotresourcegroup | grep \"ipAddress\"\: > azure_ip_addr.txt
echo Deploying application to servers: $(cat azure_ip_addr.txt)
cat > $ansible_hosts_file <<EOL
[local]
localhost

[azure]
EOL
awk '{print $2}' azure_ip_addr.txt | awk -F\" '{print $2}' >> $ansible_hosts_file
ansible-playbook -i $ansible_hosts_file deploy_tradebotwebui.yml
