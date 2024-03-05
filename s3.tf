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
resource "aws_kms_key" "my_key" {
  description = "KMS key for example"
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
			kms_master_key_id = aws_kms_key.mykey.arn
			sse_algorithm = "aws:kms"
		}
	}
}
resource "aws_s3_bucket" "replica" {
  bucket = "replica-terraform-s3-versioning"
  versioning {
    enabled = true
  }
  replication_configuration {
    role = aws_iam_role.replication.arn
  
    rules {
      id     = "EntireBucket"
      status = "Enabled"
  
      destination {
        bucket = aws_s3_bucket.replica.arn
		storage_class = "STANDARD"
      }
  
      source_selection_criteria {
        sse_kms_encrypted_objects {
          status = "Enabled"
        }
      }
	  
    }
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
			days = 90
		}
	  }
}

resource "aws_iam_role" "replication" {
  name = "s3-replication-role"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
 }
EOF
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.example.id
  target_bucket = aws_s3_bucket.replica.id
  target_prefix = "log/"
}
resource "aws_s3_bucket_public_access_block" "access_replication_state" {
  bucket = aws_s3_bucket.replica.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls=true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_notification" "bucket-notification" {
	bucket = aws_s3_bucket.replica.id
	topic {
		topic_arn = aws_sns_topic.bucket-notifications.arn
		event = ["s3:ObjectCreated:*"]
		filter_prefix = "logs/"
	}
}
resource "aws_s3_bucket_server_side_encryption_configuration" "good_sse_1" {
  bucket = aws_s3_bucket.replica.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}