#!/bin/bash

TEMP_ID="lt-0755cc2cbc460e5f3"
TEMP_VER=1

aws ec2 run-instances LaunchTemplateId=$(TEMP_ID),Version=$(TEMP_VER)