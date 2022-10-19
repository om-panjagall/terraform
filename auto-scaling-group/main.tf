provider "aws" {
    secret_key = "${var.secret_key}"
    access_key  = "${var.access_key }"
    region = "${var.region}"
}


#VPC 
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/21"

  tags = {
      Name = "Main VPC"
  }
}


# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"
  depends_on = [aws_vpc.main_vpc]

  tags = {
    Name = "Public Subnet"
  }
}


# Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-south-1b"
  depends_on = [aws_vpc.main_vpc]

  tags = {
    Name = "Private Subnet"
  }
}

# Route Table
resource "aws_route_table" "public_route_table" {
  tags = {
    Name = "Public rt table"
  }

  vpc_id = aws_vpc.main_vpc.id
  
}

# Associate route table with public subnet
resource "aws_route_table_association" "public_subnect_associate" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_internet_gateway" "main_igw" {
  tags = {
    Name = "Main IGW"
  }
  vpc_id = aws_vpc.main_vpc.id
  depends_on = [aws_vpc.main_vpc]
}

# Add default route in routing table to point to IGW
resource "aws_route" "allow_public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id
}

# Create SG for Web Server
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "https from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "db request from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_sg"
  }
}

# AWS pem key 

resource "tls_private_key" "tls_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "pem_keys" {
  key_name   = "techschool"
  public_key = tls_private_key.tls_private_key.public_key_openssh
}

resource "local_file" "techschool_pem_key" {
    content  = tls_private_key.tls_private_key.private_key_pem
    filename = "techschool.pem"
}


# ALB SG
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "https from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# ALB TG
resource "aws_lb_target_group" "alb_tg" {
   health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.main_vpc.id 
}


# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  //subnets            = [var.private_subnet.id, var.public_subnet.id]
  
  //enable_deletion_protection = true
  ip_address_type = "ipv4"

  subnet_mapping {
    subnet_id = aws_subnet.private_subnet.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.public_subnet.id
  }

  tags = {
    Environment = "production"
  }
}

# ALB listner rules
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# Launch template
resource "aws_launch_template" "techschool_launch_template" {
  name = "techschool-launch-template"

  image_id = "ami-062df10d14676e201"

  instance_type = "t2.micro"

  key_name = aws_key_pair.pem_keys.key_name

  monitoring {
    enabled = false
  }


  placement {
    availability_zone = "ap-south-1a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Web-server"
    }
  }

  user_data = filebase64("user-data.sh")
}

# ASG 
resource "aws_autoscaling_group" "techschool_asg" {
  launch_template {
    id      = aws_launch_template.techschool_launch_template.id
  }

  availability_zones = ["ap-south-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  health_check_type = "ELB"
  health_check_grace_period = "300"
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.techschool_asg.id
  lb_target_group_arn    = aws_lb_target_group.alb_tg.arn
}

output "private_key" {
  value     = tls_private_key.tls_private_key.private_key_pem
  sensitive = true
}