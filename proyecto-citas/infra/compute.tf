resource "aws_key_pair" "my_key" {
  key_name   = "bastion-key"
  public_key = file("bastion-key.pub")
}

resource "aws_instance" "bastion" {
  ami                         = "ami-026fbd7c6075fc91a"
  instance_type               = "t3.small"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.allow_ssh_ec2.id]
  key_name                    = aws_key_pair.my_key.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf upgrade -y
    dnf install postgresql -y
  EOF

  tags = {
    Name = "Project-instance"
  }
}
