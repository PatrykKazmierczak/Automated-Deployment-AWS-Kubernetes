# Specify the minimum version of Terraform required for this configuration
terraform {
  required_version = "1.9.5"  # Terraform version 1.9.5 or higher is required

  # Define the required providers and their versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Provider source from HashiCorp
      version = "5.67.0"         # Exact version of the AWS provider required
    }
  }
  backend "s3" {
    bucket         = "weather-app-patronix9345"  # S3 bucket name where the state file will be stored
    key            = "terraform.tfstate"                  # Path within the S3 bucket for the state file
    region         = "eu-north-1"                         # AWS region where the S3 bucket is located
  }
}

# Configure the AWS provider
provider "aws" {
  region = "eu-north-1"  # AWS region where resources will be created
}

provider "archive" {
  
}
