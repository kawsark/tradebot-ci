#!/bin/bash
#Use this script to read a new set of AWS credentials from vault
#assumes vault cli is available and vault user is authenticated
export ansible_hosts_file=azure-ansible-hosts
export ansible_secrets=key_vars.yml
vault read aws/creds/dev_deploy > tradebot_iam_user
cat tradebot_iam_user
echo "---" > $ansible_secrets
cat tradebot_iam_user | grep access_key | awk '{print "access_key: " $2}' > $ansible_secrets
cat tradebot_iam_user | grep secret_key | awk '{print "secret_key: " $2}' >> $ansible_secrets

echo "Restarting application with new credentials"
ansible-playbook -i $ansible_hosts_file restart_tradebotwebui.yml
