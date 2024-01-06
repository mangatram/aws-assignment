variable "s3-bucket-name" {
  type        = string
  default     = "mk-s3-001"
  description = "Name of the s3 bucket"
}

variable "tags"{
    type = map(string)
    default = {
        owner = "mangat"
    }
    description = "Map of tags to be applied to the resource"
}

variable "tableName" {
    type = string
    default = "Files"
    description = "Name of the table"
}

variable "table-atrribute" {
    type = string
    default = "FileName"
    description = "Name of the table"
}

variable "iam-role-name-stepFunction" {
  type = string
  default = "step-function-role"
  description = "Step function's iam role name"
}

variable "step-function-name" {
    type = string
    default = "mk-step-function-01"
    description = "step function name"
}