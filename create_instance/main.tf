resource "aws_instance" "sample"{
    ami = "ami-0aeeebd8d2ab47354"
    instance_type = "t2.micro"
    key_name = "aws"
    
    tags = {
    Name = "sample"
  }
}