data "aws_ami" "rstudio" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["rs-marketplace-gpu*"]
  }
}

data "aws_ami" "relevance" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["ec2-rstudio-server*"]
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = ">=2.0.0"
  count   = var.create_key ? 1 : 0

  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=3.14.2"

  name = "RStudio Server VPC"
  cidr = "10.0.0.0/16"

  azs            = [local.az]
  public_subnets = ["10.0.101.0/24"]

  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "ezrstudio"

  ami                    = lookup(local.ami_map, var.ami_type)
  instance_type          = lookup(local.instance_map, var.ami_type)
  key_name               = var.key_name
  monitoring             = var.monitoring
  vpc_security_group_ids = [module.rstudio_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  depends_on = [module.key_pair, module.vpc, module.rstudio_sg]
}


module "rstudio_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.9.0"

  name                = "rstudio-cuda"
  description         = "Security group to allow traffic for RStudio Server"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow port http traffic for RSTudio server Cuda image"
      vicr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8787
      to_port     = 8787
      protocol    = "tcp"
      description = "Allow port 8787 for Rstudio tenserflow image"
    }
  ]
}
