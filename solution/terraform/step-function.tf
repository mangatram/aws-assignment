# Module to create an IAM role for Step Function
module "step_function_role" {
  source       = "./tf-modules/iam-role"
  role-prefix  = var.step-function-name
  tags         = var.tags
  role-Service = "states.amazonaws.com"
}

# IAM policy for Step Function with permissions to write to DynamoDB
resource "aws_iam_policy" "step_function_policy" {
  name        = "${var.step-function-name}-iam-policy"
  tags        = var.tags
  description = "IAM policy for step function to write to DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["dynamodb:PutItem"],
      Effect   = "Allow",
      Resource = aws_dynamodb_table.file_table.arn
    }]
  })
}

# Attach IAM policy to Step Function's IAM role
resource "aws_iam_role_policy_attachment" "attach_step_function_policy" {
  policy_arn = aws_iam_policy.step_function_policy.arn
  role       = module.step_function_role.name
}

# Define AWS Step Function state machine
resource "aws_sfn_state_machine" "step_function_01" {
  name     = var.step-function-name
  role_arn = module.step_function_role.arn
  tags     = var.tags

  # State machine definition to write to DynamoDB
  definition = jsonencode({
    Comment = "Step Function to write to DynamoDB",
    StartAt = "WriteToDynamoDB",
    States = {
      WriteToDynamoDB = {
        Type     = "Task",
        Resource = "arn:aws:states:::dynamodb:putItem",
        End      = true,
        Parameters = {
          TableName : var.tableName,
          Item : {
            "FileName" : {
              "S.$" : "$.fileName"
            }
          }
        }
      }
    }
  })
}
