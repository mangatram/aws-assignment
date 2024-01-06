s3-bucket-name = "mk-s3-001"
tags = {
  owner = "mangat"
}
lambda-function-name            = "mk-lambda-function-02"
tableName                       = "Files"
table-atrribute                 = "FileName"
iam-role-name-stepFunction      = "step-function-role"
step-function-name              = "mk-step-function-01"
python-function-runtime-version = "python3.10"
python-code-file-path           = "lambda_function.py"
python-lambda-handler           = "lambda_function.lambda_handler"