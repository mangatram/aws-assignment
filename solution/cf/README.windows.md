1. Create s3 bucket which stores the logs
stackNameforPre="mk-s3-logsstack-01"
stackNameforS3="mk-s3-stack-01"
logsS3Name="mk-s3-logsbucket-01"
s3Name="mk-s3-bucket-01"
iamUserName="mangat-02"
region="us-west-2"

# create first stack
aws --endpoint-url http://localhost:4566 cloudformation create-stack --stack-name "mk-s3-logsstack-01" --template-body file://s3.pre.template --parameters ParameterKey=BucketName,ParameterValue="mk-s3-logsbucket-01" ParameterKey=IAMUser,ParameterValue="mangat-02" --region "us-west-2" --capabilities CAPABILITY_NAMED_IAM

# view the overall status of the stack
aws --endpoint-url http://localhost:4566 cloudformation describe-stacks --stack-name "mk-s3-logsstack-01" --query "Stacks[0].StackStatus" --region "us-west-2"

# view the events of the stack
aws cloudformation describe-stack-events --stack-name "mk-s3-logsstack-01" --region "us-west-2"


aws --endpoint-url http://localhost:4566 cloudformation wait stack-create-complete --stack-name "mk-s3-logsstack-01" --region "us-west-2"

2. Create the s3 bucket with a log policy
aws --endpoint-url http://localhost:4566 cloudformation create-stack --stack-name "mk-s3-stack-01" --template-body file://s3.template --parameters ParameterKey=BucketName,ParameterValue="mk-s3-bucket-01" ParameterKey=LogBucketName,ParameterValue="mk-s3-logsbucket-01" ParameterKey=IAMUser,ParameterValue="mangat-02" --region "us-west-2"


