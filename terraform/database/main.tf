# private subnet group
resource "aws_db_subnet_group" "private_sub_group" {
  name       = "rds-db-subnet-gourp"
  subnet_ids = var.private_sub_ids

  tags = {
    Name = "db-db-subnet-group"
    Project = "Seal"
  }
}


# RDS Instance
resource "aws_db_instance" "main_rds" {
  identifier              = "database-teman-soal"
  engine                  = "mysql"
  parameter_group_name    = "default.mysql8.0"

  username                = var.db_username
  password                = var.db_password
  instance_class          = "db.t3.small"

  db_subnet_group_name    = aws_db_subnet_group.private_sub_group.name
  vpc_security_group_ids  = var.db_security_group

  multi_az                = true

  storage_type            = "gp3"
  allocated_storage       = 25
  skip_final_snapshot     = true


  tags = {
    Name = "database-teman-soal"
    Project = "Seal"
  }
}