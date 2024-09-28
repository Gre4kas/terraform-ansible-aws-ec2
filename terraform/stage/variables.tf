# Define variables for providers.tf
variable "aws_region" {
  default     = "us-east-1"
  description = "aws region"
}

variable "ssh_key_name" {
  description = "AWS EC2 SSH "
  default     = "~/.ssh/aws_instance.pub"
}
