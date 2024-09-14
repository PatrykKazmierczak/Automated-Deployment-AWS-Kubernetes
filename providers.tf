terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "weather_app" {
  cidr_block = "10.0.0.0/16"
}