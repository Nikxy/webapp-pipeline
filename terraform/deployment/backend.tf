terraform {
  backend "s3" {
    encrypt = true
    bucket = "nikxy-webapp-terraform"
    dynamodb_table = "webapp-terraform"
    key    = "terraform.tfstate"
    region = "il-central-1"
  }
}