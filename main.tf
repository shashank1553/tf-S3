provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "remote-state" {
  bucket        = "terraform-state-27-11-2024"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "bucket-version" {
  bucket = aws_s3_bucket.remote-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "state-lock" {
  name           = "dev-remote-statelock"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}