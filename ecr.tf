# Define the ECR repository
resource "aws_ecr_repository" "weather-app" {
  name = "weather-app"
}

# Create IAM policy document for ECR access
data "aws_iam_policy_document" "weather-app" {
  statement {
    sid    = "AllowECRActions"  
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
      "ecr:DescribeRepositories"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:role/ECRAccessRole"]  # Replace with a valid role/account
    }

    resources = [
      aws_ecr_repository.weather-app.arn  # Reference the ECR repository's ARN dynamically
    ]
  }
}

# Attach the policy to the ECR repository
resource "aws_ecr_repository_policy" "weather-app" {
  repository = aws_ecr_repository.weather-app.name
  policy     = data.aws_iam_policy_document.weather-app.json
}
