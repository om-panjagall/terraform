
//Create VPC
resource "aws_vpc" "my_vpc"{
   
    cidr_block = "${var.prod-vpc}" // Total 65534 IP address will be available for this VPC
    
    tags = {
        Name = "Production"
    }
}

// Private Subnet
resource "aws_subnet" "prod_private_subnet"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "${var.private-subnet-cidr}" // 254 IP addresses will be available from VPC IP addresses i.e from 65534
    availability_zone = "us-east-1a"
    map_public_ip_on_launch  = false

    tags = {
        Name = "Private Subnet"
    }
}

// Public Subnet
resource "aws_subnet" "prod_public_subnet"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "${var.public-subnet-cidr}" // 254 IP addresses will be available from VPC IP addresses i.e from 65534
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "Public Subnet"
    }
}

//IGW

resource "aws_internet_gateway" "production_igw"{
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "Production IGW"
    }
}

// Create route table and Add private Route 
resource "aws_route_table" "prod_private_rt_table"{
    vpc_id = aws_vpc.my_vpc.id
    route{
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.production_igw.id
    }

    tags = {
      Name = "Private Route Table"
    }
} 

// Route table association: Associate private subnet to private route table 
# resource "aws_route_table_association" "private_route_table_association" {
#   subnet_id      = aws_subnet.prod_private_subnet.id
#   route_table_id = aws_route_table.prod_private_rt_table.id
# }

// Create route table and Add public Route 

resource "aws_route_table" "prod_public_rt_table"{
    vpc_id = aws_vpc.my_vpc.id
    route{
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.production_igw.id
    }

    tags = {
      Name = "Public Route Table"
    }
} 

// Route table association: Associate public subnet to public route table 
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.prod_public_subnet.id
  route_table_id = aws_route_table.prod_public_rt_table.id
}


// Lauching instance in private subnet
resource "aws_instance" "prod_instance" {
  ami           = "${var.ami}" 
  instance_type = "${var.ami_type}"
  subnet_id = aws_subnet.prod_public_subnet.id
  user_data = "${file("init.sh")}"
  //security_groups = ["${aws_security_group.ec2_sg.id}"]
  tags = {
      Name = "Prod Instance"
  } 

}
