resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidr
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidr
}

resource "aws_security_group" "wordpress" {
  name        = "wordpress"
  description = "Security group for WordPress instances"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  vpc_id =  aws_vpc.my_vpc.id

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        #security_groups = module.network.wordpress_security_group

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}

# resource "aws_security_group_rule" "ec2_to_rds" {
#   type        = "ingress"
#   from_port   = 3306
#   to_port     = 3306
#   protocol    = "tcp"
#   source_security_group_id = aws_security_group.wordpress.id
#   security_group_id        = var.rds_security_group
# }