#!/usr/bin/env bash

set -ex

update-ca-trust

echo "---Installing Packages---"
dnf update -y
dnf install -y podman awscli jq python3-boto3 wget nmap

echo "---SSM Agent Set-Up---"
systemctl status amazon-ssm-agent.service \
  || dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm \
  && systemctl enable amazon-ssm-agent.service
