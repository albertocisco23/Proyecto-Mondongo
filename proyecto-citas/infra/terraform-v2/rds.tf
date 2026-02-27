resource "random_password" "db_password" {
  length  = 20
  special = true
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "${local.name_prefix}-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_secret_v" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    dbname   = var.db_name
  })
}

resource "aws_db_subnet_group" "db_subnets" {
  name       = "${local.name_prefix}-db-subnets"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "postgres" {
  identifier        = "${local.name_prefix}-postgres"
  engine            = "postgres"
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  db_name           = var.db_name
  username          = var.db_username
  password          = random_password.db_password.result
  port              = 5432

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name

  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0

  tags = {
    Name = "${local.name_prefix}-postgres"
  }
}