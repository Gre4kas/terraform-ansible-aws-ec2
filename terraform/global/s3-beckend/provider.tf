provider "aws" {
  region = "us-east-1" 
}

terraform {
    required_version = ">= 1.0.0"
    # backend "s3" {
    #     # Replace this with your bucket name!
    #     bucket = "<YOUR_S3_BUCKET_HERE>"
    #     key = "global/s3/terraform.tfstate"
    #     region= "us-east-2"
    #     # Replace this with your DynamoDB table name!
    #     dynamodb_table = "YOUR_DYNAMODB_TABLE_NAME_HERE"
    #     encrypt        = true
    # } 
}