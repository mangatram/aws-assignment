# resource "aws_iam_role" "lambda_function_role" {
#   name = "${var.lambda-function-name}-iam-role"
#   tags = var.tags
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#     }]
#   })
# }

module "lambda_function_role" {
  source       = "./modules/iam-role"
  role-prefix  = var.lambda-function-name
  tags         = var.tags
  role-Service = "lambda.amazonaws.com"
}

resource "aws_iam_policy" "lambda_function_policy" {
  name        = "${var.lambda-function-name}-iam-policy"
  tags        = var.tags
  description = "IAM policy for lambda function to : trigger step function, read s3 bucket"
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

resource "aws_iam_role_policy_attachment" "attach_lambda_function_policy" {
  policy_arn = aws_iam_policy.lambda_function_policy.arn
  role       = module.lambda_function_role.name
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = var.python-code-file-path
  output_path = local.zip-file-output-path
}

data "aws_region" "current" {}

resource "aws_lambda_function" "lambda_function" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = local.zip-file-output-path
  function_name = var.lambda-function-name
  role          = module.lambda_function_role.arn
  handler       = var.python-lambda-handler

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = var.python-function-runtime-version

  environment {
    variables = {
      REGION            = data.aws_region.current.name
      STATE_MACHINE_ARN = aws_sfn_state_machine.step_function_01.arn
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
