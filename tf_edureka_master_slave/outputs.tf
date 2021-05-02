output "edureka-master-private-hostname" {
  value = aws_instance.edureka-master.private_dns
}

output "edureka-slave-private-hostname" {
  value = aws_instance.edureka-slave.private_dns
}

output "edureka-jump-public-ip" {
  value = aws_instance.edureka-jump.public_ip
}

output "nat_gateway_ip" {
  value = aws_eip.nat.public_ip
}