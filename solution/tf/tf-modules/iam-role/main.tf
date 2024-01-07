resource "aws_iam_role" "lambda_function_role" {
  name = "${var.role-prefix}-iam-role"
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = var.role-Service
      }
    }]
  })
}