output "public_subnet_ids" {
  value = aws_instance.app.*.public_ip
}

output "private_subnet_ids" {
  value = aws_instance.db.private_ip
}

output "my_lb_dns_name" {
    value = aws_lb.my_lb.dns_name
}