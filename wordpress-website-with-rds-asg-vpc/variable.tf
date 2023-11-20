variable "vpc_cidr_block" {
  type        = string
  description = "VPC cidr block"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  type        = string
  description = "Private subnet cidr block"
  default     = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet cidr block"
  default     = "10.0.1.0/24"
}

variable "db_password" {
  type        = string
  description = "Password for the RDS database"
  sensitive   = true
  default     = "admin@123"
}

variable "ami" {
  type        = string
  description = "AMI ID"
  default     = "ami-0fc5d935ebf8bc3bc"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}