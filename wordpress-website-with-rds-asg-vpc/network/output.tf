output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.id
}

output "rds_security_group" {
  value = aws_security_group.rds.id
}

output "wordpress_security_group" {
  value = aws_security_group.wordpress.id
}

