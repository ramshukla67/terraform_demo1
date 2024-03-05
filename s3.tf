resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-s3-versioning"
  versioning {
    enabled = true
  }
  lifecycle_rule {
	id = "expire"
	enabled = true
	prefix = "logs/"
	transition {
		days = 30
		storage_class = "STANDARD_IA"
	}
	expiration{
		days = 10
	}
  }
  replication_configuration {
    role = "arn:aws:iam::684876534607:role/replication"

    rules {
      id     = "replicate-objects"
      priority = 1
	  status     = "Enabled"
      destination {
        bucket = "arn:aws:s3:::replication-bucket-terraform"
        storage_class = "STANDARD"
      }

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }
    }
  }
}

resource "aws_sns_topic" "bucket-notifications" {
	name = "bucket-notifications"
	kms_master_key_id = "alias/aws/sns"
}

resource "aws_s3_bucket_notification" "bucket-notification" {
	bucket = aws_s3_bucket.terraform_state.id
	topic {
		topic_arn = aws_sns_topic.bucket-notifications.arn
		events = ["s3:ObjectCreated:*"]
		filter_prefix = "logs/"
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
	bucket = aws_s3_bucket.terraform_state.id
	target_bucket = aws_s3_bucket.terraform_state.id
	target_prefix = "log/"
}

resource "aws_kms_key" "my_key" {
  description = "KMS key for example"
  is_enabled             = true
  enable_key_rotation    = true
  policy      = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "default",
    "Statement": [
      {
        "Sid": "DefaultAllow",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::123456789012:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      }
    ]
  }
POLICY
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse_good" {
	bucket = aws_s3_bucket.terraform_state.bucket
	rule {
		apply_server_side_encryption_by_default {
			kms_master_key_id = aws_kms_key.my_key.arn
			sse_algorithm = "aws:kms"
		}
	}
}