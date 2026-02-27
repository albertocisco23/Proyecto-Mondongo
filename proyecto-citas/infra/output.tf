############################
# NETWORKING
############################

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

############################
# EC2
############################

output "ec2_id" {
  description = "EC2 instance ID"
  value       = "Name"
}

output "ec2_public_ip" {
  description = "Public IP of EC2"
  value       = "Name"
}

############################
# ALB
############################

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.app_alb.arn
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.app_alb.dns_name
}

############################
# SECURITY GROUPS
############################

output "alb_security_group_id" {
  description = "Security Group ID of ALB"
  value       = aws_security_group.alb_sg.id
}

output "ec2_security_group_id" {
  description = "Security Group ID of EC2"
  value       = aws_security_group.allow_ssh_ec2.id
}
