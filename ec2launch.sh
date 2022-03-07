#!/bin/bash

TEMP_ID="lt-06c5374ac5f24eb25"
TEMP_VER=3
ZONE_ID=Z0686471167SJWZUE9FVZ

export COMPONENT=$1


if [ -z "$1" ]; then
  echo -e "\e[1;31mInput is missing\e[0m"
  exit
fi

export ENV=$2

if [ ! -z "${ENV}" ]; then
  ENV="-${ENV}"
fi

CREATE_INST() {

aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].State.Name | sed 's/"//g' | grep -E "running|stopped" &>/dev/null

if [ $? -eq 0 ]; then
  echo -e "\e[1;33mInstance is already there\e[0m"

else
  aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq

fi

sleep 10

IPADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq .Reservations[].Instances[].PrivateIpAddress | sed 's/"//g' | grep -v null)

sed -e "s/IPADDRESS/${IPADDRESS}/" -e "s/COMPONENT/${COMPONENT}/" record.json >/tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq
}

if [ "${COMPONENT}" == "all" ]; then
  for comp in frontend mongodb redis catalogue user cart shipping rabbitmq dispatch payment; do
    COMPONENT=$comp$ENV
    CREATE_INST
  done
  else
    COMPONENT=$COMPONENT$ENV
    CREATE_INST
fi