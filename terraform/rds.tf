resource "aws_db_subnet_group" "rds-subnet-group" {
  name = "rds-subnet-group"

  subnet_ids = [aws_subnet.private-1a.id,
    aws_subnet.private-1b.id

  ]

  tags = {
    Name = "supplier-rds-subnet-group"
  }
}
resource "aws_db_instance" "supplier-db" {

  identifier = "supplier-db"

  engine = "postgres"

  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "supliersdb"
  username = "ahmed"
  password = var.db_password

  port = 5432

  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]

  publicly_accessible = false

  skip_final_snapshot = true
}