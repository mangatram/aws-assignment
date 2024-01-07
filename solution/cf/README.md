# define the variables
stackNameforPre="mk-s3-logsstack-01"
stackNameforS3="mk-s3-stack-01"
logsS3Name="mk-s3-logsbucket-01"
s3Name="mk-s3-bucket-01"
iamUserName="mangat-02"
region="us-west-2"
alias awstack="aws --endpoint-url http://localhost:4566"

# create the pre-requisite resources - logs s3, iam user
awstack cloudformation create-stack --stack-name "$stackNameforPre" --template-body file://s3.pre.template --parameters ParameterKey=BucketName,ParameterValue="$logsS3Name" ParameterKey=IAMUser,ParameterValue="$iamUserName" --region "$region" --capabilities CAPABILITY_NAMED_IAM

# wait for the stack completion
awstack cloudformation wait stack-create-complete --stack-name "$stackNameforPre" --region "$region"
# optionally, get the stack events
# aws cloudformation describe-stack-events --stack-name "$stackNameforPre" --region "us-west-2"
# awstack cloudformation describe-stacks --stack-name "$stackNameforPre" --query "Stacks[0].StackStatus" --region "$region"

# Create the stack for - s3 bucket with a log policy
awstack cloudformation create-stack --stack-name "$stackNameforS3" --template-body file://s3.template --parameters ParameterKey=BucketName,ParameterValue="$s3Name" ParameterKey=LogBucketName,ParameterValue="$logsS3Name" ParameterKey=IAMUser,ParameterValue="$iamUserName" --region "$region"

# view stack overall status and events
# awstack cloudformation describe-stack-events --stack-name "$stackNameforS3" --region "us-west-2"
# awstack cloudformation describe-stacks --stack-name "$stackNameforS3" --query "Stacks[0].StackStatus" --region "$region"

# list created buckets
awstack s3api list-buckets

# delete the stack
awstack cloudformation delete-stack --stack-name "$stackNameforPre" --region "$region"
awstack cloudformation delete-stack --stack-name "$stackNameforS3" --region "$region"