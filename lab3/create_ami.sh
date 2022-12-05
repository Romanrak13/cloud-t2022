#!/bin/bash 

INST_ID=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=stopped Name=instance-type,Values=t2.micro --query 'Reservations[*].Instances[].InstanceId' --output text) \
&& IMAGE_ID=$(aws ec2 create-image --instance-id $INST_ID --name 'MyAmi' --description 'An AMI for WebServer' --query ImageId --output text) \
&& echo $IMAGE_ID \
&& echo $INST_ID 
