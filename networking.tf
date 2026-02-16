module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "project-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-south-2a", "eu-south-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  create_database_subnet_group = true
  database_subnets = ["10.0.5.0/24", "10.0.6.0/24"]

  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}