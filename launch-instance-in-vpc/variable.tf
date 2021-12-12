variable "prod-vpc"{
    default = "10.0.0.0/16"
    description = "VPC CIDR block"
    type = string
}
variable "public-subnet-cidr"{
    default = "10.0.0.0/24"
    description = "Public Subnet CIDR block" 
    type = string
}
variable "private-subnet-cidr" {
  default = "10.0.1.0/24"
  description = "Private Subnet CIDR block"
  type = string
}


variable "ami" {
    default = "ami-0ed9277fb7eb570c9"
}

variable "ami_type" {
    default = "t2.micro"
}

