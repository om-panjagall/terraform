output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

# output "wordpress_url" {
#   description = "WordPress site URL"
#   value       = module.ec2.wordpress_url
# }