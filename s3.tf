resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-s3-versioning"
  versioning {
    enabled = true
  }
  lifecycle_rule {
	id = "expire"
	status = "Enabled"
	prefix = "logs/"
	tranition {
		days = 30
		storage_class = "STANDARD_IA"
	}
	expiration{
		days = 10
	}
  }
}

resource "aws_s3_bucket_public_block" "acess_terraform_state" {
	bucket = aws_s3_bucket.terraform_state.id
	block_public_acls = true
	block_public_policy = true
}

resource "aws_s3_bucket_logging" "logging" {
	bucket = aws_s3_bucket.logging.id
	target_bucket = aws_s3_bucket.terraform_state.id
	target_prefix = "log/"
}

