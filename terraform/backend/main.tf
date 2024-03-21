resource "aws_s3_bucket" "lock_bucket" {
    bucket = "nikxy-webapp-terraform"
}
resource "aws_dynamodb_table" "lock_dynamodb" {
  name = "webapp-terraform"
  hash_key = "LockID"
  read_capacity = 5
  write_capacity = 5
 
  attribute {
    name = "LockID"
    type = "S"
  }
}
