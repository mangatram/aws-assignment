variable "s3-bucket-name" {
  type        = string
  description = "The name of the S3 bucket to be created. This name must be unique across all existing bucket names in AWS."

  validation {
    condition     = length(var.s3-bucket-name) > 0 && length(var.s3-bucket-name) <= 63
    error_message = "The S3 bucket name must be between 1 and 63 characters.\n"
  }
}

variable "tags" {
  type = map(string)
  default = {
    owner = "mangat"
  }
  description = "A map of tags to be applied to all resources. This is used to identify resources and manage them in terms of cost allocation, automation, and access control."
}

variable "lambda-function-name" {
  type        = string
  description = "The name of the AWS Lambda function to be created. This name is used to reference the function within AWS and should be unique."

  validation {
    condition     = length(var.lambda-function-name) > 0 && length(var.lambda-function-name) <= 64
    error_message = "The Lambda function name must be between 1 and 64 characters.\n"
  }
}

variable "tableName" {
  type        = string
  description = "The name of the DynamoDB table. This name is used as an identifier for the table in AWS DynamoDB."

  validation {
    condition     = length(var.tableName) > 0 && length(var.tableName) <= 255
    error_message = "The DynamoDB table name must be between 1 and 255 characters.\n"
  }
}

variable "table-atrribute" {
  type        = string
  description = "The primary key attribute name for the DynamoDB table. This attribute is used to uniquely identify each item in the table."

  validation {
    condition     = length(var.table-atrribute) > 0 && length(var.table-atrribute) <= 255
    error_message = "The DynamoDB table attribute name must be between 1 and 255 characters.\n"
  }
}

variable "iam-role-name-stepFunction" {
  type        = string
  description = "The name of the IAM role for the Step Function. This role provides necessary permissions for the Step Function execution."

  validation {
    condition     = length(var.iam-role-name-stepFunction) > 0 && length(var.iam-role-name-stepFunction) <= 64
    error_message = "The IAM role name for Step Function must be between 1 and 64 characters.\n"
  }
}

variable "step-function-name" {
  type        = string
  description = "The name of the Step Function (State Machine). This name is used as an identifier for the Step Function within AWS."

  validation {
    condition     = length(var.step-function-name) > 0 && length(var.step-function-name) <= 80
    error_message = "The Step Function name must be between 1 and 80 characters.\n"
  }
}

variable "python-function-runtime-version" {
  type        = string
  description = "The runtime version of Python to be used for the Lambda function. This should match the version used in your function's code."
}

variable "python-code-file-path" {
  type        = string
  description = "The file path to the Python code for the Lambda function. This is the path to the file that contains your Lambda function handler."
}

variable "python-lambda-handler" {
  type        = string
  description = "The handler method within your Python code. This is the entry point for your Lambda function execution (e.g., 'main.handler')."
}

variable "aws-endpoint-url" {
  type        = string
  description = "The custom endpoint URL for AWS services. This is typically used for local testing with services like LocalStack."
  default     = ""
}

variable "dynamodb_billing_mode" {
  type        = string
  description = "Billing mode for the DynamoDB table."
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = var.dynamodb_billing_mode == "PAY_PER_REQUEST" || var.dynamodb_billing_mode == "PROVISIONED"
    error_message = "The billing mode must be either 'PAY_PER_REQUEST' or 'PROVISIONED'."
  }
}

variable "force-delete-s3" {
  type        = bool
  description = "whether to force delete the s3 bucket. keep it false for production deployments."
  default     = false
}