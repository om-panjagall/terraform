variable "vpc_cidr_block" {
  type        = string
  description = "VPC cidr block"
}

variable "vpc_tag" {
  type        = string
  description = "VPC tag"
  default     = "main"
}

variable "private_subnet_cidr" {
  type        = string
  description = "Private subnet cidr block"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet cidr block"
}

# variable "rds_security_group" {
#   type        = string
#   description = "Instance type"
# }