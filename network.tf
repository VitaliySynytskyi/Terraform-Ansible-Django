# Cтворення власного VPC та його потрібностей
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
}

resource "aws_security_group" "nginx" {
  name   = "nginx_access"
  description = "Allow Web inbound traffic"
  vpc_id = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = ["80", "8000", "22"]
    content {
      description = "HTTP, SSH ports"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
  name        = "private"
  description = "Allow db inbound traffic"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = ["5432", "22"]
    content {
      description = "Postgres, SSH ports"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp" 
      cidr_blocks = ["${aws_instance.app.*.private_ip[0]}/32", "${aws_instance.app.*.public_ip[1]}/32"]
    }
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}