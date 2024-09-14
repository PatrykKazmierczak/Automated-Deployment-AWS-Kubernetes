# Define the S3 bucket
resource "aws_s3_bucket" "weather_bucket" {
  bucket = "weather-app-bucket"  # Change the name to something unique
}

# Define the public access block configuration for the bucket
resource "aws_s3_bucket_public_access_block" "weather_bucket" {
  bucket = aws_s3_bucket.weather_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Create an IAM policy document for the S3 bucket
data "aws_iam_policy_document" "weather_bucket_policy" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.weather_bucket.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

# Attach the IAM policy to the S3 bucket
resource "aws_s3_bucket_policy" "weather_bucket_policy" {
  bucket = aws_s3_bucket.weather_bucket.id
  policy = data.aws_iam_policy_document.weather_bucket_policy.json
}
