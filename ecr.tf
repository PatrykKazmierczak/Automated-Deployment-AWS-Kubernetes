
# Define the private ECR repository
resource "aws_ecr_repository" "weather-app" {
  name                 = "weather-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

