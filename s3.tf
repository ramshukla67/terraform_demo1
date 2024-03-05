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

resource "aws_s3_bucket_public_access_block" "access_terraform_state" {
	bucket = aws_s3_bucket.terraform_state.id
	block_public_acls = true
	block_public_policy = true
	ignore_public_acls=true
	restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "logging" {
	bucket = aws_s3_bucket.logging.id
	target_bucket = aws_s3_bucket.terraform_state.id
	target_prefix = "log/"
}

resource "aws_sns_topic" "bucket_notifications" {
	name = "bucket-notifications"
	kms_master_key_id = "alias/aws/sns"
}

resource "aws_s3_bucket_notification" "bucket-notification" {
	bucket = aws_s3_bucket.terraform_state.id
	topic {
		topic_arn = aws_sns_topic.bucket-notifications.arn
		event = ["s3:ObjectCreated:*"]
		filter_prefix = "logs/"
	}
}

resource "aws_s3_bucket_server_side_encription_configuration" "sse_good" {
	bucket = aws_s3_bucket.terraform_state.bucket
	rule {
		apply_server_side_encryption_by_default {
			kms_master_key_id = aws_kms_key.mykey.arn
			sse_algorithm = "aws:kms"
		}
	}
}