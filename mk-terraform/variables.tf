variable "s3-bucket-name" {
  type        = string
  description = "Name of the s3 bucket"
}

variable "tags" {
  type = map(string)
  default = {
    owner = "mangat"
  }
  description = "Map of tags to be applied to the resource"
}

variable "lambda-function-name" {
  type        = string
  description = "Name of lambda function"
}

variable "tableName" {
  type        = string
  description = "Name of the table"
}

variable "table-atrribute" {
  type        = string
  description = "Name of the table"
}

variable "iam-role-name-stepFunction" {
  type        = string
  description = "Step function's iam role name"
}

variable "step-function-name" {
  type        = string
  description = "step function name"
}

variable "python-function-runtime-version" {
  type        = string
  description = "runtime python version to use for lambda function"
}

variable "python-code-file-path" {
  type        = string
  description = "python code handler file path"
}

variable "python-lambda-handler" {
  type        = string
  description = "python-lambda-handler"
}