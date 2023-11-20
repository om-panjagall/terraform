variable "aws_key_name" {
  type        = string
  description = "AWS key name"
  default     = "aws_key"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs"
}

variable "ami" {
  type        = string
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "security_groups" {
  type = list(string)
  description = "Security groups"
}

