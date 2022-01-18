#!/bin/bash

TEMP_ID="lt-0755cc2cbc460e5f3"
TEMP_VER=5

if [ -z "$1" ]; then
  echo "Input is missing"
  exit
fi

COMPONENT=$1



aws ec2 describe-instances --filters "Name=tag:name,Values=${COMPONENT}" | jq .Reservations[].Instances[].State.Name | sed 's/"//g' | grep -E "running|stopped" &>/dev/null

if [ $? -eq 0 ]; then
  echo "Instance is already there"
  exit
fi

aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=instance,Tags=[{Key=name,Value=${COMPONENT}]"  | jq