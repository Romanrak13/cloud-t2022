#!/bin/bash
IMAGE_ID=$(aws ec2 describe-images --owners 629375874509 --query 'Images[*].ImageId' --output text)
echo $IMAGE_ID
aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type t2.micro --key-name MyKeyPair1 --security-group-ids $SG --user-data file://user_data.sh