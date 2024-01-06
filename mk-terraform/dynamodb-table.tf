resource "aws_dynamodb_table" "file_table" {
  name         = var.tableName
  billing_mode = "PAY_PER_REQUEST" # You can use "PROVISIONED" if desired
  hash_key     = var.table-atrribute
  attribute {
    name = var.table-atrribute
    type = "S"
  }
  tags = var.tags
}