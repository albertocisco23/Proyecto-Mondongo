resource "aws_security_group" "allow_ssh_ec2" {
  name        = "allow-ssh-ec2"
  description = "Allow SSH access"
  vpc_id      = module.vpc.vpc_id
}

# Regla de entrada SSH (Puerto 22) desde cualquier IP
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ec2rule" {
  security_group_id = aws_security_group.allow_ssh_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Regla de salida (Permitir todo)
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ec2rule" {
  security_group_id = aws_security_group.allow_ssh_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "allow_mysql" {
  name        = "allow-mysql"
  description = "Allow MySQL access"
  vpc_id      = module.vpc.vpc_id
}


# Entrada postgresql puerto 5432
resource "aws_vpc_security_group_ingress_rule" "allow_mysql_rule" {
  security_group_id = aws_security_group.allow_mysql.id
  cidr_ipv4         = "0.0.0.0/0" # o la IP de tu EC2
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
}

# Salida libre
resource "aws_vpc_security_group_egress_rule" "allow_mysql_egress" {
  security_group_id = aws_security_group.allow_mysql.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = module.vpc.vpc_id
}

# Entrada HTTP desde Internet
resource "aws_vpc_security_group_ingress_rule" "alb_http_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Salida libre
resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}