#!/bin/bash

TEMP_ID="lt-06c5374ac5f24eb25"
TEMP_VER=2
ZONE_ID=Z0686471167SJWZUE9FVZ

if [ -z "$1" ]; then
  echo -e "\e[1;31mInput is missing\e[0m"
  exit
fi

COMPONENT=$1



aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].State.Name | sed 's/"//g' | grep -E "running|stopped" &>/dev/null

if [ $? -eq 0 ]; then
  echo -e "\e[1;33mInstance is already there\e[0m"
  exit
fi

aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"  | jq

IPADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=mongodb" | jq .Reservations[].Instances[].PrivateIpAddress | sed 's/"//g')

sed -e 's/IPADDRESS/${IPADDRESS}/' -e 's/COMPONENT/${COMPONENT}/' record.json >/tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json |jq .
