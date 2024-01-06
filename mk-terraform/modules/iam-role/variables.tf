variable "role-prefix" {
  type        = string
  description = "Role prefix : ideally the name of the resource to which this resource belongs."
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be applied to the resource"
}

variable "role-Service" {
  type        = string
  description = "service url this role applies to. example: lambda.amazonaws.com"
}