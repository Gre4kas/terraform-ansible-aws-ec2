# Define variables for providers.tf
variable "aws_region" {
  default     = "us-east-1"
  description = "aws region"
}

# Определение переменных
variable "ssh_key_name" {
  description = "Имя SSH ключа"
  default     = "~/.ssh/aws_instance.pub"
}
