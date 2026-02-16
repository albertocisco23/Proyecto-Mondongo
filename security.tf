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