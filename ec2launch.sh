#!/bin/bash

TEMP_ID="lt-0755cc2cbc460e5f3"
TEMP_VER=3

aws ec2 run-instances --launch-template LaunchTemplateId=${TEMP_ID},Version=${TEMP_VER} --tag-specifications "ResourceType=instance,Tags=[{Key=name,Value=frontend}]"  | jq