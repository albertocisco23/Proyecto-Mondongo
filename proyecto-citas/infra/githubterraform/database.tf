resource "aws_db_instance" "default" {
  allocated_storage = 20
  storage_type = "gp3"
  engine = "postgres"
  engine_version = "17.6"
  instance_class = "db.t3.micro"
  identifier = "project-db"
  username = "dbadmin"
  manage_master_user_password = true

  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
  db_subnet_group_name = module.vpc.database_subnet_group_name

  skip_final_snapshot = true

}