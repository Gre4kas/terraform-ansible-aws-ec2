provider "aws" {
  region = var.region
}

terraform {
    required_version = ">= 1.0.0"
    # backend "s3" {
    #     # Replace this with your bucket name!
    #     bucket = "terraform-remote-state-bucket-gre4ka"
    #     key = "global/s3/terraform.tfstate"
    #     region= "us-east-1"
    #     # Replace this with your DynamoDB table name!
    #     dynamodb_table = "terraform-remote-state-dynamo"
    #     encrypt        = true
    # } 
}