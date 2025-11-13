
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# VPC
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "MainVPC", Environment = terraform.workspace }
}

# Subnet
module "subnet" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  tags              = { Name = "PublicSubnet", Environment = terraform.workspace }
}

# EC2
module "ec2" {
  source          = "./modules/ec2"
  ami             = "ami-0ca143b172aae70b7"
  instance_type   = "t2.micro"
  subnet_id       = module.subnet.subnet_id
  key_name        = "terraform-study-aws"
  tags            = { Name = "WebServer", Environment = terraform.workspace }
}

# IAM
module "iam_role" {
  source = "./modules/iam"
  name   = "ec2-role-${terraform.workspace}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
  tags = { Name = "EC2Role", Environment = terraform.workspace }
}

# Lambda
module "lambda" {
  source        = "./modules/lambda"
  function_name = "hello_lambda_${terraform.workspace}"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role_arn      = module.iam_role.role_arn
  filename      = "${path.module}/lambda.zip"
  tags          = { Name = "HelloLambda", Environment = terraform.workspace }
}

# RDS
module "rds" {
  source              = "./modules/rds"
  identifier          = "app-db-${terraform.workspace}"
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "admin"
  password            = var.db_password
  security_group_ids  = []
  skip_final_snapshot = true
  tags                = { Name = "AppDatabase", Environment = terraform.workspace }
}

