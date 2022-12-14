#!/bin/bash

echo '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "*",
            "Resource": "arn:aws:s3:::roman-rak-aws/*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": "50.31.252.0/24"
                },
                "Bool": {
                    "aws:ViaAWSService": "false"
                }
            }
        }
    ]
}' > policy.json

aws s3api create-bucket --bucket roman-rak-aws --region us-east-1 \
&& aws s3api put-bucket-policy --bucket roman-rak-aws --policy file://policy.json \
&& aws s3 sync ./ s3://roman-rak-aws/ \
&& aws s3 website s3://roman-rak-aws/ --index-document index.html --error-document error.html
