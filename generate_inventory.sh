#!/bin/bash

amzn_linux_ip=$(terraform output -raw amzn_linux_public_ip)
ubuntu_linux_ip=$(terraform output -raw ubuntu_linux_public_ip)

cat <<EOF > inventory.ini
[frontend]
${amzn_linux_ip} ansible_user=ec2-user

[backend]
${ubuntu_linux_ip} ansible_user=ubuntu
EOF

echo "Generated inventory.ini"
cat inventory.ini

