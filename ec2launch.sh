#!/bin/bash

TEMP_ID="lt-0755cc2cbc460e5f3"
TEMP_VER=5

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