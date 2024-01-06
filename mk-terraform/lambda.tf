variable "lamda-function-name" {
  default = "mk-lamda-function-02"
}

resource "aws_iam_role" "lamda_function_role" {
  name = "${var.lamda-function-name}-iam-role"
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lamda_function_policy" {
  name        = "${var.lamda-function-name}-iam-policy"
  tags        = var.tags
  description = "IAM policy for lamda function to : trigger step function, read s3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "s3:Get*",
        "s3:List*",
        "s3:Describe*",
        "s3-object-lambda:Get*",
        "s3-object-lambda:List*"
      ],
      Effect   = "Allow",
      Resource = aws_s3_bucket.file_upload_bucket.arn
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "states:StartExecution"
        ],
        Effect   = "Allow",
        Resource = aws_sfn_state_machine.step_function_01.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lamda_function_policy" {
  policy_arn = aws_iam_policy.lamda_function_policy.arn
  role       = aws_iam_role.lamda_function_role.name
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_function" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = var.lamda-function-name
  role          = aws_iam_role.lamda_function_role.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.10"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_permission" "allow_terraform_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.file_upload_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_terraform_notification" {
  bucket = aws_s3_bucket.file_upload_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_terraform_bucket]
}
