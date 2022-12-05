#!/bin/bash

LB_ARN=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text)
echo $LB_ARN
TG_ARN=$(aws elbv2 describe-target-groups --query 'TargetGroups[*].TargetGroupArn' --output text)
echo $TG_ARN
INST1_ID=$(aws ec2 describe-instances --query 'Reservations[-1].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
INST2_ID=$(aws ec2 describe-instances --query 'Reservations[-2].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
echo $INST1_ID
echo $INST2_ID
aws elbv2 register-targets --target-group-arn $TG_ARN --targets Id=$INST1_ID Id=$INST2_ID
aws elbv2 create-listener --load-balancer-arn $LB_ARN --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$TG_ARN 
aws elbv2 describe-target-health --target-group-arn $TG_ARN 
aws autoscaling create-auto-scaling-group --auto-scaling-group-name Lab4ASG --instance-id $INST1_ID --min-size 2 --max-size 2 --target-group-arns $TG_ARN 
aws autoscaling describe-load-balancer-target-groups --auto-scaling-group-name Lab4ASG
aws autoscaling update-auto-scaling-group --auto-scaling-group-name Lab4ASG --health-check-type ELB --health-check-grace-period 15 
LB_DNS=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[0].DNSName' --output text)
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name Lab4ASG
echo $LB_DNS
