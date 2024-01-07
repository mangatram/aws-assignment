# Resource block for creating a DynamoDB table
resource "aws_dynamodb_table" "file_table" {
  # Name of the DynamoDB table from a variable
  name = var.tableName

  # Billing mode for the table: PAY_PER_REQUEST for on-demand capacity
  billing_mode = var.dynamodb_billing_mode

  # Primary key attribute name for the table
  hash_key = var.table-atrribute

  # Attribute definition for the primary key
  attribute {
    name = var.table-atrribute # Attribute name
    type = "S"                 # Attribute type: 'S' for string
  }

  # Tags for the DynamoDB table from a variable
  tags = var.tags
}
