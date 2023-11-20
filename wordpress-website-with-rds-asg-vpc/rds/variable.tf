variable "db_password" {
  type        = string
  description = "DB Password"
  sensitive   = true
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs"
}


