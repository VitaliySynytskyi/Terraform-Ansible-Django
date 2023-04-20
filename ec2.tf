locals {
  ssh_user         = "ubuntu"
  key_name         = "public"
  private_key_path = "public.pem"
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = local.key_name
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.nginx.id]
  count                       = 2

  tags = {
    Name = "app-${count.index + 1}"
  }
} 

resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = local.key_name
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [aws_security_group.private.id]

  tags = {
    Name = "db"
  }
} 
