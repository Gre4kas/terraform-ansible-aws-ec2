# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-remote-state-bucket-gre4ka"
    key    = "stage/web-server/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-remote-state-dynamo"
    encrypt        = true
  }
}
