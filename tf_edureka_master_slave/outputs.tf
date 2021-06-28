output "edureka-master-public-ip" {
  value = aws_instance.edureka-master.public_ip
}

output "edureka-slave-public-ip" {
  value = aws_instance.edureka-slave.public_ip
}

output "edureka-master-tag-name" {
  value = aws_instance.edureka-master.tags.Name
}

output "edureka-slave-tag-name" {
  value = aws_instance.edureka-slave.tags.Name
}

output "edureka-master-tag-role" {
  value = aws_instance.edureka-master.tags.Role
}

output "edureka-slave-tag-role" {
  value = aws_instance.edureka-slave.tags.Role
}

/* output "edureka-jump-public-ip" {
  value = aws_instance.edureka-jump.public_ip
} */

/* output "nat_gateway_ip" {
  value = aws_eip.nat.public_ip
} */