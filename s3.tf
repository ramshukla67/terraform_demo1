resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-s3-versioning"
  versioning {
    enabled = true
  }
}
