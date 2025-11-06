resource "aws_s3_bucket" "login_bucket" {
  bucket = "${var.project_name}-login-bucket-${random_id.bucket_suffix.hex}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning { enabled = true }

  lifecycle_rule {
    id      = "expire-old"
    enabled = true
    expiration { days = 365 }
  }

  force_destroy = false
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

output "s3_bucket" {
  value = aws_s3_bucket.login_bucket.bucket
}
