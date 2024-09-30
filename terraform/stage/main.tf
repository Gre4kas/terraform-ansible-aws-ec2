# Создание VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Создание подсети
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true
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
resource "aws_vpc_security_group_ingress_rule" "test_port" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.ansible_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 Инстанс
resource "aws_instance" "ansible_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main.id
  key_name                    = aws_key_pair.ansible_key_ssh.key_name
  security_groups             = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "ansible-test-instance"
  }
}

# Data resource для получения последней версии Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's owner ID for Ubuntu AMIs
}

# Локальный провайдер для записи данных в Ansible inventory файл
resource "local_file" "ansible_inventory" {
  content  = <<EOF
[ansible_instance]
${aws_instance.ansible_instance.public_dns}
EOF
  filename = "${path.module}/../../ansible/inventory/inventory.ini"
}

resource "aws_key_pair" "ansible_key_ssh" {
  key_name   = "ansible_key_ssh"
  public_key = file(var.ssh_key_name) # Path to your public key
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "route_to_internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public_rt.id
}
