# output "alb_dns_name" {
#   value = aws_lb.wordpress.dns_name
# }

# output "wordpress_url" {
#   description = "WordPress site URL"
#   value       = element(aws_instance.wordpress.*.public_ip, 0)
# }