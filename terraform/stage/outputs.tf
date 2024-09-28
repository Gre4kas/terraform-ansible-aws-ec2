# Вывод public DNS имени
output "public_dns" {
  description = "Public DNS EC2 инстанса"
  value       = aws_instance.ansible_instance.public_dns
}

# Запись public DNS в Ansible inventory
output "ansible_inventory" {
  description = "Путь к Ansible inventory"
  value       = "${path.module}/ansible/inventory/inventory.ini"
}

