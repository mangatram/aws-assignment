output "arn" {
  description = "arn for the created iam resource"
  value       = aws_iam_role.lambda_function_role.arn
}

output "name" {
  description = "name of the created iam resource"
  value       = aws_iam_role.lambda_function_role.name
}