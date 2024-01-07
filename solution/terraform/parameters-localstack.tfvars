s3-bucket-name = "test-bucket"
tags = {
  owner = "localstack"
}
lambda-function-name            = "lambda-function-01"
tableName                       = "Files"
table-atrribute                 = "FileName"
iam-role-name-stepFunction      = "step-function-role"
step-function-name              = "step-function-01"
python-function-runtime-version = "python3.9"
python-code-file-path           = "lambda-code/lambda_function.py"
python-lambda-handler           = "lambda_function.lambda_handler"
aws-endpoint-url                = "http://localhost:4566"