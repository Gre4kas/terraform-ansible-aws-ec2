# Создание VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Создание подсети
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Создание Security Group
resource "aws_security_group" "ansible_sg" {
  vpc_id = aws_vpc.main.id
  name   = "ansible-security-group"
}

# Правило Ingress для порта 22 (SSH)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Правило Ingress для порта 5000
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "tcp"
}

# EC2 Инстанс
resource "aws_instance" "ansible_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  key_name               = var.ssh_key_name
  security_groups        = [aws_security_group.ansible_sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "ansible-test-instance"
  }
}

# Data resource для получения последней версии Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Owner ID для Ubuntu
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Локальный провайдер для записи данных в Ansible inventory файл
resource "local_file" "ansible_inventory" {
  content  = <<EOF
[ansible_instance]
${aws_instance.ansible_instance.public_dns}
EOF
  filename = "${path.module}/ansible/inventory/inventory.ini"
}
