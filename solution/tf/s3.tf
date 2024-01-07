# s3 bucket resource creation
resource "aws_s3_bucket" "file_upload_bucket" {
  bucket        = var.s3-bucket-name
  tags          = var.tags
  force_destroy = true
}

