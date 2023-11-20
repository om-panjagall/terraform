resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "wordpress"
  }
}

resource "aws_db_instance" "wordpress" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "wordpress"
  username             = "admin"
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.wordpress.name
  backup_retention_period = 7  # Retention period for automated backups
  backup_window         = "02:00-03:00"  # Backup window timing

  tags = {
    Name = "wordpress"
  }
}

output "db_endpoint" {
  value = aws_db_instance.wordpress.endpoint
}