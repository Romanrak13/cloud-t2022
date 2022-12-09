
FUNC_NAME=`aws lambda list-functions --query Functions[0].FunctionName --output text`
aws lambda update-function-configuration --function-name $FUNC_NAME --timeout 30
aws lambda invoke \
    --function-name $FUNC_NAME \
    --invocation-type Event \
    --payload file://inputFile.txt outputfile.txt
aws lambda add-permission \
    --function-name $FUNC_NAME \
    --principal s3.amazonaws.com \
    --statement-id s3invoke2 \
    --action "lambda:InvokeFunction" \
    --source-arn arn:aws:s3:::rraklab8 \
    --source-account 629375874509
aws lambda get-policy --function-name $FUNC_NAME
FUNC_ARN=`aws lambda list-functions --query 'Functions[0].FunctionArn' --output text`
echo '{
    "LambdaFunctionConfigurations": [
        {
            "Id": "lambda-trigger",
            "LambdaFunctionArn": "'"$FUNC_ARN"'" ,
            "Events": [
                "s3:ObjectCreated:*"
            ]
        }
    ]
}' > notification.json
aws s3api put-bucket-notification-configuration --bucket rraklab8 --notification-configuration file://notification.json