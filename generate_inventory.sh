#!/bin/bash

amzn_linux_ip=$(terraform output -raw amzn_linux_public_ip)
ubuntu_linux_ip=$(terraform output -raw ubuntu_linux_public_ip)

cat <<EOF > inventory.ini
[frontend]
${amzn_linux_ip} ansible_host=${amzn_linux_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/${AMAZON_KEY_PAIR}.pem

[backend]
${ubuntu_linux_ip} ansible_host=${ubuntu_linux_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${UBUNTU_KEY_PAIR}.pem
EOF

echo "Generated inventory.ini"
cat inventory.ini
