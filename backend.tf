terraform {
  backend "s3" {
    bucket         = "terraform-s3-for-state-file"
    key            = "var/statefile"
    region         = "us-west-2"
    dynamodb_table = "lock-table"
    encrypt        = true
  }
}