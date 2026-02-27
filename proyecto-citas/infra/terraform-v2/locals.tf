data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  # Construye DATABASE_URL en runtime usando variables y hostname de RDS.
  # La contraseña la inyectamos vía Secrets Manager en la task definition.
  database_url_no_password = "postgresql+psycopg2://${var.db_username}:__PASSWORD__@${aws_db_instance.postgres.address}:5432/${var.db_name}"
}