resource "aws_s3_bucket" "weather_bucket" {
    bucket = "weather_app"
}


resource "aws_s3_bucket_public_access_block" "weather_bucket" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Create an IAM policy document that allows public read access to the S3 bucket
data "aws_iam_policy_document" "weather_bucket_policy" {
  statement {
    sid    = "AllowPublic"  # Statement ID for identification
    effect = "Allow"       # Allow the specified actions
    actions = ["s3:GetObject"]  # Allow read access to objects in the bucket
    resources = ["${aws_s3_bucket.bucket.arn}/*"]  # Apply policy to all objects in the bucket
    principals {
      type = "*"  # Apply to any principal (user or service)
      identifiers = ["*"]  # Allow access to everyone
    }
  }
}

# Attach the policy to the S3 bucket
resource "aws_s3_bucket_policy" "weather_bucket_policy" {
  bucket = aws_s3_bucket.bucket.id  # Reference to the S3 bucket created above
  policy = data.aws_iam_policy_document.weather_bucket_policy  # JSON representation of the IAM policy document
}