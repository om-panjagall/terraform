terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source              = "./network"
  vpc_cidr_block      = var.vpc_cidr_block
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr  = var.public_subnet_cidr
}

module "ec2" {
  source            = "./ec2"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = [module.network.public_subnet_ids]
  ami               = var.ami
  instance_type     = var.instance_type
  security_groups = [ module.network.rds_security_group, module.network.wordpress_security_group ]
}

module "rds" {
  source = "./rds"
  #vpc_id = module.network.vpc_id
  db_password        = var.db_password
  private_subnet_ids = [module.network.private_subnet_ids]
}

module "backup" {
  source = "./backup"
}
